import Player
import GameCell
import controls.Text

Game : Rectangle {
	color: "#003";
	focus: true;
	id: pacmanGame;

	property int dx;
	property int dy;
	property bool horizontal;

	property int speed: 250;
	property int score: 0;
	property int cells: 21;

	ListModel {
		id: gameGridModel;

		function getCell(x, y) {
			return (x >= 0 && x < this.w && y >= 0 && y < this.h)? this.get(x + y * this.w): { "walls": 15, "dot": false };
		}

		function setCell(x, y, cell) {
			return this.set(x + y * this.w, cell);
		}

		function setCellProperty(x, y, name, value) {
			return this.setProperty(x + y * this.w, name, value);
		}

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
			id: player;
			z: 1;
			width: gameView.cellWidth;
			height: gameView.cellHeight;
			cellX: 1;
			cellY: 1;
			speed: pacmanGame.speed;
		}
	}

	BigText {
		text: "SCORE\n" + pacmanGame.score;
		horizontalAlignment: AlignHCenter;

		anchors.right: parent.left;
		anchors.rightMargin: 10;
	}

	Timer {
		repeat: true;
		running: true;
		interval: pacmanGame.speed;

		onTriggered: {
			var cell = gameGridModel.getCell(player.cellX, player.cellY);
			if (cell.dot) {
				pacmanGame.score += 100;
				cell.dot = true;
				gameGridModel.setCellProperty(player.cellX, player.cellY, "dot", false);
			}
			var x = player.cellX, y = player.cellY;
			var dx = pacmanGame.dx, dy = pacmanGame.dy;
			var horizontal = pacmanGame.horizontal;

			var next_h_cell = gameGridModel.getCell(x + dx, y);
			var next_v_cell = gameGridModel.getCell(x, y + dy);

			if (next_h_cell.walls)
				dx = 0;
			if (next_v_cell.walls)
				dy = 0;

			if (!next_h_cell.walls && !next_v_cell.walls) { //both variants are valid, prefer last direction
				if (horizontal)
					dy = 0;
				else
					dx = 0;
			}

			player.cellX = x + dx;
			player.cellY = y + dy;
		}
	}

	onKeyPressed: {
		if (key == "Left") {
			this.dx = -1;
			this.horizontal = true;
		} else if (key == "Right") {
			this.dx = 1;
			this.horizontal = true;
		} else if (key == "Up") {
			this.dy = -1;
			this.horizontal = false;
		} else if (key == "Down") {
			this.dy = 1;
			this.horizontal = false;
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

