import "ui.js" as ui
import "game.js" as game
import controls.Text

CellDelegate : Item {
	width: 16;
	height: 16;
	Image {
		anchors.fill: parent;
		source: "apps/fontanero/t/" + model.tile + ".png";
	}
}

Application {
	anchors.fill: mainWindow;
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

	MainText {
		id: logText;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.bottom: parent.bottom;
		height: 100;
	}

	SmallText {
		id: overlayPanel;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.top: parent.top;
		height: 100;
	}

	onKeyPressed: {
		var key = key.toLowerCase();
		ui.on_key(key);
		return true;
	}

	onCompleted: {
		ui.logText = logText;
		ui.overlayPanel = overlayPanel;
	}

	onVisibleChanged: {
		if (visible) {

			var w = 40, h = 24;
			var map = new game.dungeon_map(w, h);
			this.map = map;

			cells.width = w * cells.cellWidth;
			cells.height = h * cells.cellHeight;
			for(var i = 0; i < w * h; ++i)
				cellsModel.append({ 'tile': i % 25 });

			map.repaint = ui.repaint;
			map.repaint_all = ui.repaint_all;
			map.win = ui.win;
			ui.map = map;

			log("Fontanero HD. Adventure for Gold and Glory. v4 argile qml");

			ui.intro();
			ui.map.generate();
			ui.panel();
		}
	}
}
