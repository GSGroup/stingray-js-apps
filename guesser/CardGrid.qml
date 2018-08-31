import "Card.qml";

Item {
	id: cardGridProto;
	property int size: 4;
	property int cardArea: 140;
	width: cardArea * size;
	height: cardArea * size;
	anchors.centerIn: parent;

	Card { } Card { } Card { } Card { }
	Card { } Card { } Card { } Card { }
	Card { } Card { } Card { } Card { }
	Card { } Card { } Card { } Card { }

	place: {
		for (var i = 0; i < this.size; ++i) {
			var y = i * this.cardArea
			for (var j = 0; j < this.size; ++j) {
				var card = this.children[i * this.size + j]

				card.show = true
				card.y = y
				card.x = j * this.cardArea
			}
		}
	}
}
