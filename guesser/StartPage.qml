import controls.Button;
import CardGrid; 

Item {
	id: startPageProto;
	signal accepted(cards);
	anchors.fill: parent;

	CardGrid { id: cards; }

	Button {
		id: startButton;
		anchors.top: cards.bottom;
		anchors.horizontalCenter: cards.horizontalCenter;
		anchors.rightMargin: 60;
		text: "Продолжить";
		
		onSelectPressed: {
			startPageProto.accepted(cards.children);
		}
	}

	function cardIsAdded(cards, number) {
		for (var i in cards)
			if (cards[i].number == number)
				return true
		return false 
	}

	init: {
		for (var i in cards.children) {
			var rand = Math.floor(Math.random() * gameProto.cardsCount)
			while (this.cardIsAdded(cards.children, rand))
				rand = Math.floor(Math.random() * gameProto.cardsCount)

			var card = cards.children[i]
			card.number = rand 
			card.cardNumber = cards.children[i].number.toString()
		}
		cards.place()
	}
}
