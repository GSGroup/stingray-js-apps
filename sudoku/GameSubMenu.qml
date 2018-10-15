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

		BigText {
			id: playerInfoText;
			anchors.top: subMenuTheme.top;
			anchors.topMargin: 140;
			anchors.horizontalCenter: parent.horizontalCenter;
			text: "";
		}

		BigText {
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

			SmallText {
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

			SmallText {
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

