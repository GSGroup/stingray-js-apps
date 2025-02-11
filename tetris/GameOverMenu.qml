// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "MenuItem.qml";

Rectangle {
	id: gameOverRect;

	signal setNewGame();
	signal exitGame();

	color: colorTheme.activePanelColor;

	height: menuText.height + gameOverColumn.height + 70hph;

	visible: false;

	SubheadText {
		id: menuText;

		y: 20hph;

		anchors.horizontalCenter: gameOverRect.horizontalCenter;

		text: tr("Game over");
	}

	Column {
		id: gameOverColumn;

		anchors.top: menuText.bottom;
		anchors.left: gameOverRect.left;
		anchors.right: gameOverRect.right;

		anchors.topMargin: 30hph;
		anchors.leftMargin: 30hpw;
		anchors.rightMargin: 30hpw;

		anchors.horizontalCenter: gameOverRect.horizontalCenter;

		spacing: 16hph;
		focus: true;

		MenuItem {
			id: newGameItem;

			width: gameOverColumn.width;

			menuText: tr("Play again");

			onSelectPressed: { gameOverRect.setNewGame(); }
		}

		MenuItem {
			id: exitGameItem;

			width: gameOverColumn.width;

			menuText: tr("Exit");

			onSelectPressed: { gameOverRect.exitGame(); }
		}
	}

	function show() {
		gameOverRect.visible = true;
		newGameItem.setFocus();
		eventDispatcher.ReportEvent("GameOver", "tetris");
	}
}
