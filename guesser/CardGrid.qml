// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "Card.qml";

Item {
	id: cardGridProto;

	property int size: 4;
	property int cardArea: 140hpw;

	width: cardArea * size;
	height: cardArea * size;

	anchors.centerIn: parent;

	Card { } Card { } Card { } Card { }
	Card { } Card { } Card { } Card { }
	Card { } Card { } Card { } Card { }
	Card { } Card { } Card { } Card { }

	place: {
		for (var i = 0; i < this.size; ++i)
		{
			var y = i * this.cardArea;
			for (var j = 0; j < this.size; ++j)
			{
				var card = this.children[i * this.size + j];

				card.show = true;
				card.y = y;
				card.x = j * this.cardArea;
			}
		}
	}
}
