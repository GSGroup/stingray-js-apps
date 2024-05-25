// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import { SubscriptionState } from 'stingray/caSubscriptions';
import { FeatureHolder, SignalConnection } from 'stingray/utils'

export class DrePackage {
	public id: number;
	public state: boolean;

	constructor(id: number, state: boolean) {
		this.id = id;
		this.state = state;
	}

	public toString(): string {
		return `{ id: ${this.id}, state: ${this.state} }`;
	}
}

export class DreSubscription {
	public name: string;
	public classId: number;
	public state: SubscriptionState;
	public startTime: (Date | null);
	public endTime: (Date | null);
	public packages: Array<DrePackage>

	public constructor(name: string, classId: number, state: SubscriptionState, startTime: (Date | null), endTime: (Date | null), packages: Array<DrePackage>) {
		this.name = name;
		this.classId = classId;
		this.state = state;
		this.startTime = startTime;
		this.endTime = endTime;
		this.packages = packages;
	}

	public toString(): string {
		return `{ name: ${this.name}, classId: ${this.classId}, state: ${SubscriptionState[this.state]}, startTime: ${this.startTime}, endTime: ${this.endTime}, packages: ${this.packages} }`;
	}
}

class DreSubscriptionConnection extends SignalConnection {
	private casInfo: stingray.IConditionalAccessInfoPtr;
	private slot: (subscriptions: Array<DreSubscription>) => void;

	private subscriptionsListener: stingray.ISubscriptionsListenerPtr;
	private subscriptionsListenerConnection: stingray.SignalConnection;
	private casInfoConnection: stingray.SignalConnection;

	public constructor(casInfo: stingray.IConditionalAccessInfoPtr, slot: (subscriptions: Array<DreSubscription>) => void) {
		super();

		this.casInfo = casInfo;
		this.slot = slot;

		this.casInfoConnection = this.casInfo.OnUserIdentityChanged().connect((userIdentity: stingray.IConditionalAccessUserIdentityPtr) => {
			if (!userIdentity)
			{
				if (this.subscriptionsListenerConnection)
					this.subscriptionsListenerConnection.disconnect();
				this.subscriptionsListener = null;
				this.slot([]);
				return;
			}

			this.subscriptionsListener = userIdentity.GetSubscriptionsListener();
			this.subscriptionsListenerConnection = this.subscriptionsListener.OnSubscriptionsChanged().connect((subscriptionLeases: stingray.ISubscriptionLeasePtrEnumerablePtr) => {
				let subscriptions: Array<DreSubscription> = [];

				subscriptionLeases.forEach((subscriptionLease: stingray.ISubscriptionLeasePtr) => {
					const dreSubscription: stingray.IDreSubscriptionPtr = subscriptionLease.GetDreSubscription();
					const interval: stingray.TimeInterval = subscriptionLease.GetTimeInterval();

					let subscriptionPackages: Array<DrePackage> = [];
					subscriptionLease.GetPackages().forEach((lease: stingray.ISubscriptionLeasePtr) => {
						subscriptionPackages.push(new DrePackage(lease.GetDreSubscription().GetClassId(), lease.GetState() == SubscriptionState.Active));
					});

					subscriptions.push(new DreSubscription(
						dreSubscription.GetName().GetAnyTranslation(),
						dreSubscription.GetClassId(),
						SubscriptionState.fromValue(subscriptionLease.GetState()),
						interval ? new Date(interval.GetStart().ToIso8601()) : null,
						interval ? new Date(interval.GetEnd().ToIso8601()) : null,
						subscriptionPackages.length ? subscriptionPackages : [ new DrePackage(dreSubscription.GetClassId(), subscriptionLease.GetState() == SubscriptionState.Active) ]));
				});

				this.slot(subscriptions);
			});
		});
	}

	public disconnect(): void {
		this.casInfoConnection.disconnect();
		if (this.subscriptionsListenerConnection)
			this.subscriptionsListenerConnection.disconnect();
		this.subscriptionsListener = null;
		this.slot = null;
		this.casInfo = null;
	}
}

export class Cas extends FeatureHolder<stingray.ICasFeaturePtr> {
	private id: (string | null) = null;

	private readonly casInfo: stingray.IConditionalAccessInfoPtr;
	private readonly casInfoConnection: stingray.SignalConnection;

	public constructor() {
		super(app.Cas());

		this.casInfo = this.getFeature().GetDreCasInfo();

		if (!this.casInfo)
			return;

		this.casInfoConnection = this.casInfo.OnUserIdentityChanged().connect(
			(userIdentity: stingray.IConditionalAccessUserIdentityPtr) => this.id = userIdentity ? userIdentity.GetId() : null
		);
	}

	public get dreId(): (string | null) {
		return this.id;
	}

	public onDreIdChanged(slot: (dreId: (string | null)) => void): SignalConnection {
		if (!this.casInfo)
			return new SignalConnection();
		return new SignalConnection(this.casInfo.OnUserIdentityChanged().connect(
			(userIdentity: stingray.IConditionalAccessUserIdentityPtr) => slot(userIdentity ? userIdentity.GetId() : null)
		));
	}

	public onSubscriptionsChanged(slot: (subscriptions: Array<DreSubscription>) => void): SignalConnection {
		if (!this.casInfo)
			return new SignalConnection();
		return new DreSubscriptionConnection(this.casInfo, slot);
	}
}

export const Feature = new Cas();
