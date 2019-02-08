import controls.Button;
import "CardGrid.qml";

Item {
	id: startPageProto;

	signal accepted(cards);

	anchors.fill: parent;

	SubheadText {
		anchors.bottom: cards.top;
		anchors.bottomMargin: 15;
		anchors.horizontalCenter: cards.horizontalCenter;
		anchors.rightMargin: 40;

		color: "#fff";
		text: "Загадайте карту и нажмите кнопку «Продолжить»";
	}

	CardGrid {
		id: cards;
	}

	Button {
		id: startButton;

		height: 45;
		width: 200;

		anchors.top: cards.bottom;
		anchors.horizontalCenter: cards.horizontalCenter;
		anchors.rightMargin: 60;

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
