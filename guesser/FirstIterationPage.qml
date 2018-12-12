import controls.HighlightListView;
import "CardGrid.qml";

Item {
	id: firstPageProto;

	signal choosed(col);

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

		onSelectPressed: {
			var x = this.currentIndex
			var col = []
			for (var i = 0; i < 4; ++i)
				col.push(cardsFirst.children[x + i * 4]);

			firstPageProto.choosed(col);	
		}
	}

	MainText {
		anchors.bottom: cardsFirst.top;
		anchors.bottomMargin: 15;
		anchors.horizontalCenter: cardsFirst.horizontalCenter;
		anchors.rightMargin: 40;

		color: "#fff";
		text: "В какой колонке карта?";
	}

	CardGrid { id: cardsFirst; }

	function cardIsAdded(cards, number) {
		for (var i in cards)
		{
			if (cards[i].number == number)
				return true;
		}
		return false;
	}

	show: {
		for (var i in cardsFirst.children)
		{
			var card = cardsFirst.children[i];
			var rand = Math.floor(Math.random() * gameProto.cards.length);
			while (this.cardIsAdded(cardsFirst.children, gameProto.cards[rand].number))
				rand = Math.floor(Math.random() * gameProto.cards.length);
			var gameCard = gameProto.cards[rand];
			card.number = gameCard.number;
			card.cardNumber = gameCard.cardNumber;
			card.show = true;
		}

		cardsFirst.place();
	}
}
