// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "Enemy.qml";
import "Player.qml";

import "generated_files/PacmanPointArray.qml";
import "generated_files/PacmanWallArray.qml";

import "engine.js" as engine;
import "generated_files/pacmanConsts.js" as gameConsts;

Rectangle {
	id: pacmanGame;

	property int score;

	color: "#003";
	focus: true;

	Rectangle {
		id: gameField;

		width: parent.width;
		height: parent.height;

		anchors.centerIn: parent;

		color: "#003";

		PacmanWallArray {
			anchors.centerIn: parent;

			PacmanPointArray { }

			Player {
				id: player;

				width: gameConsts.getCellWidth();
				height: gameConsts.getCellHeight();

				cellX: 1;
				cellY: 1;
				speed: gameConsts.getSpeed();
			}

			Item {
				id: enemies;

				z: 1;

				Enemy {
					width: gameConsts.getCellWidth();
					height: gameConsts.getCellHeight();

					color: "#f00";

					cellX: 15;
					cellY: 15;
					dx: 1;
					speed: gameConsts.getSpeed();
				}

				Enemy {
					width: gameConsts.getCellWidth();
					height: gameConsts.getCellHeight();

					color: "#f0f";

					cellX: 15;
					cellY: 16;
					dx: -1;
					speed: gameConsts.getSpeed();
				}

				Enemy {
					width: gameConsts.getCellWidth();
					height: gameConsts.getCellHeight();

					color: "#0ff";

					cellX: 15;
					cellY: 17;
					faceLeft: true;
					dy: 1;
					speed: gameConsts.getSpeed();
				}

				Enemy {
					width: gameConsts.getCellWidth();
					height: gameConsts.getCellHeight();

					color: "#fc0";

					cellX: 15;
					cellY: 18;
					faceLeft: true;
					dy: -1;
					speed: gameConsts.getSpeed();
				}
			}
		}

		function getCell(x, y) {
			return engine.getCellType(x, y);
		}

		function isWall(cell) {
			return cell != gameConsts.CellType.EMPTY && cell != gameConsts.CellType.POINT;
		}

		function init() {
			engine.setGrid(gameConsts.getGrid());
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
		interval: gameConsts.getSpeed();

		onTriggered: {
			if (gameField.getCell(player.cellX, player.cellY) == gameConsts.CellType.POINT) {
				pacmanGame.score += 100;
				engine.setCellType(player.cellX, player.cellY, gameConsts.CellType.EMPTY);
				engine.getObject(player.cellX + '/' + player.cellY).visible = false;
			}

			var cellX = player.cellX, cellY = player.cellY;
			var dx = player.dx, dy = player.dy;

			var is_next_h_cell_wall = gameField.isWall(gameField.getCell(cellX + dx, cellY));
			var is_next_v_cell_wall = gameField.isWall(gameField.getCell(cellX, cellY + dy));

			if (!is_next_h_cell_wall && !is_next_v_cell_wall) {
				if (pacmanGame.horizontal)
					dy = 0;
				else
					dx = 0;
			}
			else {
				if (is_next_h_cell_wall)
					dx = 0;

				if (is_next_v_cell_wall)
					dy = 0;
			}

			player.cellX = cellX + dx;
			player.cellY = cellY + dy;

			var enem = enemies.children;

			for (var i = 0; i < enem.length; ++i) {
				var oneEnemy = enem[i];
				var enemyCellX = oneEnemy.cellX, enemyCellY = oneEnemy.cellY;
				var dx = oneEnemy.dx, dy = oneEnemy.dy;

				while (true) {
					if (gameField.isWall(gameField.getCell(enemyCellX + dx, enemyCellY  + dy))) {
						if (dx > 0) { dy = 1; dx = 0; }
						else if (dx < 0) { dy = -1; dx = 0; }
						else if (dy > 0) { dx = -1; dy = 0; }
						else if (dy < 0) { dx = 1; dy = 0; }
					} else
						break;
				}

				oneEnemy.dx = dx;
				oneEnemy.dy = dy;
				oneEnemy.cellX = enemyCellX + dx;
				oneEnemy.cellY = enemyCellY + dy;
			}
		}
	}

	onKeyPressed: {
		if (key == "Left") {
			player.dx = -1;
			pacmanGame.horizontal = true;
			return true;
		} else if (key == "Right") {
			player.dx = 1;
			pacmanGame.horizontal = true;
			return true;
		} else if (key == "Up") {
			player.dy = -1;
			pacmanGame.horizontal = false;
			return true;
		} else if (key == "Down") {
			player.dy = 1;
			pacmanGame.horizontal = false;
			return true;
		}
	}

	onVisibleChanged: {
		if (visible)
			this.setFocus();
	}

	onCompleted: {
		gameField.init();
	}
}
