import "MenuItem.qml";

Rectangle {
	id: exitRect;

	signal setNewGame();
	signal backToGame();

	color: colorTheme.backgroundColor;

	visible: false;

	Column {
		id: gameExitColumn;

		height: exitRect.height;

		anchors.centerIn: exitRect;

		spacing: 6;
		focus: true;

		MenuItem {
			id: exitGameItem;

			menuText: "Выйти из Тетриса";

			onSelectPressed: { viewsFinder.closeApp(); }
		}

		MenuItem {
			id: continueGameItem;

			menuText: "Продолжить игру";

			onSelectPressed: { exitRect.backToGame(); }
		}

		MenuItem {
			id: newGameItem;

			menuText: "Новая игра";

			onSelectPressed: { exitRect.setNewGame(); }
		}
	}

	function show() {
		exitRect.visible = true;
		exitGameItem.setFocus();
	}
}
