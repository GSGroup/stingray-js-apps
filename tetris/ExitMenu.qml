Rectangle {
	id: exitRect;

	signal setNewGame();
	signal backToGame();

	focus: true;
	color: colorTheme.backgroundColor;

	visible: false;

	Column {
		id: gameExitColumn;

		width: 240;
		height: exitRect.height;

		anchors.centerIn: exitRect;

		spacing: 6;
		focus: true;

		visible: true;

		MenuDelegate {
			id: exitGameItem;

			width: gameExitColumn.width;
			height: 30;

			focus: true;
			menuText: "Выйти из Тетриса";

			onSelectPressed: {
				viewsFinder.closeApp();
			}
		}

		MenuDelegate {
			id: continueGameItem;

			width: gameExitColumn.width;
			height: 30;

			focus: true;
			menuText: "Продолжить игру";

			onSelectPressed: {
				exitRect.backToGame();
			}
		}

		MenuDelegate {
			id: newGameItem;

			width: gameExitColumn.width;
			height: 30;

			focus: true;
			menuText: "Новая игра";

			onSelectPressed: {
				exitRect.setNewGame();
			}
		}
	}

	function show() {
		exitRect.visible = true;
		exitGameItem.setFocus();
	}
}
