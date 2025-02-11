// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.Button;
import "FinalPage.qml";
import "FirstIterationPage.qml";
import "SecondIterationPage.qml";
import "StartPage.qml";

Rectangle {
	id: gameProto;

	property int cardsCount: 54;
	property int guessedCard: -1;
	property variant cards;

	anchors.fill: mainWindow;

	color: "#004010";
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

		FinalPage {
			id: result;

			onAccepted: { gameProto.init(); }
		}
	}

	init: {
		gameStates.currentIndex = 0
		startPage.init();
	}
}
