import "MenuDelegate.qml";
import "CellDelegate.qml";

Rectangle{
	id: mainWindow;

	width:safeArea.width;
	height:safeArea.height;

	color:"#05090C";

	visible:true;

	focus: true;

	Rectangle {
		id: game;

		property int glassWidth: 10;
		property int glassHigh: 20;
		property real dropTime: 2000.0;

		property int space: 6;
		property int spaceBetweenBlocks:2;
		property int blockSize: (safeArea.height - space * 4) / glassHigh;

		width: blockSize * glassWidth;
		height: blockSize * glassHigh;

		anchors.centerIn: parent;

		color: "#3F4042";
		focus: true;
		radius: 5;

		Rectangle {
			id:infoRect;

			width: parent.width;
			height: parent.height;

			anchors.top: parent.top;
			anchors.left:parent.right;
			anchors.bottomMargin: game.space;
			anchors.leftMargin: game.blockSize * 3;

			color: "#05090C";
			focus: false;

			visible: true;

			Rectangle {
				id:nextBlockViewRect;

				width: game.blockSize * 6 + game.spaceBetweenBlocks * 3;
				height: game.blockSize * 6 + game.spaceBetweenBlocks * 3;

				anchors.top: parent.top;
				anchors.left:parent.left;

				color: "#05090C";

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

					Timer {
						id: nextBlockTimer;

						interval: game.dropTime;
						running: true;
						repeat: true;

						onTriggered: {

							// TODO:вынести в отдельную функцию

							var colorGradientStart = ["#E49C8B","#E297D8","#E7CD6E","#B2C016","#7298E3"];
							var colorGradientEnd = ["#CE573D","#D151BD","#D9B42F","#919C11","#366DD9"];
							var colorIndex = Math.floor(Math.random() * 4);

							for(var i = 0; i< 16; i++)
							{
								nextTetraminos.children[i].innerRect.blockGradient.blockGradientStart.color = colorGradientStart[colorIndex];
								nextTetraminos.children[i].innerRect.blockGradient.blockGradientEnd.color = colorGradientEnd[colorIndex];
							}

							var j = [0x44C0, 0x8E00, 0x6440, 0x0E20];
							var l = [0x4460, 0x0E80, 0xC440, 0x2E00];
							var o = [0xCC00, 0xCC00, 0xCC00, 0xCC00];
							var i = [0x0F00, 0x2222, 0x00F0, 0x4444];
							var s = [0x06C0, 0x8C40, 0x6C00, 0x4620];
							var t = [0x0E40, 0x4C40, 0x4E00, 0x4640];
							var z = [0x0C60, 0x4C80, 0xC600, 0x2640];

							var pieces = [i,j,l,o,s,t,z];
							var indexBlockView = Math.floor(Math.random() * 3);
							var next = pieces[Math.floor(Math.random() * 7)];
							var nextBlock = next[indexBlockView];

							var bit;
							var indexBlock = 0;
							for(bit = 0x8000 ; bit > 0 ; bit = bit >> 1) {
								if (nextBlock & bit) {
									nextTetraminos.children[indexBlock].innerRect.visible = true;
								}
								else
								{
									nextTetraminos.children[indexBlock].innerRect.visible = false;
								}
								indexBlock++;
							}
						}
					}

					onCompleted: {
						for (var i = 0; i < 16; i ++) {
							this.children[i].rect.x = (i % 4) * (game.blockSize + game.spaceBetweenBlocks);
							this.children[i].rect.y = Math.floor(i / 4 ) * (game.blockSize + game.spaceBetweenBlocks);
						}
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
				color: "#FFFAEC";
				font: Font {
					family: "Roboto Regular";
					pixelSize: 24;
				}
			}

			Text {
				id: scoreRect;

				anchors.left: parent.left;
				anchors.top: levelText.bottom;
				anchors.topMargin: game.blockSize;
				anchors.leftMargin: game.blockSize;

				text: qsTr("Счет");
				color: "#FFFAEC";
				font: Font {
					family: "Roboto Regular";
					pixelSize: 24;
				}
			}
		}

		Rectangle {
			id: backMenu;

			width: 0;
			height: game.blockSize * 8;

			anchors.centerIn: parent;

			focus: false;
			color: parent.color;
			radius: 5;
			clip: true;

			visible: false;
			opacity: 0.7;

			Behavior on width { animation: Animation { duration: 300; } }

			ListView {
				id: backGrid;

				property int cellWidth: game.blockSize * 6;
				property int cellHeight: game.blockSize * 8;

				width: game.blockSize * 6;
				height: game.blockSize * 8;

				anchors.horizontalCenter: parent.horizontalCenter;
				anchors.top: parent.top;

				focus: true;

				visible: parent.width > 0;

				model: ListModel {
					ListElement {text: "Продолжить"}
					ListElement {text: "Новая игра"}
					ListElement {text: "Помощь"}
				}

				delegate: MenuDelegate{}

				onSelectPressed: {
					switch (backGrid.currentIndex) {
					case 0:
						backMenu.width = 0;
						backMenu.focus = false;
						backMenu.visible = false;
						break;
					case 1:
						backMenu.width = 0;
						backMenu.focus = false;
						backMenu.visible = false;
						break;
					case 2:
						help.visible = true;
						help.focus = true;
						backGrid.visible = false;
						return true;
					}
				}

				onKeyPressed: {
					if (key == "8") {
						return true;
					}
				}
			}

			BigText {
				id: help;

				anchors.left: parent.left;
				anchors.right: parent.right;
				anchors.verticalCenter: parent.verticalCenter;
				anchors.margins: game.space * 10;

				horizontalAlignment: Text.AlignHCenter;

				color: "#FFFFFF";
				focus: false;
				text: qsTr ("Use your arrow keys to move the Tetriminos (game pieces). The aim is to create a horizontal line of ten units without gaps" +
							" by moving Tetriminos and rotating it by 90 degree. When such a line is created, it gets destroyed and any block above the" +
							" deleted line will fall.");
				font: smallFont;

				visible: false;

				wrapMode: Text.Wrap;

				onKeyPressed: {
					if (key == "Select") {
						this.visible = false;
						this.focus = false;
						backGrid.visible = true;
						return true;
					}
				}
			}

			function show() {
				this.currentIndex = 0;
				this.width = game.width * 2;
				this.focus = true;
				this.visible = true;
			}
		}

		Rectangle {
			id: pauseRect;

			width: game.width;
			height: game.blockSize * 6 + game.space * 4;

			anchors.centerIn: parent;

			focus: true;
			color: parent.color;
			radius: 5;

			visible: false;
			opacity: 1.0;

			Text {
				anchors.centerIn: parent;

				text: qsTr("Пауза");
				color: "#FFFFFF";
				font: smallFont;
			}

			function show() {
				this.visible = true;
				this.focus = true;
			}

			onKeyPressed: {
				if (key == "8") {
					this.visible = false;
					this.focus   = false;

					return true;
				}

				if (key == "Select") {
					return true;
				}
			}
		}

		onKeyPressed: {
			if (key == "Select") {
				backMenu.show();
				return true;
			}

			if (key == "8") {
				pauseRect.show();
				return true;
			}
		}
	}
}
