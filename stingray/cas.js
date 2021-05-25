// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

const utils = require("stingray", "details/casUtils.js");

/**
 * Static class representing a module of a conditional access system that provides
 * the functionality of a secure chip and related information.
 */
const Cas = {
	/**
	 * Function that provides access to the DRE id
	 *
	 * arguments types: none
	 * return type: string
	 */
	getDreId: function () { },

	/**
	 * Signal that provides access to the DRE id
	 *
	 * arguments types:
	 *   - slot : void function(string: dreId)
	 * return type: misc.SignalConnection
	 * populator: yes
	 */
	onDreIdChanged: function (slot) { }
};
utils.Factory.create(Cas);

this.Feature = Cas;
