// Copyright (c) 2011 - 2020, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

/**
 * Enum representing collection operations
 */
const CollectionOp = {
	Added: 0,
	Updated: 1,
	Removed: 2
};
this.CollectionOp = CollectionOp;


/**
 * Class that used by signal connectors and representing life time of the signal subscription.
 * Hold it while you want to observe signal and disconnect it to remove connection.
 */
function SignalConnection(connection) {
	this.native = connection;
}

SignalConnection.prototype = {
	/**
	 * Constructor that used primarily by system.
	 */
	constructor: SignalConnection,

	/**
	 * Function that used to drop connection
	 *
	 * arguments types: none
	 * return type: none
	 */
	disconnect: function () {
		this.native.disconnect();
	}
}
this.SignalConnection = SignalConnection;