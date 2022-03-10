// Copyright (c) 2011 - 2022, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

/// <reference path="feature.d.ts" />
/// <reference path="signals.d.ts" />

declare namespace stingray {

	/**
	 * {@link IFeature} representing a module of a channel repository that provides
	 * the ability to manage channels and related information.
	 */
	export interface IChannelRepositoryPtr extends IFeature {
		/**
		 * Function that provides access to the content source type that used by STB
		 */
		GetSourceType(): number;

		/**
		 * {@link Signal} that provides access to the content source type that used by STB
		 * 	Possible source type values: None(0), Dvb(1), Ip(2), Hybrid(3)
		 */
		OnSourceTypeChanged(): Signal<[sourceType: number]>
	}

}
