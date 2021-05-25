// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

const utils = require("stingray", "details/standByModeUtils.js");

/**
 * Enum representing standby switch reason
 */
const SwitchReason = {
	Default: 0,
	User: 1,
	Auto: 2,
	Scheduler: 3
};
this.SwitchReason = SwitchReason;


/**
 * Static class representing a module that controls standby mode.
 */
const StandByMode = {
	/**
	 * Function that provides access to the current mode value
	 *
	 * arguments types: none
	 * return type: bool or null if error occur
	 */
	isEnabled: function () {
		return utils.StandByMode.isEnabled();
	},

	/**
	 * Signal that provides access to the current mode value
	 *
	 * arguments types:
	 *   - slot : void function(bool: status, SwitchReason: reason)
	 * return type: misc.SignalConnection
	 * populator: yes
	 */
	onEnabledChanged: function (slot) {
		return utils.StandByMode.onEnabledChanged(slot);
	}
};
utils.StandByMode.create(StandByMode);

this.Feature = StandByMode;
