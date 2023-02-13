// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "MenuItem.qml";

Rectangle {
	id: exitRect;

	signal setNewGame();
	signal backToGame();
	signal exitGame();

	height: gameExitColumn.height + 40hph;

	color: colorTheme.activePanelColor;

	visible: false;

	Column {
		id: gameExitColumn;

		anchors.top: exitRect.top;
		anchors.left: exitRect.left;
		anchors.right: exitRect.right;

		anchors.topMargin: 20;
		anchors.leftMargin: 30hpw;
		anchors.rightMargin: 30hpw;

		spacing: 16;
		focus: true;

		MenuItem {
			id: exitItem;

			width: parent.width;

			menuText: tr("Exit");

			onSelectPressed: { exitRect.exitGame(); }
		}

		MenuItem {
			id: continueItem;

			width: parent.width;

			menuText: tr("Resume");

			onSelectPressed: { exitRect.backToGame(); }
		}

		MenuItem {
			id: newItem;

			width: parent.width;

			menuText: tr("New game");

			onSelectPressed: { exitRect.setNewGame(); }
		}
	}

	function show() {
		exitRect.visible = true;
		exitItem.setFocus();
	}
}
