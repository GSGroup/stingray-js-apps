// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.Button;
import "CardGrid.qml";

Item {
	id: startPageProto;

	signal accepted(cards);

	anchors.fill: parent;

	SubheadText {
		anchors.bottom: cards.top;
		anchors.bottomMargin: 15hph;
		anchors.horizontalCenter: cards.horizontalCenter;
		anchors.rightMargin: 40hpw;

		color: "#fff";
		text: "Загадайте карту и нажмите кнопку «Продолжить»";
	}

	CardGrid {
		id: cards;
	}

	Button {
		id: startButton;

		height: 45hph;
		width: 200hpw;

		anchors.top: cards.bottom;
		anchors.horizontalCenter: cards.horizontalCenter;
		anchors.rightMargin: 60hpw;

		text: "Продолжить";
		
		onSelectPressed: { startPageProto.accepted(cards.children); }
	}

	function cardIsAdded(cards, number) {
		for (var i in cards)
		{
			if (cards[i].number == number)
				return true;
		}
		return false;
	}

	init: {
		for (var i in cards.children)
		{
			var rand = Math.floor(Math.random() * gameProto.cardsCount);
			while (this.cardIsAdded(cards.children, rand))
				rand = Math.floor(Math.random() * gameProto.cardsCount);

			var card = cards.children[i];
			card.number = rand;
			card.cardNumber = cards.children[i].number.toString();
		}
		cards.place();
	}
}
