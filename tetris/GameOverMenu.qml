import "MenuItem.qml";

Rectangle {
	id: gameOverRect;

	signal setNewGame();
	signal exitGame();

	color: colorTheme.backgroundColor;

	visible: false;

	SubheadText {
		id: menuText;

		y: 17;

		width: 240;
		height: 36;

		anchors.horizontalCenter: gameOverRect.horizontalCenter;

		horizontalAlignment: ui.Text.AlignHCenter;
		verticalAlignment: ui.Text.AlignVCenter;

		text: tr("Игра окончена");
		color: colorTheme.highlightPanelColor;
	}

	Column {
		id: gameOverColumn;

		height: gameOverRect.height - 47;

		anchors.top: menuText.bottom;
		anchors.topMargin: 30;
		anchors.horizontalCenter: gameOverRect.horizontalCenter;

		spacing: 21;
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
		newGameItem.setFocus();
	}
}
