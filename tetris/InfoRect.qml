Rectangle {
	id: infoRect;

	Rectangle {
		id: nextBlockViewRect;

		width: game.blockSize * 6;
		height: game.blockSize * 6;

		color: colorTheme.globalBackgroundColor;

		Item {
			id: nextTetraminos;

			x: game.blockSize;
			y: game.blockSize;

			focus: false;

			visible: true;

			Cell { } Cell { } Cell { } Cell { }
			Cell { } Cell { } Cell { } Cell { }
			Cell { } Cell { } Cell { } Cell { }
			Cell { } Cell { } Cell { } Cell { }

			function drawNextBlockView() {
				for (var i = 0; i< 16; ++i)
				{
					nextTetraminos.children[i].blockColor = game.nextBlockColor;
				}

				var bit;
				var indexBlock = 0;
				for (bit = 0x8000 ; bit > 0 ; bit = bit >> 1) {
					if (game.nextBlock & bit) {
						nextTetraminos.children[indexBlock].value = 1;
					}
					else
					{
						nextTetraminos.children[indexBlock].value = 0;
					}
					indexBlock++;
				}
			}

			onCompleted: {
				for (var i = 0; i < 16; i ++) {
					nextTetraminos.children[i].x = (i % 4) * game.blockSize;
					nextTetraminos.children[i].y = Math.floor(i / 4 ) * game.blockSize;
				}

				nextTetraminos.drawNextBlockView();
			}
		}
	}

	Text {
		id: levelText;

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
