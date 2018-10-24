Rectangle {
	id: gameOverRect;

	focus: true;
	color: colorTheme.backgroundColor;

	visible: false;

	Column {
		id: gameOverColumn;

		width: 240;
		height: gameOverRect.height;

		anchors.centerIn: gameOverRect;

		spacing: 6;
		focus: true;

		visible: true;

		BodyText {
			width: gameOverColumn.width;
			height: 30;

			horizontalAlignment: Text.AlignHCenter;
			verticalAlignment: Text.AlignVCenter;

			text: qsTr("Игра окончена");
			color: colorTheme.highlightPanelColor;
			font: bodyFont;
		}

		MenuItem {
			id: exitGame;

			width: gameOverColumn.width;
			height: 30;

			focus: true;
			menuText: "Поиграть еще";

			onSelectPressed: {
				gameOverRect.visible = false;
			}
		}

		MenuItem {
			id: continueGame;

			width: gameOverColumn.width;
			height: 30;

			focus: true;
			menuText: "Выйти";

			onSelectPressed: {
				viewsFinder.closeApp();
			}
		}
	}

	function show() {
		gameOverRect.visible = true;
		exitGame.setFocus();
	}
}
