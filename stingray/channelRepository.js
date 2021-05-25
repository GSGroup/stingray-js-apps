// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

const utils = require("stingray", "details/channelRepositoryUtils.js");

/**
 * Enum representing content source type that used by STB
 */
const SourceType = {
	None: 0,
	Dvb: 1,
	Ip: 2,
	Hybrid: 3
};
this.SourceType = SourceType;


/**
 * Static class representing a module of a channel repository that provides
 * the ability to manage channels and related information.
 */
const ChannelRepository = {
	/**
	 * Function that provides access to the content source type that used by STB
	 *
	 * arguments types: none
	 * return type: SourceType
	 */
	getSourceType: function () { },

	/**
	 * Signal that provides access to the content source type that used by STB
	 *
	 * arguments types:
	 *   - slot: void function(SourceType: type)
	 * return type: misc.SignalConnection
	 * populator: true
	 */
	onSourceTypeChanged: function (slot) { }
}
utils.Factory.create(ChannelRepository);

this.Feature = ChannelRepository;