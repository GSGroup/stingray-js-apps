// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.Button;
import controls.Edit;
import controls.Player;

Application {
	id: playerTestApp;

	PageStack {
		id: pageStack;

		anchors.fill: parent;

		Column {
			anchors.centerIn: parent;

			spacing: 20hph;

			Edit {
				id: urlEdit;

				anchors.horizontalCenter: parent.horizontalCenter;

				width: safeArea.width - 100hpw;

				horizontalAlignment: paintedWidth > width ? ui.Text.HorizontalAlignment.AlignRight : ui.Text.HorizontalAlignment.AlignHCenter;

				onSelectPressed: {
					urlKeyboard.initialText = text;
					urlKeyboard.visible = true;
				}
			}

			Button {
				anchors.horizontalCenter: parent.horizontalCenter;

				text: "Play as generic media URL";

				onSelectPressed: {
					pageStack.currentIndex = 1;
					player.playUrl(urlEdit.text);
					player.setFocus();
				}
			}

			Button {
				anchors.horizontalCenter: parent.horizontalCenter;

				text: "Play as HLS URL";

				onSelectPressed: {
					pageStack.currentIndex = 1;
					player.playHls(urlEdit.text);
					player.setFocus();
				}
			}
		}

		Item {
			anchors.fill: parent;

			Player {
				id: player;

				anchors.fill: mainWindow;

				onStopped: { pageStack.currentIndex = 0; }

				onFinished: (finished) { pageStack.currentIndex = 0; }

				onVisibleChanged: {
					if (!visible)
						pageStack.currentIndex = 0;
				}
			}
		}
	}

	InputKeyboard {
		id: urlKeyboard;

		savedWordsGroup: "PlayerTestUri";

		onAccepted: (text) { urlEdit.text = text; }

		onVisibleChanged: {
			if (!visible)
				urlEdit.setFocus();
		}
	}

	onBackPressed: { appManager.closeCurrentApp(); }

	onStarted: {
		pageStack.currentIndex = 0;
		urlEdit.text = "";

		urlKeyboard.resetLanguage();
		urlKeyboard.resetKeyboard();

		urlEdit.setFocus();
	}

	onStopped: {
		urlKeyboard.visible = false;

		if (player.visible)
			player.stop();
	}
}
