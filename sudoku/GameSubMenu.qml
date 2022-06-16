// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
		id: subMenu;
		focus: true;

		signal continueEvent();
		signal menuCallEvent();

		Image {
			 id: subMenuTheme;
			 anchors.horizontalCenter: safeArea.horizontalCenter;
			 anchors.verticalCenter: safeArea.verticalCenter;
			 source: "apps/sudoku/img/ground_pause.png";
		}

		TitleText {
			id: playerInfoText;
			anchors.top: subMenuTheme.top;
			anchors.topMargin: 140;
			anchors.horizontalCenter: parent.horizontalCenter;
			text: "";
		}

		TitleText {
			id: gameInfoText;
			anchors.top: playerInfoText.bottom;
			anchors.topMargin: 20;
			anchors.horizontalCenter: parent.horizontalCenter;
		 
		}

		FocusablePanel {
			id: continueButton;
			anchors.top: gameInfoText.bottom;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.topMargin: 10;
			anchors.bottomMargin: 10;
			width: 250;
			height: 50;

			color: "#00000000";

			Image {
				anchors.horizontalCenter: parent.horizontalCenter;
				anchors.verticalCenter: parent.verticalCenter;
 				source: "apps/sudoku/img/btn_main_"+(parent.activeFocus? "focus":"regular")+".png";
			}

			BodyText {
				id: txt;
				anchors.verticalCenter: parent.verticalCenter;
				anchors.horizontalCenter: parent.horizontalCenter;
				color: parent.activeFocus ? colorTheme.activeTextColor : colorTheme.textColor;
				text:"continue";
			}

			
			onUpPressed: {
			}

			onDownPressed: {
				menuCallButton.setFocus();
			}
			
			onSelectPressed: {
				log("CONTINUE PRESSED!");
				parent.continueEvent();
			}
		}

		FocusablePanel {
			id: menuCallButton;
			anchors.top: continueButton.bottom;
			anchors.horizontalCenter: parent.horizontalCenter;
			width: 250;
			height: 50;
			anchors.topMargin: 10;
			anchors.bottomMargin: 10;

			color: "#00000000";

			Image {
				anchors.horizontalCenter: parent.horizontalCenter;
				anchors.verticalCenter: parent.verticalCenter;
 				source: "apps/sudoku/img/btn_main_"+(parent.activeFocus? "focus":"regular")+".png";
			}

			BodyText {
				id: txt;
				anchors.verticalCenter: parent.verticalCenter;
				anchors.horizontalCenter: parent.horizontalCenter;
				color: parent.activeFocus ? colorTheme.activeTextColor : colorTheme.textColor;
				text:"to main menu";
			}
			
			onUpPressed: {
				continueButton.setFocus();
			}

			onDownPressed: {
			}
			
			onSelectPressed: {
				log("helpButton PRESSED!");
				parent.menuCallEvent();
			}
		}
}

