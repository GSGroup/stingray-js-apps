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

		anchors.centerIn: parent;

		cellWidth: 32hpw;
		cellHeight: 32hph;

		model: cellsModel;
		delegate: CellDelegate { }
	}

	Item {
		anchors.fill: cells;

		Image {
			id: throwingObject;

			width: 32hpw;
			height: 32hph;

			source: "apps/fontanero/t/7.png";

			visible: false;

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

			Behavior on x { animation: Animation { duration: 200; } }
			Behavior on y { animation: Animation { duration: 200; } }
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

		height: 100hph;

		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.top: parent.top;
	}

	BodyText {
		id: menuPanel;

		height: 250hph;

		anchors.right: parent.right;
		anchors.verticalCenter: parent.verticalCenter;
	}

	Item {
		id: fontaneroInput;

		focus: true;

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

		width: parent.width / 3;
		height: parent.height / 4;

		anchors.centerIn: parent;

		color: colorTheme.globalBackgroundColor;

		visible: false;

		SubheadText {
			anchors.topMargin: -10hph;
			anchors.centerIn: parent;

			text: "YOU'RE DEAD! Continue?";
		}

		Row {
			anchors.bottom: parent.bottom;
			anchors.margins: 10hpw;
			anchors.horizontalCenter: parent.horizontalCenter;

			Button {
				id: continueButton;

				text: "Continue";

				onSelectPressed: { console.log("continue"); ui.map.restart(); restartDialog.visible = false; }
			}

			Button {
				id: restartButton;

				text: "Restart";

				onSelectPressed: { console.log("restart"); fontanero.startGame(); restartDialog.visible = false; }
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

		property string text;

		anchors.fill: mainWindow;

		color: "#333c";

		visible: false;

		TitleText {
			anchors.centerIn: parent;

			text: parent.text;
		}
	}

	Rectangle {
		id: winPanel;

		property string text;
		property int tile: 4;

		anchors.fill: mainWindow;

		color: "#333c";

		visible: false;

		TitleText {
			id: winText;

			anchors.centerIn: parent;

			text: parent.text;
		}

		Image {
			id: winPanelImage;

			width: 128hpw;
			height: 128hph;

			anchors.right: winText.left;
			anchors.margins: 64hpw;
			anchors.verticalCenter: winText.verticalCenter;

			fillMode: ui.Image.FillMode.Stretch;
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
		console.log("game over");
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

	onVisibleChanged: {
		if (visible && !ui.map) {
			this.startGame();
		}
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
		console.log("Fontanero HD. Adventure for Gold and Glory. v4 argile qml");
	}
}
