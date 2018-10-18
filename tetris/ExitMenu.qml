Rectangle {
	id: exitRect;

	focus: true;
	color: colorTheme.backgroundColor;
	clip: true;

	visible: false;

	ListView {
		id: exitGrid;

		width: game.blockSize * 8;
		height: game.blockSize * 1.5 * model.count;

		anchors.centerIn: exitRect;

		focus: true;

		visible: true;

		model: ListModel {
			id: menuModel;

			ListElement { text: "Выйти из Тетриса" }
			ListElement { text: "Продолжить игру" }
			ListElement { text: "Новая игра" }
		}
		delegate: MenuDelegate { }

		onSelectPressed: {
			exitRect.visible = false;
			movingTetraminos.setFocus();

			switch (exitGrid.currentIndex) {
			case 0:
			case 1:
				break;
			case 2:
				game.initNewMovingBlock();
				break;
			}
		}

		onKeyPressed: {
			if (key === "8" || key === "7" || key === "6") {
				return true;
			}
		}
	}

	function show() {
		exitGrid.currentIndex = 0;
		exitRect.visible = true;
		exitRect.setFocus();
	}
}
