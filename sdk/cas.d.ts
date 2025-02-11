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
	 * Class representing a subscription
	 */
	export interface ISubscriptionPtr {
		GetName(): TranslatedString;
	}

	/**
	 * Class representing a dre subscription
	 */
	export interface IDreSubscriptionPtr extends ISubscriptionPtr {
		GetClassId(): number;
	}

	/**
	 * Class representing a drm subscription
	 */
	export interface IDrmSubscriptionPtr extends ISubscriptionPtr {
		GetServiceCode(): string;
	}

	/**
	 * Class representing a dre subscription lease
	 */
	export interface ISubscriptionLeasePtr {
		GetDreSubscription(): (IDreSubscriptionPtr | null);
		GetDrmSubscription(): (IDrmSubscriptionPtr | null);
		GetTimeInterval(): (TimeInterval | null);
		GetState(): number;
		IsVisible(): boolean;
		GetPackages(): ISubscriptionLeasePtrEnumerablePtr;
	}
	type ISubscriptionLeasePtrEnumerablePtr = IEnumerable<ISubscriptionLeasePtr>;

	/**
	 * Class that can be used to obtain {@link ISubscriptionLeasePtrEnumerablePtr}
	 */
	export interface ISubscriptionsListenerPtr {
		OnSubscriptionsChanged(): Signal<[ISubscriptionLeasePtrEnumerablePtr]>;
	}

	/**
	 * Class that can be used to obtain dre id and subscriptions
	 */
	export interface IConditionalAccessUserIdentityPtr {
		GetId(): string;
		GetSubscriptionsListener(): ISubscriptionsListenerPtr;
	}

	/**
	 * Class that can be used to obtain {@link IConditionalAccessUserIdentityPtr}
	 */
	export interface IConditionalAccessInfoPtr {
		OnUserIdentityChanged(): Signal<[userIdentity: IConditionalAccessUserIdentityPtr]>;
	}

	/**
	 * {@link IFeature} representing a module of a digital rights management system that provides
	 * the related functionality and information.
	 */
	export interface ICasFeaturePtr extends IFeature {
		/**
		 * Function that provides access to dre {@link IConditionalAccessInfoPtr}
		 */
		GetDreCasInfo(): IConditionalAccessInfoPtr;
		/**
		 * Function that provides access to drm {@link IConditionalAccessInfoPtr}
		 */
		GetDrmCasInfo(): IConditionalAccessInfoPtr;
	}

}
