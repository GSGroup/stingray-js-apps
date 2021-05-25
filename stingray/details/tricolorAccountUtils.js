// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

const stingrayUtils = require("stingray", "misc.js");

const Interfaces = {
	accessor: null
}

this.setInterfacesAccessor = function (accessor) {
	Interfaces.accessor = accessor;
};

const TricolorAccountFactory = {
	create: function (object) {
		try {
			this.constructor.call(object);
		}
		catch (e) {
			object = undefined;
			error("Can't create tricolor account feature: " + e);
		}
	},

	constructor: function () {
		TricolorAccountFactory.checkFeature(app.TricolorAccount());

		this.onCardListChanged = TricolorAccountFactory.onCardListChanged.bind(this);
		this.onPurchaseItemListChanged = TricolorAccountFactory.onPurchaseItemListChanged.bind(this);
		this.onAbonentPersonalData = TricolorAccountFactory.onAbonentPersonalData.bind(this);
	},

	onCardListChanged: function (slot) {
		var connection = TricolorAccountFactory.getFeature().GetPaymentGateway().GetCards().OnChanged().connect(function (op, idx, item) {
			slot(op, idx, new Interfaces.accessor.PaymentCardInfo(item));
		});
		return new stingrayUtils.SignalConnection(connection);
	},

	onPurchaseItemListChanged: function (slot) {
		var connection = TricolorAccountFactory.getFeature().GetPaymentGateway().GetPurchaseItems().OnChanged().connect(function (op, idx, item) {
			slot(op, idx, new Interfaces.accessor.PurchaseItem(item));
		});
		return new stingrayUtils.SignalConnection(connection);
	},

	onAbonentPersonalData: function (slot) {
		var connection = TricolorAccountFactory.getFeature().GetPaymentGateway().OnAbonentPersonalData().connect(function (data) {
			var email = null;
			var phoneNumber = null;

			if (data)
			{
				if (data.GetEmail())
					email = data.GetEmail().get();

				if (data.GetPhoneNumber())
					phoneNumber = data.GetPhoneNumber().get();
			}

			slot(email, phoneNumber);
		});
		return new stingrayUtils.SignalConnection(connection);
	},

	checkFeature: function(feature) {
		if (!feature.IsFeatureValid())
			throw "Feature is not valid!";
	},

	getFeature: function() {
		var feature = app.TricolorAccount();
		TricolorAccountFactory.checkFeature(feature);
		return feature;
	}
};
this.TricolorAccountFactory = TricolorAccountFactory;

const PaymentCardInfoFactory = {
	create: function (object, native) {
		this.constructor.call(object, native);
	},

	constructor: function (native) {
		this._native = native;

		this.getId = function () { return this._native.GetId(); }
		this.getPan = function () { return this._native.GetPan(); }
		this.getType = function () { return this._native.GetType(); }
		this.isAutoPaymentEnabled = function () { return this._native.IsAutoPaymentEnabled(); }
		this.toString = PaymentCardInfoFactory.toString.bind(this);

	},

	toString: function () {
		return "{ " +
			"id: " + this.getId() + ", " +
			"pan: " + this.getPan() + ", " +
			"type: " + this.getType() + ", " +
			"isAutoPaymentEnabled: " + this.isAutoPaymentEnabled() +
		" }";
	}
};
this.PaymentCardInfoFactory = PaymentCardInfoFactory;

const PurchaseItemFactory = {
	create: function (object, native) {
		this.constructor.call(object, native);
	},

	constructor: function (native) {
		this._native = native;

		this._tariffs = [];
		this.getTariffs = function () { return this._tariffs; };
		this.getName = function () { return this._native.GetName(); }
		this.toString = PurchaseItemFactory.toString.bind(this);

		this._native.GetTariffs().forEach(function (tariff) {
			this._tariffs.push(new Interfaces.accessor.PurchaseTariff(tariff));
		}.bind(this));
	},

	toString: function () {
		return "{ " +
			"name: " +		this.getName()		+ ", " +
			"tariffs: [ " +	this.getTariffs()	+ "] " +
		"}";
	}
};
this.PurchaseItemFactory = PurchaseItemFactory;

const PurchaseTariffFactory = {
	create: function (object, native) {
		this.constructor.call(object, native);
	},

	constructor: function (native) {
		this._native = native;

		this._requestPaymentFormConnections = [];
		this._requestPaymentFormAsyncResponse = null;

		this._payConnections = [];
		this._payAsyncResponse = null;

		this.getId = function () { return PurchaseTariffFactory.getValueOrNull(this._native.GetInfo().GetId()); };
		this.getServiceId = function () { return PurchaseTariffFactory.getValueOrNull(this._native.GetInfo().GetServiceId()); };
		this.getName = function () { return PurchaseTariffFactory.getValueOrNull(this._native.GetInfo().GetName()); };
		this.getPrice = function () { return PurchaseTariffFactory.getValueOrNull(this._native.GetInfo().GetPrice()).ToString(); };
		this.requestPaymentForm = PurchaseTariffFactory.requestPaymentForm.bind(this);
		this.abortPaymentFormRequest = PurchaseTariffFactory.resetPaymentFormRequest.bind(this, true);
		this.pay = PurchaseTariffFactory.pay.bind(this);
		this.abortPayment = PurchaseTariffFactory.resetPayment.bind(this, true);
		this.toString = PurchaseTariffFactory.toString.bind(this);
	},

	requestPaymentForm: function (createBindingFlag, phoneNumber, email, debtAmount) {
		PurchaseTariffFactory.resetPaymentFormRequest.call(this, true);

		var optionalPhoneNumber =  phoneNumber ? new stingray.OptionalString(phoneNumber) : null;
		var optionalEmail =  email ? new stingray.OptionalString(email) : null;
		var optionalDebtAmount =  debtAmount ? new stingray.OptionalDecimal(debtAmount) : null;

		this._requestPaymentFormAsyncResponse = this._native.GetPaymentForm(createBindingFlag, optionalPhoneNumber, optionalEmail, optionalDebtAmount);

		this._requestPaymentFormConnections.push(this._requestPaymentFormAsyncResponse.OnSuccess().connect(function (transaction) {
			PurchaseTariffFactory.resetPaymentFormRequest.call(this, false);
			this.requestPaymentFormCallback(Interfaces.accessor.AccountCallResult.Success, new Interfaces.accessor.PaymentTransaction(transaction));
		}.bind(this)));
		this._requestPaymentFormConnections.push(this._requestPaymentFormAsyncResponse.OnError().connect(function (error) {
			PurchaseTariffFactory.resetPaymentFormRequest.call(this, false);
			this.requestPaymentFormCallback(Interfaces.accessor.AccountCallResult.Error, error.GetAnyTranslation());
		}.bind(this)));
	},

	resetPaymentFormRequest: function (hard) {
		if (hard)
			this._requestPaymentFormConnections.forEach(function (connection) { connection.disconnect(); });
		this._requestPaymentFormConnections = [];

		if (this._requestPaymentFormAsyncResponse)
		{
			this._requestPaymentFormAsyncResponse.reset();
			this._requestPaymentFormAsyncResponse = null;
		}
	},

	pay: function (context, cardInfo, phoneNumber, email, debtAmount) {
		PurchaseTariffFactory.resetPayment.call(this, true);

		var optionalCardInfo = cardInfo ? cardInfo.native : null;
		var optionalPhoneNumber =  phoneNumber ? new stingray.OptionalString(phoneNumber) : null;
		var optionalEmail =  email ? new stingray.OptionalString(email) : null;
		var optionalDebtAmount =  debtAmount ? new stingray.OptionalDecimal(debtAmount) : null;

		this._payAsyncResponse = this._native.Pay(optionalCardInfo, optionalPhoneNumber, optionalEmail, optionalDebtAmount);

		this._payConnections.push(this._payAsyncResponse.OnSuccess().connect(function (transaction) {
			PurchaseTariffFactory.resetPayment.call(this, false);
			this.payCallback(Interfaces.accessor.AccountCallResult.Success, new Interfaces.accessor.PaymentTransaction(transaction));
		}.bind(this)));
		this._payConnections.push(this._payAsyncResponse.OnError().connect(function (error) {
			PurchaseTariffFactory.resetPayment.call(this, false);
			this.payCallback(Interfaces.accessor.AccountCallResult.Error, error.GetAnyTranslation());
		}.bind(this)));
	},

	resetPayment: function (context, hard) {
		if (hard)
			this._payConnections.forEach(function (connection) { connection.disconnect(); });
		this._payConnections = [];

		if (this._payAsyncResponse)
		{
			this._payAsyncResponse.reset();
			this._payAsyncResponse = null;
		}
	},

	toString: function () {
		return "{ " +
			"id: "			+ this.getId()			+ ", " +
			"serviceId: "	+ this.getServiceId()	+ ", " +
			"name: "		+ this.getName()		+ ", " +
			"price: "		+ this.getPrice()		+
		" }";
	},

	getValueOrNull: function (optionalValue) {
		return optionalValue ? optionalValue.get() : null;
	}
};
this.PurchaseTariffFactory = PurchaseTariffFactory;

const PaymentTransactionFactory = {
	create: function (object, native) {
		this.constructor.call(object, native);
	},

	constructor: function (native) {
		this._native = native;

		this._applyConnections = [];
		this._applyAsyncResponse = null;

		this.getUrl = function () { return this._native.GetPaymentFormUri().ToString(); };
		this.apply = PaymentTransactionFactory.apply.bind(this);
		this.abortApplyingRequest = PaymentTransactionFactory.resetApplyingRequest.bind(this, true);
		this.toString = PaymentTransactionFactory.toString.bind(this);
	},

	apply: function () {
		PaymentTransactionFactory.resetApplyingRequest.call(this, true);

		this._applyAsyncResponse = this._native.Apply();
		this._applyConnections.push(this._applyAsyncResponse.OnSuccess().connect(function () {
			PaymentTransactionFactory.resetApplyingRequest.call(this, false);
			this.applyCallback(Interfaces.accessor.AccountCallResult.Success, null);
		}.bind(this)));
		this._applyConnections.push(this._applyAsyncResponse.OnError().connect(function (error) {
			PaymentTransactionFactory.resetApplyingRequest.call(this, false);
			this.applyCallback(Interfaces.accessor.AccountCallResult.Error, error);
		}.bind(this)));
	},

	resetApplyingRequest: function (hard) {
		if (hard)
			this._applyConnections.forEach(function (connection) { connection.disconnect(); });
		this._applyConnections = [];

		if (this._applyAsyncResponse)
		{
			this._applyAsyncResponse.reset();
			this._applyAsyncResponse = null;
		}
	},

	toString: function () {
		return "{ url: " + this.getUrl() + " }";
	}
};
this.PaymentTransactionFactory = PaymentTransactionFactory;