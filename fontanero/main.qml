// Copyright (c) 2011 - 2019, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "ui.js" as ui
import "game.js" as game
import controls.Button;
import "Minigame.qml";
import "CellDelegate.qml";

Application {
	id: fontanero;
	focus: true;
	color: "#055";

	AlphaControl {}

	ListModel {
		id: cellsModel;
	}

	GridView {
		id: cells;
		model: cellsModel;
		cellWidth: 32;
		cellHeight: 32;
		anchors.centerIn: parent;
		delegate: CellDelegate { }
	}

	Item {
		anchors.fill: cells;
		Image {
			id: throwingObject;
			width: 32;
			height: 32;
			source: "apps/fontanero/t/7.png";
			visible: false;
			Behavior on x {
				animation: Animation {
					duration: 200;
				}
			}
			Behavior on y {
				animation: Animation {
					duration: 200;
				}
			}
			Timer {
				id: throwingObjectTimer;
				running: throwingObject.visible;
				interval: 200;
				onTriggered: {
					throwingObject.visible = false;
					if (this.finalize)
						this.finalize();
				}
			}
		}
	}

	BodyText {
		id: logText;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.bottom: parent.bottom;
	}

	BodyText {
		id: overlayPanel;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.top: parent.top;
		height: 100;
	}

	BodyText {
		id: menuPanel;
		anchors.right: parent.right;
		anchors.verticalCenter: parent.verticalCenter;
		height: 250;
	}

	Item {
		focus: true;
		id: fontaneroInput;

		onKeyPressed: {
			if (!fontanero.visible)
				return false;

			if (key != "Back") {
				ui.on_key(key.toLowerCase());
				return true;
			}
			else
				return false;
		}
	}

	Rectangle {
		id: restartDialog;
		visible: false;

		color: colorTheme.backgroundColor;
		width: parent.width / 3;
		height: parent.height / 4;
		anchors.centerIn: parent;

		SubheadText {
			anchors.topMargin: -10;
			anchors.centerIn: parent;
			text: "YOU'RE DEAD! Continue?";
		}

		Row {
			anchors.margins: 10;
			anchors.bottom: parent.bottom;
			anchors.horizontalCenter: parent.horizontalCenter;

			Button {
				id: continueButton;
				text: "Continue";
				onSelectPressed: { log("continue"); ui.map.restart(); restartDialog.visible = false; }
			}

			Button {
				id: restartButton; text: "Restart";
				onSelectPressed: { log("restart"); fontanero.startGame(); restartDialog.visible = false; }
			}
		}
		onVisibleChanged: {
			if (!visible)
			{
				fontaneroInput.setFocus();
				ui.panel();
			}
		}
	}

	Minigame {
		id: minigame;
		anchors.fill: parent;
		onVisibleChanged: {
			if (!visible) {
				ui.map.hero.add_cash(this.bonus);
				this.bonus = 0;
				fontaneroInput.setFocus();
			}
		}
	}

	Rectangle {
		id: hintPanel;
		visible: false;

		property string text;

		anchors.fill: mainWindow;
		color: "#333c";

		TitleText {
			anchors.centerIn: parent;
			text: parent.text;
		}
	}

	Rectangle {
		id: winPanel;
		visible: false;

		property string text;
		property int tile: 4;

		anchors.fill: mainWindow;
		color: "#333c";

		TitleText {
			id: winText;
			anchors.centerIn: parent;
			text: parent.text;
		}

		Image {
			id: winPanelImage;
			anchors.right: winText.left;
			anchors.verticalCenter: winText.verticalCenter;
			anchors.margins: 64;

			width: 128;
			height: 128;
			fillMode: Stretch;
			source: "apps/fontanero/t/" + parent.tile + ".png";
		}
		Timer {
			running: winPanel.visible;
			repeat: true;
			interval: 2000;
			onTriggered: {
				winPanel.tile = (winPanel.tile + 1) % 24
				if (winPanel.tile < 4)
					winPanel.tile = 4;
			}
		}
		onKeyPressed: {
			if (key == "Back" || key == "Select") {
				winPanel.visible = false;
				fontanero.startGame();
				return true;
			}
		}
	}

	gameOver: {
		log("game over");
		restartDialog.visible = true;
		restartDialog.continueButton.setFocus();
	}

	startGame: {
		var map = new game.dungeon_map(40, 24);
		cells.width = map.width * cells.cellWidth;
		cells.height = map.height * cells.cellHeight;
		game.set_map(map);

		ui.map = map;
		ui.map.repaint = ui.repaint;
		ui.map.repaint_all = ui.repaint_all;
		ui.map.win = ui.win;

		ui.intro();
		ui.map.generate();
		ui.panel();
		fontanero.setFocus();
	}

	onCompleted: {
		ui.logText = logText;
		ui.overlayPanel = overlayPanel;
		ui.cellsModel = cellsModel;
		ui.winPanel = winPanel;
		ui.gameOver = gameOver;
		ui.hintPanel = hintPanel;
		ui.throwingObject = throwingObject
		ui.throwingObjectTimer = throwingObjectTimer;
		ui.minigame = minigame;
		log("Fontanero HD. Adventure for Gold and Glory. v4 argile qml");
	}

	onVisibleChanged: {
		if (visible && !ui.map) {
			this.startGame();
		}
	}
}
