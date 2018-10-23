Rectangle {
	id: infoRect;

	color: colorTheme.globalBackgroundColor;

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

			Cell { } Cell { } Cell { } Cell { }
			Cell { } Cell { } Cell { } Cell { }
			Cell { } Cell { } Cell { } Cell { }
			Cell { } Cell { } Cell { } Cell { }
		}
	}

	SmallCaptionText {
		id: levelText;

		anchors.top: nextBlockViewRect.bottom;
		anchors.topMargin: game.blockSize;
		anchors.leftMargin: game.blockSize;

		text: qsTr("Уровень");
		color: colorTheme.highlightPanelColor;
	}

	SmallCaptionText {
		id: scoreRect;

		anchors.top: levelText.bottom;
		anchors.topMargin: game.blockSize;
		anchors.leftMargin: game.blockSize;

		text: qsTr("Счет");
		color: colorTheme.highlightPanelColor;
	}

	function drawNextBlockView(nextBlockColor, nextBlock) {
		for (var i = 0; i< 16; ++i) {
			nextTetraminos.children[i].blockColor = nextBlockColor;
		}

		var bit;
		var indexBlock = 0;
		for (bit = 0x8000; bit > 0; bit = bit >> 1) {
			nextTetraminos.children[indexBlock].value = nextBlock & bit;
			++indexBlock;
		}
	}

	onCompleted: {
		for (var i = 0; i < 16; ++i) {
			nextTetraminos.children[i].x = (i % 4) * game.blockSize;
			nextTetraminos.children[i].y = Math.floor(i / 4 ) * game.blockSize;
		}
	}
}
