// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.ButtonWithShadow;

Dialog {
	id: gameDialogProto;

	signal goToNextLevel;
	signal continue;
	signal restart;
	signal exit;

	enum { Pause, NextLevel, GameOver };
	property int mode: Pause;

	property int score;

	width: buttonRow.width + 60hpw;
	height: headerColumnHeight + buttonRow.height + 30hph;

	title: gameDialogProto.mode == gameDialogProto.Pause ? tr("Pause") :
			gameDialogProto.mode == gameDialogProto.NextLevel ? tr("Level Completed! Score: ") + gameDialogProto.score :
			tr("Game Over! Score: ") + gameDialogProto.score;

	Row {
		id: buttonRow;

		y: gameDialogProto.headerColumnHeight;

		anchors.left: parent.left;
		anchors.leftMargin: 30hpw;

		spacing: 16hpw;

		ButtonWithShadow {
			text: tr("Next Level");

			visible: gameDialogProto.mode == gameDialogProto.NextLevel;

			onSelectPressed: { gameDialogProto.goToNextLevel(); }
		}

		ButtonWithShadow {
			text: tr("Continue");

			visible: gameDialogProto.mode == gameDialogProto.Pause;

			onSelectPressed: { gameDialogProto.continue(); }
		}

		ButtonWithShadow {
			text: tr("Restart");

			visible: gameDialogProto.mode != gameDialogProto.NextLevel;

			onSelectPressed: { gameDialogProto.restart(); }
		}

		ButtonWithShadow {
			text: tr("Exit");

			onSelectPressed: { gameDialogProto.exit(); }
		}
	}

	function showPause() {
		gameDialogProto.mode = gameDialogProto.Pause;
		gameDialogProto.doShow();
	}

	function showNextLevel(score) {
		gameDialogProto.score = score;
		gameDialogProto.mode = gameDialogProto.NextLevel;
		gameDialogProto.doShow();
	}

	function showGameOver(score) {
		gameDialogProto.score = score;
		gameDialogProto.mode = gameDialogProto.GameOver;
		gameDialogProto.doShow();
	}

	function hide() {
		gameDialogProto.visible = false;
	}

	function doShow() {
		buttonRow.resetFocus();
		gameDialogProto.visible = true;
	}
}
