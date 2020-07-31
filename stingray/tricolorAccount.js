// Copyright (c) 2011 - 2020, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

const utils = require("stingray", "details/tricolorAccountUtils.js");

/**
 * Enum used in all tricolor account remote requests as result type.
 */
const AccountCallResult = {
	Success: 0,
	Error: 1
};
this.AccountCallResult = AccountCallResult;

/**
 * Class representing payment transaction. Used to obtain a url of payment form and to finish
 * transaction by updating tricolor account payment resources with apply method.
 */
function PaymentTransaction(transaction) {
	utils.PaymentTransactionFactory.create(this, transaction);
}

PaymentTransaction.prototype = {
	/**
	 * Constructor that used primarily by system.
	 */
	constructor: PaymentTransaction,

	/**
	 * Function that provides access to url of the payment form. Use it to interact with the payment gateway.
	 *
	 * arguments types: none
	 * return type: string
	 */
	getUrl: function () { },

	/**
	 * Function property that used as callback which will be called when response to apply
	 * is received. Set your function there to handle result.
	 *
	 * arguments types:
	 *   - resultType: AccountCallResult
	 *   - result:
	 *       null:   if resultType = AccountCallResult.Success
	 *       string: if resultType = AccountCallResult.Error
	 * return type: void
	 */
	applyCallback: function (resultType, result) { },

	/**
	 * Function that used to to finish transaction by updating tricolor account payment resources. Use it
	 * after success interaction with payment gateway.
	 *
	 * arguments types: none
	 * return type: void
	 */
	apply: function () { },

	/**
	 * Function that used to abort current applying request.
	 */
	abortApplyingRequest: function () { },

	/**
	 * Function that used to get string representation of the class and grants the ability to use the class
	 * as an argument to loggers.
	 *
	 * arguments types: none
	 * return type: string
	 */
	toString: function () { }
};
this.PaymentTransaction = PaymentTransaction;

/**
 * Class representing available tariff for provider offered purchase item.
 */
function PurchaseTariff(tariff) {
	utils.PurchaseTariffFactory.create(this, tariff);
}

PurchaseTariff.prototype = {
	/**
	 * Constructor that used primarily by system.
	 */
	constructor: PurchaseTariff,

	/**
	 * Function that provides access to tariff identifier.
	 *
	 * arguments types: none
	 * return type: string
	 */
	getId: function() { },

	/**
	 * Function that provides access to a service identifier associated with this tariff.
	 *
	 * arguments types: none
	 * return type: string
	 */
	getServiceId: function() { },

	/**
	 * Function that provides access to tariff name.
	 *
	 * arguments types: none
	 * return type: string
	 */
	getName: function() { },

	/**
	 * Function that provides access to tariff price in string represented decimal number.
	 *
	 * arguments types: none
	 * return type: string
	 */
	getPrice: function() { },

	/**
	 * Function property that used as callback which will be called when response to requestPaymentForm
	 * is received. Set your function there to handle result.
	 *
	 * arguments types:
	 *   - resultType: AccountCallResult
	 *   - result:
	 *      PaymentTransaction: if resultType = AccountCallResult.Success
	 *      string:             if resultType = AccountCallResult.Error
	 * return type: void
	 */
	requestPaymentFormCallback: function (resultType, result) { },

	/**
	 * Function that used to request payment form. The result to this request will be caught
	 * in requestPaymentFormCallback.
	 *
	 * arguments types:
	 *   - createBindingFlag: bool
	 *   - phoneNumber: optional string
	 *   - email: optional string
	 *   - debtAmount: optional string
	 * return type: void
	 */
	requestPaymentForm: function (createBindingFlag, phoneNumber, email, debtAmount) { },

	/**
	 * Function that used to abort current payment form request.
	 */
	abortPaymentFormRequest: function () { },

	/**
	 * Function property that used as callback which will be called when response to pay
	 * is received. Set your function there to handle result.
	 *
	 * arguments types:
	 *   - resultType: AccountCallResult
	 *   - result: string - success or error message
	 * return type: void
	 */
	payCallback: function (resultType, result) { },

	/**
	 * Function that used to pay for current tariff by linked card. The result to this request will be caught
	 * in payCallback.
	 *
	 * arguments types:
	 *   - cardInfo: optional PaymentCardInfo
	 *   - phoneNumber: optional string
	 *   - email: optional string
	 *   - debtAmount: optional string
	 * return type: void
	 */
	pay: function (cardInfo, phoneNumber, email, debtAmount) { },

	/**
	 * Function that used to abort current pay request.
	 */
	abortPayment: function () { },

	/**
	 * Function that used to get string representation of the class and grants the ability to use the class
	 * as an argument to loggers.
	 *
	 * arguments types: none
	 * return type: string
	 */
	toString: function () { }
};
this.PurchaseTariff = PurchaseTariff;


/**
 * Class representing a provider offered purchase item.
 */
function PurchaseItem(item) {
	utils.PurchaseItemFactory.create(this, item);
}

PurchaseItem.prototype = {
	/**
	 * Constructor that used primarily by system.
	 */
	constructor: PurchaseItem,

	/**
	 * Function that provides access to purchase item name.
	 *
	 * arguments types: none
	 * return type: string
	 */
	getName: function () { },

	/**
	 * Function that provides access to available tariff list for this purchase item.
	 *
	 * arguments types: none
	 * return type: Array<PurchaseTariff>
	 */
	getTariffs: function () { },

	/**
	 * Function that used to get string representation of the class and grants the ability to use the class
	 * as an argument to loggers.
	 *
	 * arguments types: none
	 * return type: string
	 */
	toString: function () { }
};
this.PurchaseItem = PurchaseItem;


/**
 * Class representing a linked user payment card information.
 */
function PaymentCardInfo(info) {
	utils.PaymentCardInfoFactory.create(this, info);
}

PaymentCardInfo.prototype = {
	/**
	 * Constructor that used primarily by system.
	 */
	constructor: PaymentCardInfo,

	/**
	 * Function that provides access to user payment card identifier.
	 *
	 * arguments types: none
	 * return type: string
	 */
	getId: function() { },

	/**
	 * Function that provides access to masked payment card number.
	 *
	 * arguments types: none
	 * return type: string
	 */
	getPan: function() { },

	/**
	 * Function that provides access to user payment card type(Visa, MasterCard, etc...).
	 *
	 * arguments types: none
	 * return type: string
	 */
	getType: function() { },

	/**
	 * Function that provides access to flag which indicates whether automatic payment is enabled for this card.
	 *
	 * arguments types: none
	 * return type: boolean
	 */
	isAutoPaymentEnabled: function() { },

	/**
	 * Function that used to get string representation of the class and grants the ability to use the class
	 * as an argument to loggers.
	 *
	 * arguments types: none
	 * return type: string
	 */
	toString: function() { }
};
this.PaymentCardInfo = PaymentCardInfo;

/**
 * Static class representing a tricolor account module that provides
 * the ability to manage tricolor user services and related information.
 */
const TricolorAccount = {
	/**
	 * Signal that provides access to linked user payment cards
	 *
	 * arguments types:
	 *   - slot: void function (misc.CollectionOp: op, int: idx, PaymentCardInfo: item)
	 * return type: misc.SignalConnection
	 * populator: true
	 */
	onCardListChanged: function(slot) { },

	/**
	 * Signal that provides access to available purchase items
	 *
	 * arguments types:
	 *   - slot: void function (misc.CollectionOp: op, int: idx, PurchaseItem: item)
	 * return type: misc.SignalConnection
	 * populator: true
	 */
	onPurchaseItemListChanged: function(slot) { },

	/**
	 * Signal that provides access to available purchase items
	 *
	 * arguments types:
	 *   - slot: void function (optional string: email, optional string: phoneNumber)
	 * return type: misc.SignalConnection
	 * populator: true
	 */
	onAbonentPersonalData: function(slot) { }
};
utils.setInterfacesAccessor(this);
utils.TricolorAccountFactory.create(TricolorAccount);

this.Feature = TricolorAccount;
