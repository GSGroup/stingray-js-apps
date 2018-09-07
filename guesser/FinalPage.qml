import controls.Button;
import "Card.qml";

Item {
	id: finalPageProto;

	signal accepted;

	property alias cardNumber: card.cardNumber;
	property alias number: card.number;
	property alias show: card.show;

	anchors.fill: parent;

	MainText {
		anchors.top: finalPageProto.top;
		anchors.topMargin: 50;
		anchors.horizontalCenter: finalPageProto.horizontalCenter;
		anchors.rightMargin: 40;

		color: "#fff";
		text: "Я угадал!";
	}

	Card {
		id: card;

		anchors.centerIn: parent;

		onXDone: { card.show = true; }
	}

	Button {
		id: repeatButton;

		height: 45;
		width: 200;

		anchors.bottom: finalPageProto.bottom;
		anchors.horizontalCenter: finalPageProto.horizontalCenter;
		anchors.bottomMargin: 50;

		text: "Еще раз";
		
		onSelectPressed: {
			finalPageProto.accepted();
		}
	}
}
