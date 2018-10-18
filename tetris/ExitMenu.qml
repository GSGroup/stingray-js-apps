Rectangle {
	id: exitRect;

	Behavior on width { animation: Animation { duration: 300; } }

	ListView {
		id: exitGrid;

		property int cellWidth: game.blockSize * 8;
		property int cellHeight: game.blockSize * 1.5;

		width: cellWidth;
		height: cellHeight * menuModel.count;

		anchors.centerIn: parent;

		focus: true;

		visible: parent.width > 0;

		model: ListModel {
			id: menuModel;

			ListElement {text: "Выйти из Тетриса"}
			ListElement {text: "Продолжить игру"}
			ListElement {text: "Новая игра"}
		}
		delegate: MenuDelegate { }

		onSelectPressed: {
			switch (exitGrid.currentIndex) {
			case 0:
				exitRect.width = 0;
				exitRect.visible = false;

				//FIXME:выход из игры
				movingTetraminos.setFocus();
				animTimer.start();
				break;
			case 1:
				exitRect.width = 0;
				exitRect.visible = false;

				movingTetraminos.setFocus();
				animTimer.start();
				break;
			case 2:
				exitRect.width = 0;
				exitRect.visible = false;

				movingTetraminos.setFocus();
				game.initNewMovingBlock();
				break;
			}
		}

		onKeyPressed: {
			if (key == "8" || key == "7" || key == "6") {
				return true;
			}
		}
	}

	function show(width) {
		exitRect.width = width;
		exitRect.visible = true;

		exitGrid.currentIndex = 0;
		exitRect.setFocus();
	}
}
