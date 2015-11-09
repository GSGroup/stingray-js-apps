import controls.MainText;
import controls.Button;
import controls.PageStack;
import StartPage;
import Card;
import FirstIterationPage;
import SecondIterationPage;

Rectangle {
	id: gameProto;
	property int cardsCount: 54;
	property int guessedCard: -1;
	property variant cards;
	anchors.fill: mainWindow;
	color: "#004010";
	//color: "#00C853";
	focus: true;

	PageStack {
		id: gameStates;
		anchors.fill: parent;

		StartPage {
			id: startPage;

			onAccepted: {
				gameProto.cards = cards;
				gameStates.currentIndex = 1;
				first.show();
			}
		}

		FirstIterationPage {
			id: first;
		
			onChoosed: {
				gameStates.currentIndex = 2;
				second.show(col);
			}
		}

		SecondIterationPage {
			id: second;
		
			onCardSelected: {
				gameProto.guessedCard = card.cardNumber
				gameStates.currentIndex = 3;
				result.number = card.number
				result.cardNumber = card.cardNumber
				result.show = false;
			}
		}

		Card {
			id: result;
			anchors.centerIn: parent;

			onXDone: {
				result.show = true;
			}
		}
	}

	init: {
		gameStates.currentIndex = 0
		startPage.init();
	}
}
