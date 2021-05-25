// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

const stingrayUtils = require("stingray", "misc.js");

const Factory = {
	create: function (object) {
		try {
			this.constructor.call(object);
		}
		catch (e) {
			object = undefined;
			error("Can't create time manager feature: " + e);
		}
	},

	constructor: function() {
		Factory.checkFeature(app.TimeManager());

		this._timeZone = Factory.transformTimeZone(Factory.getFeature().GetTimeZone());

		this.getTimeZone = function() { return this._timeZone; };
		this.onTimeZoneChanged = Factory.onTimeZoneChanged.bind(this);

		this._connection = this.onTimeZoneChanged(function (timezone) {
			this._timeZone = timezone;
		}.bind(this));
	},

	onTimeZoneChanged: function (slot) {
		var connection = Factory.getFeature().OnTimeZoneChanged().connect(function (timeZone) {
			slot(Factory.transformTimeZone(timeZone));
		});
		return new stingrayUtils.SignalConnection(connection);
	},

	transformTimeZone: function (timeZone) {
		return timeZone.GetMinutesFromUtc() / 60;
	},

	checkFeature: function(feature) {
		if (!feature.IsFeatureValid())
			throw "Feature is not valid!";
	},

	getFeature: function() {
		var feature = app.TimeManager();
		Factory.checkFeature(feature);
		return feature;
	}
};

this.Factory = Factory;
