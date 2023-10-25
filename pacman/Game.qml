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

	NotificatorManager {
		id: notificatorManager;

		interval: 5000;
	}

	Rectangle {
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

				speed: gameConsts.getSpeed();
			}

			Item {
				id: enemies;

				Enemy {
					width: gameConsts.getCellWidth();
					height: gameConsts.getCellHeight();

					color: "#f00";

					speed: gameConsts.getSpeed();
				}

				Enemy {
					width: gameConsts.getCellWidth();
					height: gameConsts.getCellHeight();

					color: "#f0f";

					speed: gameConsts.getSpeed();
				}

				Enemy {
					width: gameConsts.getCellWidth();
					height: gameConsts.getCellHeight();

					color: "#0ff";

					speed: gameConsts.getSpeed();
				}

				Enemy {
					width: gameConsts.getCellWidth();
					height: gameConsts.getCellHeight();

					color: "#fc0";

					speed: gameConsts.getSpeed();
				}
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
		interval: gameConsts.getSpeed();

		onTriggered: {
			const point = engine.getPoint(player.cellX, player.cellY);
			if (point && point.visible) {
				pacmanGame.score += 100;
				point.visible = false;
			}

			const inputDirection = player.inputDirection;
			const inputX = inputDirection == player.Left ? -1 : inputDirection == player.Right ? 1 : 0;
			const inputY = inputDirection == player.Up ? -1 : inputDirection == player.Down ? 1 : 0;

			const cellX = player.cellX, cellY = player.cellY;

			if (inputX != 0 && !engine.isWall(cellX + inputX, cellY)) {
				player.dx = inputX;
				player.dy = 0;
			}
			else if (inputY != 0 && !engine.isWall(cellX, cellY + inputY)) {
				player.dx = 0;
				player.dy = inputY;
			}
			else {
				if (player.dx != 0 && engine.isWall(cellX + player.dx, cellY))
					player.dx = 0;

				if (player.dy != 0 && engine.isWall(cellX, cellY + player.dy))
					player.dy = 0;
			}

			player.move();
			player.inputDirection = player.None;

			for (let i = 0; i < enemies.children.length; ++i) {
				const enemy = enemies.children[i];

				let dx = enemy.dx, dy = enemy.dy;
				while (true) {
					if (engine.isWall(enemy.cellX + dx, enemy.cellY + dy)) {
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

				if (player.x < enemy.x + enemy.width &&
						player.x + player.width > enemy.x &&
						player.y < enemy.y + enemy.height &&
						player.y + player.height > enemy.y) {
					pacmanGame.notify("You died!");
					pacmanGame.reset();
					return;
				}
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
		player.reset(...gameConsts.getInitialPlayerPos());
		resetEnemies();

		engine.setGrid(gameConsts.getGrid());
	}

	function reset() {
		player.reset(...gameConsts.getInitialPlayerPos());
		resetEnemies();

		for (let x = 0; x < gameConsts.getGridWidth(); ++x) {
			for (let y = 0; y < gameConsts.getGridHeight(); ++y) {
				const point = engine.getPoint(x, y);
				if (point)
					point.visible = true;
			}
		}

		pacmanGame.score = 0;
	}

	function resetEnemies() {
		for (let i = 0; i < enemies.children.length; ++i) {
			const enemy = enemies.children[i];

			enemy.reset(...gameConsts.getInitialEnemyPos(i));

			enemy.dx = getRandomVelocity();
			enemy.dy = getRandomVelocity(enemy.dx != 0);
		}
	}

	function getRandomVelocity(allowZero = true) {
		const n = Math.floor(Math.random() * (allowZero ? 3 : 2));
		return n == 0 ? -1 : n % 2;
	}

	function notify(text) {
		notificatorManager.text = text;
		notificatorManager.addNotify();
	}

	onCompleted: {
		pacmanGame.init();
	}
}
