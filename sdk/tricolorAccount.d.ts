// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

/// <reference path="collections.d.ts" />
/// <reference path="feature.d.ts" />
/// <reference path="misc.d.ts" />

declare namespace stingray {

	/**
	 * Basic information about abonent.
	 */
	export interface AbonentPersonalDataPtr {
		GetEmail(): string | null;
		GetPhoneNumber(): string | null;
	}

	/**
	 * Abstraction that can be used to obtain transaction apply success or error using the appropriate {@link Signal}
	 */
	export interface ITricolorPaymentTransactionApplyResponsePtr {
		OnSuccess(): Signal<[]>;
		OnError(): Signal<[error: TranslatedString]>;
	}

	/**
	 * Abstraction that can be used to obtain {@link ITricolorPaymentTransactionApplyResponsePtr}
	 */
	export interface ITricolorPaymentTransactionPtr {
		GetPaymentFormUri(): string;
		GetPaymentUri(): string;
		Apply(): ITricolorPaymentTransactionApplyResponsePtr;
	}

	/**
	 * Abstraction that can be used to obtain payment form getting success or error using the appropriate {@link Signal}
	 */
	export interface IGetPaymentFormResponsePtr {
		OnSuccess(): Signal<[transaction: ITricolorPaymentTransactionPtr]>;
		OnError(): Signal<[error: TranslatedString]>;
	}

	/**
	 * Abstraction that can be used to obtain payment form getting success or error using the appropriate {@link Signal}
	 */
	export interface IGetPaymentUriResponsePtr {
		OnSuccess(): Signal<[transaction: ITricolorPaymentTransactionPtr]>;
		OnError(): Signal<[error: TranslatedString]>;
	}

	/**
	 * Abstraction that can be used to obtain direct payment success or error using the appropriate {@link Signal}
	 */
	export interface IDirectPaymentResponsePtr {
		OnSuccess(): Signal<[data: string]>;
		OnError(): Signal<[error: TranslatedString]>;
	}

	/**
	 * Basic information about purchase tariff.
	 */
	export interface TricolorPurchaseTariffInfoPtr {
		GetId(): string | null;
		GetServiceId(): string | null;
		GetName(): string | null;
		GetPrice(): string | null;
		ToString(): string;
	}

	/**
	 * Abstraction that can be used to pay for selected purchase item. There is two options for this:
	 * get {@link IGetPaymentUriResponsePtr} or {@link IDirectPaymentResponsePtr}
	 */
	export interface ITricolorPurchaseTariffPtr {
		GetInfo(): TricolorPurchaseTariffInfoPtr;
		GetPaymentForm(createBindingFlag: boolean, phoneNumber: string | null, email: string | null, debtAmount: Decimal | null): IGetPaymentFormResponsePtr;
		GetPaymentUri(createBindingFlag: boolean, phoneNumber: string | null, email: string | null, debtAmount: Decimal | null): IGetPaymentUriResponsePtr;
		Pay(cardInfo: TricolorPaymentCardInfoPtr, phoneNumber: string | null, email: string | null, debtAmount: Decimal | null): IDirectPaymentResponsePtr;
	}
	type ITricolorPurchaseTariffsPtr = IEnumerable<ITricolorPurchaseTariffPtr>;

	/**
	 * Abstraction that representing item to purchase, its name and {@link ITricolorPurchaseTariffsPtr}
	 */
	export interface ITricolorPurchaseItemPtr {
		GetName(): string;
		GetTariffs(): ITricolorPurchaseTariffsPtr;
	}
	type ITricolorPurchaseItemsPtr = IObservableList<ITricolorPurchaseItemPtr>;

	/**
	 * Basic information about payment card.
	 */
	export class TricolorPaymentCardInfoPtr {
		constructor(id: string, pan: string, type: string, isAutoPaymentEnabled: boolean);

		GetId(): string;
		GetPan(): string;
		GetType(): string;
		IsAutoPaymentEnabled(): boolean
		ToString(): string;
	}
	type ITricolorPaymentCardInfosPtr = IObservableList<TricolorPaymentCardInfoPtr>;

	/**
	 * Abstraction used for tricolor account payments. That provides access to
	 * {@link AbonentPersonalDataPtr} {@link ITricolorPurchaseItemsPtr} {@link ITricolorPaymentCardInfosPtr}
	 */
	export interface ITricolorPaymentGatewayPtr {
		OnAbonentPersonalData(): Signal<[AbonentPersonalDataPtr]>;
		GetPurchaseItems(): ITricolorPurchaseItemsPtr;
		GetCards(): ITricolorPaymentCardInfosPtr;
	}

	/**
	 * {@link IFeature} representing a module of a digital rights management system that provides
	 * the related functionality and information.
	 */
	export interface ITricolorAccountPtr extends IFeature {
		/**
		 * Function that provides access to {@link ITricolorPaymentGatewayPtr}
		 */
		GetPaymentGateway(): ITricolorPaymentGatewayPtr;
	}

}
