// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

/// <reference path="feature.d.ts" />
/// <reference path="signals.d.ts" />

declare namespace stingray {

	/**
	 * 	Abstraction that holds time zone value represented by minutes from UTC
	 */
	export interface TimeZone {
		GetMinutesFromUtc(): number;
	}

	/**
	 * {@link IFeature} representing a time manager module that provides
	 * the ability to manage STB system time and related information.
	 */
	export interface ITimeManagerPtr extends IFeature {
		/**
		 * Function that provides access to {@link TimeZone}
		 */
		GetTimeZone(): TimeZone;

		/**
		 * {@link Signal} that provides access to {@link TimeZone}
		 */
		OnTimeZoneChanged(): Signal<[timezone: TimeZone]>
	}

}
