// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

declare namespace stingray {

	/**
	 * Abstraction representing resettable smart pointer
	 */
	export class SmartPointer {
		public reset(): void;
	}

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
	 * String object containing translations map
	 */
	export interface TranslatedString {
		GetAnyTranslation(): string;
	}

	/**
	 * Object representing time
	 */
	export interface Time {
		ToIso8601(): string;
	}

	/**
	 * Object representing time interval
	 */
	export interface TimeInterval {
		GetStart(): Time;
		GetEnd(): Time;
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
 * The console object provides access to the debugging console
 */
declare interface Console {

	/**
	 * Method writes an error {@link message} to the console if the {@link assertion} is false. If the assertion is true, nothing happens
	 *
	 * @param assertion - Any boolean expression. If the assertion is false, the message is written to the console.
	 * @param message - Message to be written.
	 */
	assert(assertion: boolean, message: string): void;

	/**
	 * Method starts a timer you can use to track how long an operation takes. When you call {@code console.timeEnd(label)}, console will output elapsed time
	 *
	 * @param label - timer identifier
	 */
	time(label: string): void;

	/**
	 * Method logs the current value of a timer.
	 * @param label - timer identifier
	 */
	timeEnd(label: string): void;

	/**
	 * Method stops a timer with the given label.
	 * @param label - timer identifier
	 */
	timeLog(label: string): void;

	/**
	 * The method logs the number of times that this has been called with the given label
	 * @param label - counter identifier
	 */
	count(label: string): void;

	/**
	 * The method resets counter with the given label
	 * @param label - counter identifier
	 */
	countReset(label: string): void;

	/**
	 * Logger methods with the corresponding log level
	 *
	 * @param args - objects to be printed.
	 */
	log(...args: any[]): void;
	warn(...args: any[]): void;
	error(...args: any[]): void;
	trace(...args: any[]): void;
	debug(...args: any[]): void;
}

declare const console: Console;


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
