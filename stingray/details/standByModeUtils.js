// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

const stingrayUtils = require("stingray", "misc.js");

const StandByMode = {
	create: function (object) {
		try {
			this.constructor.call(object);
		}
		catch (e) {
			object = undefined;
			error("Can't create standby mode feature: " + e);
		}
	},

	constructor: function () {
		StandByMode.checkFeature(app.StandByMode());
	},

	isEnabled: function () {
		return StandByMode.getFeature().IsEnabled();
	},

	onEnabledChanged: function (slot) {
		const connection = StandByMode.getFeature().OnEnabledChanged().connect(slot);
		return new stingrayUtils.SignalConnection(connection);
	},

	checkFeature: function (feature) {
		if (!feature.IsFeatureValid())
			throw "Feature is not valid!";
	},

	getFeature: function () {
		const feature = app.StandByMode();
		StandByMode.checkFeature(feature);
		return feature;
	}
};
this.StandByMode = StandByMode;
