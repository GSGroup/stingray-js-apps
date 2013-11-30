import "ui.js" as ui
import "game.js" as game
import controls.Button
import controls.Text

CellDelegate : Image {
	width: 16;
	height: 16;
	source: model.tile >= 0? "apps/fontanero/t/" + model.tile + ".png": "";
	visible: model.tile >= 0;
}

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
		cellWidth: 16;
		cellHeight: 16;
		anchors.centerIn: parent;
		delegate: CellDelegate { }
	}

	Image {
		id: throwingObject;
		width: 16;
		height: 16;
		source: "apps/fontanero/t/7.png";
		visible: false;
		Behavior on x {
			animation: Animation {
				duration: 300;
			}
		}
		Behavior on y {
			animation: Animation {
				duration: 300;
			}
		}
	}

	SmallText {
		id: logText;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.bottom: parent.bottom;
	}

	SmallText {
		id: overlayPanel;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.top: parent.top;
		height: 100;
	}

	SmallText {
		id: menuPanel;
		anchors.right: parent.right;
		anchors.verticalCenter: parent.verticalCenter;
		height: 250;
	}

	Item {
		focus: true;
		id: fontaneroInput;

		onKeyPressed: {
			ui.on_key(key.toLowerCase());
			return true;
		}
	}

	Rectangle {
		id: restartDialog;
		visible: false;

		color: colorTheme.backgroundColor;
		width: parent.width / 3;
		height: parent.height / 4;
		anchors.centerIn: parent;

		MainText {
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
				fontaneroInput.focus = true;
				ui.panel();
			}
		}
	}
	Rectangle {
		id: hintPanel;
		visible: false;

		property string text;

		anchors.fill: mainWindow;
		color: "#333c";

		BigText {
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

		BigText {
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
		restartDialog.continueButton.focus = true;
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
		fontanero.focus = true;
	}

	onCompleted: {
		ui.logText = logText;
		ui.overlayPanel = overlayPanel;
		ui.cellsModel = cellsModel;
		ui.winPanel = winPanel;
		ui.gameOver = this.gameOver;
		ui.hintPanel = this.hintPanel;
		log("Fontanero HD. Adventure for Gold and Glory. v4 argile qml");
	}

	onVisibleChanged: {
		if (visible && !ui.map) {
			this.startGame();
		}
	}
}
