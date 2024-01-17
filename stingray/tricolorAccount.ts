// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TOR TIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import { ConnectionPool, FeatureHolder, SignalConnection, CollectionOp, collectionOpFromValue } from 'stingray/utils'

export enum AccountCallResult {
	Success,
	Error
}

export class TricolorPaymentCardInfo {
	public readonly id: string;
	public readonly pan: string;
	public readonly type: string;
	public readonly isAutoPaymentEnabled: boolean;

	public constructor(nativeInfo: stingray.TricolorPaymentCardInfoPtr) {
		this.id = nativeInfo.GetId();
		this.pan = nativeInfo.GetPan();
		this.type = nativeInfo.GetType();
		this.isAutoPaymentEnabled = nativeInfo.IsAutoPaymentEnabled();
	}
}

export class TricolorPaymentTransaction {
	private readonly nativeTransaction: stingray.ITricolorPaymentTransactionPtr;

	private applyResponse: stingray.ITricolorPaymentTransactionApplyResponsePtr;
	private connections: ConnectionPool;

	public applyCallback: (resultType: AccountCallResult, result: string | null) => void

	public constructor(nativeTransaction: stingray.ITricolorPaymentTransactionPtr) {
		this.nativeTransaction = nativeTransaction;
		this.applyCallback = () => void 0;
	}

	public get uri(): string {
		return this.nativeTransaction.GetPaymentFormUri();
	}

	public apply(): void {
		this.applyResponse = this.nativeTransaction.Apply();
		this.connections.add(new SignalConnection(this.applyResponse.OnSuccess().connect(() => {
			this.applyCallback(AccountCallResult.Success, null);
		})));
		this.connections.add(new SignalConnection(this.applyResponse.OnError().connect((error: stingray.TranslatedString) => {
			this.applyCallback(AccountCallResult.Error, error.GetAnyTranslation());
		})));
	}
}

export class TricolorPurchaseTariff {
	private readonly nativeTariff: stingray.ITricolorPurchaseTariffPtr;

	private payResponse: stingray.IDirectPaymentResponsePtr;
	private requestPaymentFormResponse: stingray.IGetPaymentFormResponsePtr;
	private payConnections: ConnectionPool;
	private requestPaymentFormConnections: ConnectionPool;

	public requestPaymentFormCallback: (resultType: AccountCallResult, result: TricolorPaymentTransaction | string) => void
	public payCallback: (resultType: AccountCallResult, result: string) => void

	public constructor(nativeTariff: stingray.ITricolorPurchaseTariffPtr) {
		this.nativeTariff = nativeTariff;
		this.requestPaymentFormCallback = () => void 0;
		this.payCallback = () => void 0;
	}

	public get id(): string | null {
		return this.nativeTariff.GetInfo().GetId();
	}

	public get serviceId(): string | null {
		return this.nativeTariff.GetInfo().GetServiceId();
	}

	public get name(): string | null {
		return this.nativeTariff.GetInfo().GetName();
	}

	public get price(): string | null {
		return this.nativeTariff.GetInfo().GetPrice();
	}

	public requestPaymentForm(createBindingFlag, phoneNumber?: string, email?: string, debtAmount?: string): void {
		this.requestPaymentFormResponse = this.nativeTariff.GetPaymentForm(createBindingFlag, phoneNumber, email, debtAmount ? new stingray.Decimal(debtAmount) : null);
		this.requestPaymentFormConnections.add(new SignalConnection(this.requestPaymentFormResponse.OnSuccess().connect((nativeTransaction: stingray.ITricolorPaymentTransactionPtr) => {
			this.requestPaymentFormCallback(AccountCallResult.Success, new TricolorPaymentTransaction(nativeTransaction));
		})));
		this.requestPaymentFormConnections.add(new SignalConnection(this.requestPaymentFormResponse.OnError().connect((error: stingray.TranslatedString) => {
			this.requestPaymentFormCallback(AccountCallResult.Error, error.GetAnyTranslation());
		})));
	}

	public abortPaymentFormRequest(): void {
		this.requestPaymentFormConnections.release();
		this.requestPaymentFormResponse = null;
	}

	public pay(cardInfo?: TricolorPaymentCardInfo, phoneNumber?: string, email?: string, debtAmount?: string): void {
		const nativeCardInfo: stingray.TricolorPaymentCardInfoPtr = cardInfo ? new stingray.TricolorPaymentCardInfoPtr(cardInfo.id, cardInfo.pan, cardInfo.type, cardInfo.isAutoPaymentEnabled) : null;
		const nativeDebtAmount: stingray.Decimal = debtAmount ? new stingray.Decimal(debtAmount) : null;

		this.payResponse = this.nativeTariff.Pay(nativeCardInfo, phoneNumber, email, nativeDebtAmount);
		this.payConnections.add(new SignalConnection(this.payResponse.OnSuccess().connect((sucessMessage: string) => {
			this.payCallback(AccountCallResult.Success, sucessMessage);
		})));
		this.payConnections.add(new SignalConnection(this.payResponse.OnError().connect((error: stingray.TranslatedString) => {
			this.payCallback(AccountCallResult.Error, error.GetAnyTranslation());
		})));
	}

	public abortPayment(): void {
		this.payConnections.release();
		this.payResponse = null;
	}
}

export class TricolorPurchaseItem {
	public readonly name: string;
	public readonly tariffs: TricolorPurchaseTariff[] = new Array<TricolorPurchaseTariff>();

	public constructor(nativeItem: stingray.ITricolorPurchaseItemPtr) {
		this.name = nativeItem.GetName();
		nativeItem.GetTariffs().forEach(tariff => this.tariffs.push(new TricolorPurchaseTariff(tariff)));
	}
}

export class TricolorAccount extends FeatureHolder<stingray.ITricolorAccountPtr> {
	public constructor() {
		super(app.TricolorAccount());
	}

	public onCardListChanged(slot: (op: CollectionOp, idx: number, item: TricolorPaymentCardInfo) => void): SignalConnection {
		return new SignalConnection(this.getPaymentGateway().GetCards().OnChanged().connect((op: number, idx: number, item: stingray.TricolorPaymentCardInfoPtr) => {
			slot(collectionOpFromValue(op), idx, new TricolorPaymentCardInfo(item));
		}));
	}

	public onPurchaseItemListChanged(slot: (op: CollectionOp, idx: number, item: TricolorPurchaseItem) => void): SignalConnection {
		return new SignalConnection(this.getPaymentGateway().GetPurchaseItems().OnChanged().connect((op: number, idx: number, item: stingray.ITricolorPurchaseItemPtr) => {
			slot(collectionOpFromValue(op), idx, new TricolorPurchaseItem(item));
		}));
	}

	public onAbonentPersonalData(slot: (email?: string, phoneNumber?: string) => void): SignalConnection {
		return new SignalConnection(this.getPaymentGateway().OnAbonentPersonalData().connect((nativeData: stingray.AbonentPersonalDataPtr) => {
			slot(nativeData ? nativeData.GetEmail() : null, nativeData ? nativeData.GetPhoneNumber() : null);
		}));
	}

	private getPaymentGateway(): stingray.ITricolorPaymentGatewayPtr {
		return this.getFeature().GetPaymentGateway();
	}
}

export const Feature = new TricolorAccount();
