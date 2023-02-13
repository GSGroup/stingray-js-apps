// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.HighlightListView;
import "CardGrid.qml";

Item {
	id: secondPageProto;

	signal cardSelected(card);

	anchors.fill: parent;

	HighlightListView {
		anchors.fill: cardsFirst;
		anchors.leftMargin: -8hpw;
		anchors.topMargin: -8hph;

		orientation: Horizontal;
		spacing: 40;
		uniformDelegateSize: true;

		model: ListModel {
			ListElement { }
			ListElement { }
			ListElement { }
			ListElement { }
		}

		delegate: Delegate {
			width: 100hpw;
			height: parent.height;

			focus: true;
		}

		onSelectPressed: { secondPageProto.cardSelected(cardsSecond.children[this.currentIndex]); }
	}

	SubheadText {
		anchors.bottom: cardsSecond.top;
		anchors.bottomMargin: 15hph;
		anchors.horizontalCenter: cardsFirst.horizontalCenter;
		anchors.rightMargin: 40hpw;

		color: "#fff";
		text: "В какой колонке карта?";
	}

	CardGrid { id: cardsSecond; }

	function cardIsAdded(cards, number) {
		for (var i in cards)
		{
			if (cards[i].number == number)
				return true;
		}
		return false;
	}

	function show(col) {
		for (var i = 0; i < col.length; ++i)
		{
			var card = cardsSecond.children[i];
			var gameCard = col[i];
			card.number = gameCard.number;
			card.cardNumber = gameCard.cardNumber;
			card.show = true;
		}

		for (var i = col.length; i < cardsSecond.children.length; ++i)
		{
			var card = cardsSecond.children[i];
			var rand = Math.floor(Math.random() * gameProto.cards.length);
			while (this.cardIsAdded(cardsSecond.children, gameProto.cards[rand].number))
				rand = Math.floor(Math.random() * gameProto.cards.length);
			var gameCard = gameProto.cards[rand];
			card.number = gameCard.number;
			card.cardNumber = gameCard.cardNumber;
			card.show = true;
		}

		cardsSecond.place();
	}
}
