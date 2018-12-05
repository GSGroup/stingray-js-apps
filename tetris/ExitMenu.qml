import "MenuItem.qml";

Rectangle {
	id: exitRect;

	signal setNewGame();
	signal backToGame();
	signal exitGame();

	color: colorTheme.backgroundColor;

	visible: false;

	Column {
		id: gameExitColumn;

		height: exitRect.height - 66;

		anchors.centerIn: exitRect;

		spacing: 18;
		focus: true;

		MenuItem {
			id: exitItem;

			menuText: "Выйти из Тетриса";

			onSelectPressed: { exitRect.exitGame(); }
		}

		MenuItem {
			id: continueItem;

			menuText: "Продолжить игру";

			onSelectPressed: { exitRect.backToGame(); }
		}

		MenuItem {
			id: newItem;

			menuText: "Новая игра";

			onSelectPressed: { exitRect.setNewGame(); }
		}
	}

	function show() {
		exitRect.visible = true;
		exitItem.setFocus();
	}
}
