import "ui.js" as ui
import "game.js" as game
import controls.Button
import controls.Text

CellDelegate : Item {
	width: 16;
	height: 16;
	Image {
		anchors.fill: parent;
		source: model.tile >= 0? "apps/fontanero/t/" + model.tile + ".png": "";
		visible: model.tile >= 0;
	}
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
			if (key == "Back") {
				visible = false;
				return true;
			}
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
		ui.gameOver = this.gameOver;
		log("Fontanero HD. Adventure for Gold and Glory. v4 argile qml");
	}

	onVisibleChanged: {
		if (visible && !ui.map) {
			this.startGame();
		}
	}
}
