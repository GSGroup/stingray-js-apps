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

				enum { None, Left, Right, Up, Down };
				property int inputDirection: None;

				width: gameConsts.getCellWidth();
				height: gameConsts.getCellHeight();

				cellX: 1;
				cellY: 1;
				speed: gameConsts.getSpeed();
			}

			Item {
				id: enemies;

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
				engine.getPoint(player.cellX, player.cellY).visible = false;
			}

			const inputDirection = player.inputDirection;
			const inputX = inputDirection == player.Left ? -1 : inputDirection == player.Right ? 1 : 0;
			const inputY = inputDirection == player.Up ? -1 : inputDirection == player.Down ? 1 : 0;

			const cellX = player.cellX, cellY = player.cellY;

			if (inputX != 0 && !gameField.isWall(gameField.getCell(cellX + inputX, cellY))) {
				player.dx = inputX;
				player.dy = 0;
			}
			else if (inputY != 0 && !gameField.isWall(gameField.getCell(cellX, cellY + inputY))) {
				player.dx = 0;
				player.dy = inputY;
			}
			else {
				if (player.dx != 0 && gameField.isWall(gameField.getCell(cellX + player.dx, cellY)))
					player.dx = 0;

				if (player.dy != 0 && gameField.isWall(gameField.getCell(cellX, cellY + player.dy)))
					player.dy = 0;
			}

			player.move();
			player.inputDirection = player.None;

			for (let i = 0; i < enemies.children.length; ++i) {
				const enemy = enemies.children[i];

				let dx = enemy.dx, dy = enemy.dy;
				while (true) {
					if (gameField.isWall(gameField.getCell(enemy.cellX + dx, enemy.cellY + dy))) {
						if (dx > 0) { dy = 1; dx = 0; }
						else if (dx < 0) { dy = -1; dx = 0; }
						else if (dy > 0) { dx = -1; dy = 0; }
						else if (dy < 0) { dx = 1; dy = 0; }
					} else
						break;
				}

				enemy.dx = dx;
				enemy.dy = dy;
				enemy.move();
			}
		}
	}

	onKeyPressed: {
		if (key == "Left") {
			player.inputDirection = player.Left;
			return true;
		} else if (key == "Right") {
			player.inputDirection = player.Right;
			return true;
		} else if (key == "Up") {
			player.inputDirection = player.Up;
			return true;
		} else if (key == "Down") {
			player.inputDirection = player.Down;
			return true;
		}
	}

	function init() {
		engine.setGrid(gameConsts.getGrid());
	}

	onCompleted: {
		pacmanGame.init();
	}
}
