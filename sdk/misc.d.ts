// Copyright (c) 2011 - 2022, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

declare namespace stingray {

	/**
	 * Object representing decimal number
	 */
	export class Decimal {
		public constructor(mantissa: number, exponent: number);
		public constructor(str: string);

		public GetMantissa(): number;
		public GetExponent(): number;
		public ToString(): string;
	}

	/**
	 * Abstraction representing nullable object holder
	 */
	export class Optional<T> {
		public reset(): void;
		public is_initialized(): boolean;
		public get(): T;
	}

	/**
	 * Abstraction representing nullable {@link string} holder
	 */
	export class OptionalString extends Optional<string> {
		public constructor(str: string);
	}

	/**
	 * Abstraction representing nullable {@link Decimal} holder
	 */
	export class OptionalDecimal extends Optional<Decimal> {
		public constructor(mantissa: number, exponent: number);
		public constructor(str: string);
	}

	/**
	 * String object containing translations map
	 */
	export interface TranslatedString {
		GetAnyTranslation(): string;
	}

}

/**
 * Global function that reads user data with given key from internal storage and deserializes it from json format.
 *
 * @param key - Key that identifies data.
 * @returns Object that will be deserialized from data.
 */
declare function load(key: string): any;

/**
 * Global function that reads user data with given key from internal storage and deserializes it from json format.
 *
 * @param key - Key that identifies data.
 * @param value - Object that will be serialized.
 */
declare function save(key: string, value: any): void;


/**
 * Global function that hashes any string data with md5 algorithm.
 *
 * @param str - String data to hash.
 * @returns String representable md5 hash.
 */
declare function md5Hash(str: string): string;

/**
 * Global log functions.
 *
 * @param str:  String data to log.
 */
declare function trace(str: string): void;
declare function debug(str: string): void;
declare function log(str: string): void;
declare function warning(str: string): void;
declare function error(str: string): void;

/**
 * Generates an event after a set interval, with an option to generate recurring events.
 */
declare interface Timer {
	constructor();

	/**
	 * Method that used to call a function or evaluates an expression after a specified number of milliseconds.
	 *
	 * @param callback - The function that will be executed.
	 * @param timeoutMilliseconds - The number of milliseconds to wait before executing the code.
	 * If the value is less than 4, the value 4 is used.
	 *
	 * @returns number identifier of async function.
	 */
	setTimeout(callback: (handle: number) => void, timeoutMilliseconds: number): number;

	/**
	 * Method that used to clear a timer set with the {@link setTimeout} method.
	 */
	clearTimeout(handle: number): void;

	/**
	 * Method that used to call a function or evaluates an expression at specified intervals (in milliseconds).
	 *
	 * @param callback - The function that will be executed.
	 * @param intervalMilliseconds - The intervals (in milliseconds) on how often to execute the code.
	 * If the value is less than 4, the value 4 is used.
	 *
	 * @returns number identifier of async function.
	 */
	setInterval(callback: (handle: number) => void, intervalMilliseconds: number): number;

	/**
	 * Method that used to clear a timer set with the {@link setInterval} method.
	 */
	clearInterval(handle: number): void;
}
