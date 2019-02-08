import controls.HighlightListView;
import "CardGrid.qml";

Item {
	id: secondPageProto;

	signal cardSelected(card);

	anchors.fill: parent;

	HighlightListView {
		anchors.fill: cardsFirst;
		anchors.leftMargin: -8;
		anchors.topMargin: -8;

		orientation: ListView.Horizontal;
		spacing: 40;

		model: ListModel {
			ListElement { }
			ListElement { }
			ListElement { }
			ListElement { }
		}

		delegate: Item {
			width: 100;
			height: parent.height;

			focus: true;
		}

		onSelectPressed: { secondPageProto.cardSelected(cardsSecond.children[this.currentIndex]); }
	}

	SubheadText {
		anchors.bottom: cardsSecond.top;
		anchors.bottomMargin: 15;
		anchors.horizontalCenter: cardsFirst.horizontalCenter;
		anchors.rightMargin: 40;

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
