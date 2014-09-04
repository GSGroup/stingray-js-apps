import Player
import GameCell

Game : Rectangle {
	color: "#003";
	focus: true;

	property int dx;
	property int dy;

	ListModel {
		id: gameGridModel;

		function hline(l, r, y) {
			for(var i = l; i < r; ++i) {
				var idx = y * this.w + i;
				var c = this.get(idx).walls;
				c |= (i != l? 8: 0) | (i + 1 != r? 2: 0);
				this.setProperty(idx, "walls", c);
				this.setProperty(idx, "dot", false);
			}
		}

		function vline(t, b, x) {
			for(var i = t; i < b; ++i) {
				var idx = i * this.w + x;
				var c = this.get(idx).walls;
				c |= (i != t? 1: 0) | (i + 1 != b? 4: 0);
				this.setProperty(idx, "walls", c);
				this.setProperty(idx, "dot", false);
			}
		}

		function box(x, y, w, h, dots) {
			var l = x, r = x + w, t = y, b = y + h;
			log("box " + l + ", " + t + ", " + r + ", " + b);
			this.hline(l, r, t);
			this.hline(l, r, b - 1);
			this.vline(t, b, l);
			this.vline(t, b, r - 1);
			for(var i = t + 1; i + 1 < b; ++i)
			{
				var row = i * this.w;
				for(var j = l + 1; j + 1 < r; ++j) {
					var idx = row + j;
					this.setProperty(idx, "dot", dots);
				}
			}
		}

		function init(w, h) {
			log("setting model size to " + w + "x" + h);
			this.w = w;
			this.h = h;
			for(var i = 0; i < h; ++i)
				for(var j = 0; j < w; ++j) {
					gameGridModel.append({ "dot": true, "walls": 0 });
				}
		}
	}

	property int cells: 21;

	GridView
	{
		id: gameView;
		cellWidth: Math.floor(parent.width / parent.cells);
		cellHeight: cellWidth;
		width: cellWidth * parent.cells;
		height : width;

		model: gameGridModel;
		handleNavigationKeys: false;

		anchors.centerIn: parent;
		delegate : GameCell { }


		Player {
			z: 1;
			width: gameView.cellWidth;
			height: gameView.cellHeight;
			id: player;
			cellX: 1;
			cellY: 1;
		}
	}

	onKeyPressed: {
		if (key == "Left") {
			this.dx = -1;
			this.dy = 0;
		} else if (key == "Right") {
			this.dx = 1;
			this.dy = 0;
		} else if (key == "Up") {
			this.dx = 0;
			this.dy = -1;
		} else if (key == "Down") {
			this.dx = 0;
			this.dy = 1;
		}
	}

	onVisibleChanged: {
		if (visible) {
			log("game visible");
			this.setFocus();
		}
	}

	onCompleted : {
		gameGridModel.init(this.cells, this.cells);
		gameGridModel.box(0, 0, this.cells, this.cells, true);

		for(var i = 0; i < 2; ++i) {
			var p = i * 4;
			gameGridModel.box(2, 2 + p, 4, 3);
			gameGridModel.box(7, 2 + p, 3, 3);

			gameGridModel.box(this.cells - 10, 2 + p, 3, 3);
			gameGridModel.box(this.cells - 6, 2 + p, 4, 3);
		}

		for(var i = 0; i < 2; ++i) {
			var p = i * 4 + 5;

			gameGridModel.box(2, this.cells - p, 4, 3);
			gameGridModel.box(7, this.cells - p, 3, 3);

			gameGridModel.box(this.cells - 10, this.cells - p, 3, 3);
			gameGridModel.box(this.cells - 6, this.cells - p, 4, 3);
		}
	}
}

