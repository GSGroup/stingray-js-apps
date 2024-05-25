// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import { SubscriptionState } from 'stingray/caSubscriptions';
import { FeatureHolder, SignalConnection } from 'stingray/utils'

export class DrmSubscription {
	public name: string;
	public isActive: boolean;
	public serviceCode: string;
	public startTime: Date;
	public endTime: Date;

	public constructor(name: string, isActive: boolean, serviceCode: string, startTime: (Date | null), endTime: (Date | null)) {
		this.name = name;
		this.isActive = isActive;
		this.serviceCode = serviceCode;
		this.startTime = startTime;
		this.endTime = endTime;
	}

	public toString(): string {
		return `{ name: ${this.name}, isActive: ${this.isActive}, serviceCode: ${this.serviceCode}, startTime: ${this.startTime}, endTime: ${this.endTime} }`;
	}
}

class DrmSubscriptionConnection extends SignalConnection {
	private casInfo: stingray.IConditionalAccessInfoPtr;
	private slot: (subscriptions: Array<DrmSubscription>) => void;

	private subscriptionsListener: stingray.ISubscriptionsListenerPtr;
	private subscriptionsListenerConnection: stingray.SignalConnection;
	private casInfoConnection: stingray.SignalConnection;

	public constructor(casInfo: stingray.IConditionalAccessInfoPtr, slot: (subscriptions: Array<DrmSubscription>) => void) {
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
				const subscriptions: Array<DrmSubscription> = [];

				subscriptionLeases.forEach((subscriptionLease: stingray.ISubscriptionLeasePtr) => {
					const drmSubscription: stingray.IDrmSubscriptionPtr = subscriptionLease.GetDrmSubscription();
					const interval: stingray.TimeInterval = subscriptionLease.GetTimeInterval();

					subscriptions.push(new DrmSubscription(
						drmSubscription.GetName().GetAnyTranslation(),
						SubscriptionState.fromValue(subscriptionLease.GetState()) == SubscriptionState.Active,
						drmSubscription.GetServiceCode(),
						new Date(interval.GetStart().ToIso8601()),
						new Date(interval.GetEnd().ToIso8601())));
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

export class Drm extends FeatureHolder<stingray.ICasFeaturePtr> {
	private id: (string | null) = null;

	private readonly casInfo: stingray.IConditionalAccessInfoPtr;
	private readonly casInfoConnection: stingray.SignalConnection;

	public constructor() {
		super(app.Cas());

		this.casInfo = this.getFeature().GetDrmCasInfo();

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

	public onSubscriptionsChanged(slot: (subscriptions: Array<DrmSubscription>) => void): SignalConnection {
		if (!this.casInfo)
			return new SignalConnection();
		return new DrmSubscriptionConnection(this.casInfo, slot);
	}
}

export const Feature = new Drm();
