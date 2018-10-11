import "MenuDelegate.qml";
import "LevelDelegate.qml";
import "CellDelegate.qml";
import "engine.js" as engine;

Rectangle{
	id: mainWindow;

	width:safeArea.width;
	height:safeArea.height;

	color:colorTheme.globalBackgroundColor;

	visible:true;

	focus: true;

	Rectangle {
		id: game;

		property int glassWidth: 10;
		property int glassHigh: 20;

		property real dropTime: 16000.0;

		property int space: 6;
		property int spaceBetweenBlocks: 1 ;
		property int blockSize: (safeArea.height - space * 4) / glassHigh;

		property int currentBlock: 0xCC00;
		property int nextBlock: 0x4460;

		property int nextBlockColor: 0;
		property int currentBlockColor: 1;

		width: blockSize * glassWidth;
		height: blockSize * glassHigh;

		anchors.centerIn: parent;

		color: colorTheme.backgroundColor;
		focus: true;
		radius: 5;

		Item {
			id: movingTetraminos;

			x: game.width / 2 - rect.width * 2;
			y: 0;

			focus: false;

			visible: true;

			CellDelegate{ } CellDelegate{ } CellDelegate{ } CellDelegate{ }
			CellDelegate{ } CellDelegate{ } CellDelegate{ } CellDelegate{ }
			CellDelegate{ } CellDelegate{ } CellDelegate{ } CellDelegate{ }
			CellDelegate{ } CellDelegate{ } CellDelegate{ } CellDelegate{ }

			Timer {
				id: animTimer;

				interval: game.dropTime / (game.glassHigh - 4);
				running: true;
				repeat: true;

				//TOFIX:нужна адекватная проверка
				onTriggered: {
					var noCollisions = true;

					for (var j = 0; j < 16; j++) {
						if( game.hasCollisions( movingTetraminos.children[j].rect.x,
												movingTetraminos.children[j].rect.y + game.blockSize,
												movingTetraminos.children[j].rect.value) ) {
							noCollisions = false;
							break;
						}
					}

					if ( noCollisions  ){
						for (var i = 0; i < 16 ; i++)
							movingTetraminos.children[i].rect.y += game.blockSize;
					}
					else {
						game.initNewMovingBlock();
					}
				}
			}

			onCompleted: {

				movingTetraminos.initMovingBlockCoord();

				game.drawMovingBlock();
			}

			function initMovingBlockCoord () {
				for (var k = 0; k < 16; k ++) {
					this.children[k].rect.color = game.color;
					this.children[k].rect.x = (k % 4) * game.blockSize ;
					this.children[k].rect.y = Math.floor(k / 4 ) * game.blockSize;

					this.children[k].innerRect.blockGradient.blockGradientStart.color = engine.getGradientStart(game.currentBlockColor);
					this.children[k].innerRect.blockGradient.blockGradientEnd.color = engine.getGradientEnd(game.currentBlockColor);
				}
			}
		}

		Rectangle {
			id:infoRect;

			width: parent.width;
			height: parent.height;

			anchors.top: parent.top;
			anchors.left:parent.right;
			anchors.bottomMargin: game.space;
			anchors.leftMargin: game.blockSize * 3;

			color: colorTheme.globalBackgroundColor;
			focus: false;

			visible: true;

			Rectangle {
				id:nextBlockViewRect;

				width: game.blockSize * 6;
				height: game.blockSize * 6;

				anchors.top: parent.top;
				anchors.left:parent.left;

				color: colorTheme.globalBackgroundColor;

				Item {
					id: nextTetraminos;

					x: game.blockSize;
					y: game.blockSize;

					focus: false;

					visible: true;

					CellDelegate{ } CellDelegate{ } CellDelegate{ } CellDelegate{ }
					CellDelegate{ } CellDelegate{ } CellDelegate{ } CellDelegate{ }
					CellDelegate{ } CellDelegate{ } CellDelegate{ } CellDelegate{ }
					CellDelegate{ } CellDelegate{ } CellDelegate{ } CellDelegate{ }

					onCompleted: {
						for (var i = 0; i < 16; i ++) {
							this.children[i].rect.x = (i % 4) * game.blockSize;
							this.children[i].rect.y = Math.floor(i / 4 ) * game.blockSize;
						}
						game.drawNextBlockView();
					}
				}
			}

			Text {
				id:levelText;

				anchors.left: parent.left;
				anchors.top: nextBlockViewRect.bottom;
				anchors.topMargin: game.blockSize;
				anchors.leftMargin: game.blockSize;

				text: qsTr("Уровень");
				color: colorTheme.highlightPanelColor;
				font: captionSmall;
			}

			Text {
				id: scoreRect;

				anchors.left: parent.left;
				anchors.top: levelText.bottom;
				anchors.topMargin: game.blockSize;
				anchors.leftMargin: game.blockSize;

				text: qsTr("Счет");
				color: colorTheme.highlightPanelColor;
				font: captionSmall;
			}
		}

		Rectangle {
			id: exitMenu;

			width: 0;
			height: game.blockSize * 4;

			anchors.centerIn: parent;

			focus: false;
			color: colorTheme.backgroundColor;
			clip: true;

			visible: false;

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
					id:menuModel;

					ListElement {text: "Выйти из Тетриса"}
					ListElement {text: "Продолжить игру"}
					ListElement {text: "Новая игра"}
				}

				delegate: MenuDelegate { }

				onSelectPressed: {
					switch (exitGrid.currentIndex) {
					case 0:
						exitMenu.width = 0;
						exitMenu.focus = false;
						exitMenu.visible = false;
						break;
					case 1:
						exitMenu.width = 0;
						exitMenu.focus = false;
						exitMenu.visible = false;

						animTimer.start();
						break;
					case 2:
						exitMenu.width = 0;
						exitMenu.focus = false;
						exitMenu.visible = false;

						game.initNewMovingBlock();
						break;
					}
				}

				onKeyPressed: {
					if (key == "8") {
						return true;
					}
				}
			}

			function show() {
				animTimer.stop();

				this.currentIndex = 0;
				this.width = game.width;
				this.focus = true;
				this.visible = true;
			}
		}

		Rectangle {
			id: gameOverMenu;

			width: 0;
			height: game.blockSize * 4.5;

			anchors.centerIn: parent;

			focus: false;
			color: "#000000";
			clip: true;

			visible: false;

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
					id:menuModel;

					ListElement {text: "Выйти из Тетриса"}
					ListElement {text: "Поиграть еще"}
				}

				delegate: MenuDelegate { }

				onSelectPressed: {
					switch (gameOverGrid.currentIndex) {
					case 0:
						gameOverMenu.width = 0;
						gameOverMenu.focus = false;
						gameOverMenu.visible = false;

						//FIX заменить на выход из приложения
						animTimer.start();
						break;
					case 1:
						gameOverMenu.width = 0;
						gameOverMenu.focus = false;
						gameOverMenu.visible = false;

						animTimer.start();
						break;
					}
				}

				onKeyPressed: {
					if (key == "8") {
						return true;
					}

					if (key == "7") {
						return true;
					}
				}
			}

			function show() {
				this.currentIndex = 0;
				this.width = game.width;
				this.focus = true;
				this.visible = true;

				animTimer.stop();
			}
		}

		Rectangle {
			id: levelMenu;

			width: 0;
			height: game.blockSize * 3;

			anchors.centerIn: parent;

			focus: false;
			color: colorTheme.backgroundColor;
			clip: true;

			visible: false;

			Text {
				y: 9;

				anchors.horizontalCenter: parent.horizontalCenter;

				text: qsTr("Выберите уровень");
				color: colorTheme.highlightPanelColor;
				font: captionSmall;
			}

			ListView {
				id: levelGrid;

				property int cellWidth: game.width / levelModel.count;
				property int cellHeight: game.blockSize * 1.5;

				width: game.width;
				height: cellHeight;

				anchors.bottom: parent.bottom;

				focus: true;
				orientation: Horizontal;

				visible: parent.width > 0;

				model: ListModel {
					id:levelModel;

					ListElement {text: "1"}
					ListElement {text: "2"}
					ListElement {text: "3"}
					ListElement {text: "4"}
					ListElement {text: "5"}
					ListElement {text: "6"}
					ListElement {text: "7"}
					ListElement {text: "8"}
					ListElement {text: "9"}
					ListElement {text: "10"}
				}

				delegate: LevelDelegate { }

				onSelectPressed: {
					levelMenu.width = 0;
					levelMenu.focus = false;
					levelMenu.visible = false;

					animTimer.start();
				}

				onKeyPressed: {
					if (key == "8") {
						return true;
					}

					if (key == "6") {
						return true;
					}
				}
			}

			function show() {
				this.currentIndex = 0;
				this.width = game.width;
				this.focus = true;
				this.visible = true;

				animTimer.stop();
			}
		}

		Rectangle {
			id: pauseRect;

			width: game.width;
			height: game.blockSize * 6 + game.space * 4;

			anchors.centerIn: parent;

			focus: true;
			color: colorTheme.backgroundColor;

			visible: false;

			Text {
				anchors.centerIn: parent;

				text: qsTr("Пауза...");
				color: colorTheme.highlightPanelColor;
				font: bodyFont;
			}

			onKeyPressed: {
				if (key == "8") {
					this.visible = false;
					this.focus   = false;

					animTimer.start();

					return true;
				}

				if (key == "Select") {
					return true;
				}
			}

			function show() {
				this.visible = true;
				this.focus = true;

				animTimer.stop();
			}

		}

		onKeyPressed: {
			if (key == "Select") {
				exitMenu.show();
				return true;
			}

			if (key == "8") {
				pauseRect.show();
				return true;
			}

			if (key == "7") {
				levelMenu.show();
				return true;
			}

			if (key == "6") {
				gameOverMenu.show();
				return true;
			}
		}

		function getNewColor () {
			this.nextBlockColor = engine.randomColor();
		}

		function getNewBlock () {
			this.nextBlock = engine.randomBlock();
		}

		function drawNextBlockView () {
			for(var i = 0; i< 16; i++)
			{
				nextTetraminos.children[i].innerRect.blockGradient.blockGradientStart.color = engine.getGradientStart(game.nextBlockColor);
				nextTetraminos.children[i].innerRect.blockGradient.blockGradientEnd.color = engine.getGradientEnd(game.nextBlockColor);
			}

			var bit;
			var indexBlock = 0;
			for(bit = 0x8000 ; bit > 0 ; bit = bit >> 1) {
				if (game.nextBlock & bit) {
					nextTetraminos.children[indexBlock].rect.value = 1;
				}
				else
				{
					nextTetraminos.children[indexBlock].rect.value = 0;
				}
				indexBlock++;
			}
		}
		function drawMovingBlock () {
		//FIXME повторяется
			var bit;
			var indexBlock = 0;
			for(bit = 0x8000 ; bit > 0 ; bit = bit >> 1) {
				if (game.currentBlock & bit) {
					movingTetraminos.children[indexBlock].rect.value = 1;
				}
				else
				{
					movingTetraminos.children[indexBlock].rect.value = 0;
				}
				indexBlock++;
			}
		}

		//FIXME: проверка не только выхода за границы
		function hasCollisions (x,y,value) {
			if ( ( x < 0 || x > game.width || y >= game.height) && value > 0)
				return true;

			return false;
		}

		function initNewMovingBlock () {
			game.currentBlock = game.nextBlock;
			game.currentBlockColor = game.nextBlockColor;

			game.getNewBlock();
			game.getNewColor();
			game.drawNextBlockView();

			movingTetraminos.initMovingBlockCoord();
			game.drawMovingBlock();

			animTimer.restart();
		}
	}
}
