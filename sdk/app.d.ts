// Copyright (c) 2011 - 2022, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

/// <reference path="cas.d.ts" />
/// <reference path="channelRepository.d.ts" />
/// <reference path="drm.d.ts" />
/// <reference path="standByMode.d.ts" />
/// <reference path="timeManager.d.ts" />
/// <reference path="tricolorAccount.d.ts" />

declare namespace app {
	/**
	 * Function to get {@link stingray.ICasFeaturePtr}
	 */
	export function Cas(): stingray.ICasFeaturePtr;

	/**
	 * Function to get {@link stingray.IChannelRepositoryPtr}
	 */
	export function ChannelRepository(): stingray.IChannelRepositoryPtr;

	/**
	 * Function to get {@link stingray.IDrmFeaturePtr}
	 */
	export function Drm(): stingray.IDrmFeaturePtr;

	/**
	 * Function to get {@link stingray.IStandByModePtr}
	 */
	export function StandByMode(): stingray.IStandByModePtr;

	/**
	 * Function to get {@link stingray.ITimeManagerPtr}
	 */
	export function TimeManager(): stingray.ITimeManagerPtr;

	/**
	 * Function to get {@link stingray.ITricolorAccountPtr}
	 */
	export function TricolorAccount(): stingray.ITricolorAccountPtr;
}
