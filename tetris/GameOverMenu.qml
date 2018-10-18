Rectangle {
	id: gameOverRect;

	focus: true;
	color: "#000000";

	visible: false;

	BodyText {
		y: 9;

		anchors.horizontalCenter: gameOverRect.horizontalCenter;

		text: qsTr("Игра окончена");
		color: colorTheme.highlightPanelColor;
	}

	ListView {
		id: gameOverGrid;

		width: game.blockSize * 8;
		height: game.blockSize * 1.5 * model.count;

		anchors.bottom: gameOverRect.bottom;
		anchors.horizontalCenter: gameOverRect.horizontalCenter;

		focus: true;

		visible: true;

		model: ListModel {
			id: menuModel;

			ListElement { text: "Выйти из Тетриса" }
			ListElement { text: "Поиграть еще" }
		}
		delegate: MenuDelegate { }

		onSelectPressed: {
			switch (gameOverGrid.currentIndex) {
			case 0://FIXME: выход из приложения
			case 1:
				gameOverRect.visible = false;
				movingTetraminos.setFocus();
				break;
			}
		}

		onKeyPressed: {
			if (key === "8" || key === "7") {
				return true;
			}
		}
	}

	function show() {
		gameOverRect.visible = true;
		gameOverGrid.currentIndex = 0;
		gameOverGrid.setFocus();
	}
}
