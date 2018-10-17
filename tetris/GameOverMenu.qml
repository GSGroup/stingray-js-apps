Rectangle {
	id: gameOverMenu;

	Text {
		y: 9;

		anchors.horizontalCenter: parent.horizontalCenter;

		text: qsTr("Игра окончена");
		color: colorTheme.highlightPanelColor;
		font: bodyFont;
	}

	ListView {
		id: gameOverGrid;

		property int cellWidth: game.blockSize * 8;
		property int cellHeight: game.blockSize * 1.5;

		width: cellWidth;
		height: cellHeight * menuModel.count;

		anchors.bottom: parent.bottom;
		anchors.horizontalCenter: parent.horizontalCenter;

		focus: true;

		visible: parent.width > 0;

		model: ListModel {
			id: menuModel;

			ListElement {text: "Выйти из Тетриса"}
			ListElement {text: "Поиграть еще"}
		}

		delegate: MenuDelegate { }

		onSelectPressed: {
			switch (gameOverGrid.currentIndex) {
			case 0:
				gameOverMenu.width = 0;
				gameOverMenu.visible = false;

				//FIXME заменить на выход из приложения
				movingTetraminos.setFocus();
				animTimer.start();
				break;

			case 1:
				gameOverMenu.width = 0;
				gameOverMenu.visible = false;

				movingTetraminos.setFocus();
				animTimer.start();
				break;
			}
		}

		onKeyPressed: {
			if (key === "8" || key === "7") {
				return true;
			}
		}
	}
}
