// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

/// <reference path="signals.d.ts" />

declare namespace stingray {

	/**
	 * Key/Value pair abstraction used primarily in dictionaries
	 *
	 * @param K - Key type
	 * @param V - Value type
	 */
	export interface KeyValuePair<K, V> {
		readonly Key: K;
		readonly Value: V;
	}

	/**
	 * Abstraction which supports a simple iteration over stored items.
	 *
	 * @param V - Value type
	 */
	export interface IEnumerable<T> {
		forEach(functor: (item: T) => void): void;
	}

	/**
	 * Abstraction which is countable {@link IEnumerable}
	 *
	 * @param V - Value type
	 */
	export interface ICollection<T> extends IEnumerable<T> {
		GetCount(): number;
		IsEmpty(): boolean;
	}

	/**
	 * Abstraction which is observable {@link ICollection} with items represented as linked list
	 *
	 * @param V - Value type
	 */
	export interface IObservableList<T> extends ICollection<T> {
		OnChanged(): Signal<[op: number, idx: number, item: T]>;
	}

	/**
	 * Abstraction which is observable {@link ICollection} with items represented as set
	 *
	 * @param V - Value type
	 */
	export interface IObservableSet<T> extends ICollection<T> {
		OnChanged(): Signal<[op: number, item: T]>;
	}

	/**
	 * Abstraction which is observable {@link ICollection} with items represented as dictionary.
	 * {@link KeyValuePair} used as item type.
	 *
	 * @param K - Key type
	 * @param V - Value type
	 */
	export interface IObservableDictionary<K, V> extends ICollection<KeyValuePair<K, V>> {
		OnChanged(): Signal<[op: number, key: K, value: V]>;
	}

}
