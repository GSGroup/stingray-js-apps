// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "Enemy.qml";
import "GameCell.qml";
import "Player.qml";

Rectangle {
	id: pacmanGame;

	property bool horizontal;

	property int speed: 250;
	property int score;
	property int cells: 21;

	color: "#003";
	focus: true;

	ListModel {
		id: gameGridModel;

		function getCell(x, y) {
			return (x >= 0 && x < this.width && y >= 0 && y < this.height)? this.get(x + y * this.width): { "walls": 15, "dot": false };
		}

		function setCell(x, y, cell) {
			return this.set(x + y * this.width, cell);
		}

		function setCellProperty(x, y, name, value) {
			return this.setProperty(x + y * this.width, name, value);
		}

		function hline(l, r, y) {
			for (var i = l; i < r; ++i) {
				var idx = y * this.width + i;
				var c = this.get(idx).walls;
				c |= (i != l? 8: 0) | (i + 1 != r? 2: 0);
				this.setProperty(idx, "walls", c);
				this.setProperty(idx, "dot", false);
			}
		}

		function vline(t, b, x) {
			for (var i = t; i < b; ++i) {
				var idx = i * this.width + x;
				var c = this.get(idx).walls;
				c |= (i != t? 1: 0) | (i + 1 != b? 4: 0);
				this.setProperty(idx, "walls", c);
				this.setProperty(idx, "dot", false);
			}
		}

		function box(x, y, width, height, dots) {
			var l = x, r = x + width, t = y, b = y + height;
			console.log("box " + l + ", " + t + ", " + r + ", " + b);
			this.hline(l, r, t);
			this.hline(l, r, b - 1);
			this.vline(t, b, l);
			this.vline(t, b, r - 1);
			for (var i = t + 1; i + 1 < b; ++i)
			{
				var row = i * this.width;
				for (var j = l + 1; j + 1 < r; ++j) {
					var idx = row + j;
					this.setProperty(idx, "dot", dots);
				}
			}
		}

		function init(width, height) {
			console.log("setting model size to " + width + "x" + height);
			this.width = width;
			this.height = height;
			for (var i = 0; i < height; ++i)
				for (var j = 0; j < width; ++j) {
					gameGridModel.append({ "dot": true, "walls": 0 });
				}
		}
	}

	GridView {
		id: gameView;

		width: cellWidth * parent.cells;
		height: cellHeight * parent.cells;

		anchors.centerIn: parent;

		handleNavigationKeys: false;

		model: gameGridModel;
		delegate: GameCell { }

		cellWidth: Math.floor(parent.width / parent.cells);
		cellHeight: Math.floor(parent.height / parent.cells);

		Player {
			id: player;

			width: gameView.cellWidth;
			height: gameView.cellHeight;

			cellX: 1;
			cellY: 1;
			speed: pacmanGame.speed;
		}

		Item {
			id: enemies;

			z: 1;

			Enemy {
				width: gameView.cellWidth;
				height: gameView.cellHeight;

				color: "#f00";

				cellX: 1;
				cellY: 12;
				dx: 1;
				speed: pacmanGame.speed;
			}

			Enemy {
				width: gameView.cellWidth;
				height: gameView.cellHeight;

				color: "#f0f";

				cellX: 12;
				cellY: 10;
				dx: -1;
				speed: pacmanGame.speed;
			}

			Enemy {
				width: gameView.cellWidth;
				height: gameView.cellHeight;

				color: "#0ff";

				cellX: 19;
				cellY: 9;
				faceLeft: true;
				dy: 1;
				speed: pacmanGame.speed;
			}

			Enemy {
				width: gameView.cellWidth;
				height: gameView.cellHeight;

				color: "#fc0";

				cellX: 10;
				cellY: 10;
				faceLeft: true;
				dy: -1;
				speed: pacmanGame.speed;
			}
		}
	}

	TitleText {
		anchors.right: parent.left;
		anchors.rightMargin: 10hpw;

		horizontalAlignment: AlignHCenter;

		text: "SCORE\n" + pacmanGame.score;
	}

	Timer {
		repeat: true;
		running: true;
		interval: pacmanGame.speed;

		onTriggered: {
			var cell = gameGridModel.getCell(player.cellX, player.cellY);
			if (cell.dot) {
				pacmanGame.score += 100;
				gameGridModel.setCellProperty(player.cellX, player.cellY, "dot", false);
			}
			var x = player.cellX, y = player.cellY;
			var dx = player.dx, dy = player.dy;
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

			//enemy phase
			var ens = enemies.children;
			for (var i = 0; i < ens.length; ++i) {
				var obj = ens[i];
				var x = obj.cellX, y = obj.cellY;
				var dx = obj.dx, dy = obj.dy;

				while (true) {
					var next_cell = gameGridModel.getCell(x + dx, y + dy);
					if (next_cell.walls) {
						if (dx > 0) { dy = 1; dx = 0; }
						else if (dx < 0) { dy = -1; dx = 0; }
						else if (dy > 0) { dx = -1; dy = 0; }
						else if (dy < 0) { dx = 1; dy = 0; }
					} else
						break;
				}

				obj.dx = dx;
				obj.dy = dy;
				obj.cellX = x + dx;
				obj.cellY = y + dy;
			}
		}
	}

	onKeyPressed: {
		if (key == "Left") {
			player.dx = -1;
			this.horizontal = true;
			return true;
		} else if (key == "Right") {
			player.dx = 1;
			this.horizontal = true;
			return true;
		} else if (key == "Up") {
			player.dy = -1;
			this.horizontal = false;
			return true;
		} else if (key == "Down") {
			player.dy = 1;
			this.horizontal = false;
			return true;
		}
	}

	onVisibleChanged: {
		if (visible)
			this.setFocus();
	}

	onCompleted: {
		gameGridModel.init(this.cells, this.cells);
		gameGridModel.box(0, 0, this.cells, this.cells, true);

		for (var i = 0; i < 2; ++i) {
			var p = i * 4;
			gameGridModel.box(2, 2 + p, 4, 3);
			gameGridModel.box(7, 2 + p, 3, 3);

			gameGridModel.box(this.cells - 10, 2 + p, 3, 3);
			gameGridModel.box(this.cells - 6, 2 + p, 4, 3);
		}

		for (var i = 0; i < 2; ++i) {
			var p = i * 4 + 5;

			gameGridModel.box(2, this.cells - p, 4, 3);
			gameGridModel.box(7, this.cells - p, 3, 3);

			gameGridModel.box(this.cells - 10, this.cells - p, 3, 3);
			gameGridModel.box(this.cells - 6, this.cells - p, 4, 3);
		}
	}
}
