import "MenuItem.qml";

Rectangle {
	id: gameOverRect;

	signal setNewGame();
	signal exitGame();

	color: colorTheme.backgroundColor;

	visible: false;

	BodyText {
		id: menuText;

		width: 240;
		height: 30;

		anchors.topMargin: 6;
		anchors.horizontalCenter: gameOverRect.horizontalCenter;

		horizontalAlignment: Text.AlignHCenter;
		verticalAlignment: Text.AlignVCenter;

		text: qsTr("Игра окончена");
		color: colorTheme.highlightPanelColor;
	}

	Column {
		id: gameOverColumn;

		height: gameOverRect.height;

		anchors.horizontalCenter: gameOverRect.horizontalCenter;
		anchors.top: menuText.bottom;
		anchors.topMargin: 6;

		spacing: 6;
		focus: true;

		MenuItem {
			id: newGameItem;

			menuText: "Поиграть еще";

			onSelectPressed: { gameOverRect.setNewGame(); }
		}

		MenuItem {
			id: exitGameItem;

			menuText: "Выйти";

			onSelectPressed: { gameOverRect.exitGame(); }
		}
	}

	function show() {
		gameOverRect.visible = true;
		exitGameItem.setFocus();
	}
}
