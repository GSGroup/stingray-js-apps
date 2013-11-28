import "ui.js" as ui
import "game.js" as game
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
	anchors.fill: mainWindow;
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

	Item {
		focus: true;

		onKeyPressed: {
			if (key == "Back") {
				visible = false;
				return true;
			}
			ui.on_key(key.toLowerCase());
			return true;
		}
	}

	onCompleted: {
		ui.logText = logText;
		ui.overlayPanel = overlayPanel;
		ui.cellsModel = cellsModel;
	}

	onVisibleChanged: {
		if (visible && !ui.map) {
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
			log("Fontanero HD. Adventure for Gold and Glory. v4 argile qml");
		}
	}
}
