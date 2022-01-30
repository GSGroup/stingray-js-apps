// Copyright (c) 2011 - 2019, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "LevelDelegate.qml";
import "generatedfiles/tetrisConsts.js" as gameConsts;

Rectangle {
	id: levelRect;

	signal backToGame();
	signal levelChanged(level);

	color: colorTheme.activePanelColor;

	height: titleText.height + levelGrid.cellHeight + 60;

	visible: false;

	SubheadText {
		id: titleText;

		y: 20;

		anchors.horizontalCenter: parent.horizontalCenter;

		text: tr("Выберите уровень");
	}

	ListView {
		id: levelGrid;

		property int cellWidth: gameConsts.getGameWidth() / levelModel.count;
		property int cellHeight: 47;

		width: this.contentWidth;
		height: this.contentHeight;

		anchors.bottom: levelRect.bottom;
		anchors.bottomMargin: 20;

		focus: true;
		orientation: Horizontal;
		uniformDelegateSize: true;

		visible: true;

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

		onSelectPressed: { levelRect.levelChanged(levelGrid.currentIndex + 1); }

		onRightPressed: {
			if (levelGrid.currentIndex === levelModel.count - 1)
			{
				levelGrid.currentIndex = 0;
			}
			else
			{
				++levelGrid.currentIndex;
			}
		}

		onLeftPressed: {
			if (levelGrid.currentIndex === 0)
			{
				levelGrid.currentIndex = levelModel.count - 1;
			}
			else
			{
				--levelGrid.currentIndex;
			}
		}
	}

	function show() {
		levelRect.visible = true;
		levelGrid.currentIndex = 0;
		levelGrid.setFocus();
	}
}
