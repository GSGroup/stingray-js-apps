// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "Enemy.qml";
import "GameDialog.qml";
import "Player.qml";

import "generated_files/PacmanPointArray.qml";
import "generated_files/PacmanWallArray.qml";

import "engine.js" as engine;
import "generated_files/pacmanConsts.js" as gameConsts;
import "utils.js" as utils;

Item {
	id: pacmanGame;

	signal exit;

	property enum { Scatter, Chase } enemyBehavior: Scatter;

	property bool isPlayerMoved;
	property int pointsCollected;
	property int level: 1;
	property int score;
	property int highScore;

	focus: true;

	Timer {
		id: animationTimer;

		repeat: true;
		running: pacmanGame.visible && !gameDialog.visible;
		interval: gameConsts.getAnimationDuration();

		onTriggered: {
			const point = engine.getPoint(player.cellX, player.cellY);
			if (point && point.visible) {
				point.visible = false;

				pacmanGame.pointsCollected += 1;
				pacmanGame.score += 10;

				if (pacmanGame.pointsCollected == engine.getPointsCount()) {
					pacmanGame.updateHighScore();
					gameDialog.showNextLevel(pacmanGame.score);
					return;
				}
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

			if (!pacmanGame.isPlayerMoved)
				return;

			for (let i = 0; i < enemies.children.length; ++i)
				pacmanGame.processEnemyAi(enemies.children[i], i);
		}
	}

	Timer {
		id: physicsTimer;

		interval: 1;
		repeat: true;
		running: animationTimer.running && pacmanGame.isPlayerMoved;

		onTriggered: {
			for (let i = 0; i < enemies.children.length; ++i) {
				const enemy = enemies.children[i];

				if (player.x < enemy.x + enemy.width &&
						player.x + player.width > enemy.x &&
						player.y < enemy.y + enemy.height &&
						player.y + player.height > enemy.y) {
					pacmanGame.updateHighScore();
					gameDialog.showGameOver(pacmanGame.score);
					return;
				}
			}
		}
	}

	Timer {
		id: enemyBehaviorTimer;

		repeat: true;
		running: animationTimer.running && pacmanGame.isPlayerMoved;

		onTriggered: { pacmanGame.setEnemyBehavior(pacmanGame.enemyBehavior == pacmanGame.Chase ? pacmanGame.Scatter : pacmanGame.Chase); }
	}

	Rectangle {
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.top: mainWindow.top;
		anchors.bottom: mainWindow.bottom;
	}

	Item {
		width: parent.width;
		height: parent.height;

		anchors.centerIn: parent;

		PacmanWallArray {
			anchors.centerIn: parent;

			PacmanPointArray { }

			Player {
				id: player;

				property enum { None, Left, Right, Up, Down } inputDirection: None;

				width: gameConsts.getCellWidth();
				height: gameConsts.getCellHeight();

				animationDuration: gameConsts.getAnimationDuration();
				animated: animationTimer.running;

				onInputDirectionChanged: {
					if (inputDirection != player.None)
						pacmanGame.isPlayerMoved = true;
				}
			}

			Item {
				id: enemies;

				Enemy {
					width: gameConsts.getCellWidth();
					height: gameConsts.getCellHeight();

					color: pacmanGame.enemyBehavior == pacmanGame.Chase ? gameConsts.getEnemyChaseColor() : "#34B67A";

					animationDuration: gameConsts.getAnimationDuration();
				}

				Enemy {
					width: gameConsts.getCellWidth();
					height: gameConsts.getCellHeight();

					color: pacmanGame.enemyBehavior == pacmanGame.Chase ? gameConsts.getEnemyChaseColor() : "#00FCFF";

					animationDuration: gameConsts.getAnimationDuration();

					targetOffsetX: 1;
				}

				Enemy {
					width: gameConsts.getCellWidth();
					height: gameConsts.getCellHeight();

					color: pacmanGame.enemyBehavior == pacmanGame.Chase ? gameConsts.getEnemyChaseColor() : "#FFA1CD";

					animationDuration: gameConsts.getAnimationDuration();

					targetOffsetY: 1;
				}

				Enemy {
					width: gameConsts.getCellWidth();
					height: gameConsts.getCellHeight();

					color: pacmanGame.enemyBehavior == pacmanGame.Chase ? gameConsts.getEnemyChaseColor() : "#FFCC00";

					animationDuration: gameConsts.getAnimationDuration();

					targetOffsetX: -1;
				}
			}
		}
	}

	SubheadText {
		id: scoreText;

		anchors.right: parent.left;
		anchors.rightMargin: 40hpw;

		text: tr("Score");
	}

	TitleText {
		id: scoreValueText;

		anchors.right: scoreText.right;
		anchors.top: scoreText.bottom;

		text: pacmanGame.score;
	}

	SubheadText {
		id: levelText;

		anchors.right: scoreText.right;
		anchors.top: scoreValueText.bottom;
		anchors.topMargin: 15hph;

		text: tr("Level");
	}

	TitleText {
		anchors.right: scoreText.right;
		anchors.top: levelText.bottom;

		text: pacmanGame.level;
	}

	SubheadText {
		id: highScoreText;

		anchors.left: parent.right;
		anchors.leftMargin: 40hpw;

		text: tr("High Score");
	}

	TitleText {
		anchors.left: highScoreText.left;
		anchors.top: highScoreText.bottom;

		text: pacmanGame.highScore;
	}

	GameDialog {
		id: gameDialog;

		anchors.centerIn: parent;

		onGoToNextLevel: {
			gameDialog.hide();

			pacmanGame.reset(true);
		}

		onContinue: { gameDialog.hide(); }

		onRestart: {
			gameDialog.hide();

			pacmanGame.reset();
		}

		onExit: { pacmanGame.exit(); }
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
		} else if (key == "Back" || key == "Menu") {
			gameDialog.showPause();
			return true;
		}
	}

	function init() {
		player.reset(...gameConsts.getInitialPlayerPos());
		resetEnemies();

		engine.setGrid(gameConsts.getGrid());

		pacmanGame.highScore = load("pacmanHighScore") || 0;
	}

	function updateHighScore() {
		if (pacmanGame.score <= pacmanGame.highScore)
			return;

		pacmanGame.highScore = pacmanGame.score;
		save("pacmanHighScore", pacmanGame.highScore);
	}

	function stop() {
		gameDialog.hide();

		pacmanGame.updateHighScore();
		pacmanGame.reset();
	}

	function reset(nextLevel = false) {
		player.reset(...gameConsts.getInitialPlayerPos());
		resetEnemies();

		for (let x = 0; x < gameConsts.getGridWidth(); ++x) {
			for (let y = 0; y < gameConsts.getGridHeight(); ++y) {
				const point = engine.getPoint(x, y);
				if (point)
					point.visible = true;
			}
		}

		pacmanGame.setEnemyBehavior(pacmanGame.Scatter);

		if (!nextLevel)
			pacmanGame.score = 0;

		pacmanGame.level = nextLevel ? pacmanGame.level + 1 : 1;
		pacmanGame.pointsCollected = 0;
		pacmanGame.isPlayerMoved = false;
	}

	function resetEnemies() {
		for (let i = 0; i < enemies.children.length; ++i)
			enemies.children[i].reset(...gameConsts.getInitialEnemyPos(i));
	}

	function processEnemyAi(enemy, enemyIndex) {
		const targetX = pacmanGame.enemyBehavior == pacmanGame.Scatter ? gameConsts.getEnemyScatterPos(enemyIndex)[0] : player.cellX + enemy.targetOffsetX;
		const targetY = pacmanGame.enemyBehavior == pacmanGame.Scatter ? gameConsts.getEnemyScatterPos(enemyIndex)[1] : player.cellY + enemy.targetOffsetY;

		let dx = 0, dy = 0;
		let minDistanceSquared = Infinity;

		// Check upper cell
		if (enemy.dy != 1 && !engine.isWall(enemy.cellX, enemy.cellY - 1)) {
			const d = utils.getDistanceSquared(enemy.cellX, enemy.cellY - 1, targetX, targetY);
			if (d < minDistanceSquared) {
				minDistanceSquared = d;
				dx = 0;
				dy = -1;
			}
		}

		// Check right cell
		if (enemy.dx != -1 && !engine.isWall(enemy.cellX + 1, enemy.cellY)) {
			const d = utils.getDistanceSquared(enemy.cellX + 1, enemy.cellY, targetX, targetY);
			if (d < minDistanceSquared) {
				minDistanceSquared = d;
				dx = 1;
				dy = 0;
			}
		}

		// Check down cell
		if (enemy.dy != -1 && !engine.isWall(enemy.cellX, enemy.cellY + 1)) {
			const d = utils.getDistanceSquared(enemy.cellX, enemy.cellY + 1, targetX, targetY);
			if (d < minDistanceSquared) {
				minDistanceSquared = d;
				dx = 0;
				dy = 1;
			}
		}

		// Check left cell
		if (enemy.dx != 1 && !engine.isWall(enemy.cellX - 1, enemy.cellY)) {
			const d = utils.getDistanceSquared(enemy.cellX - 1, enemy.cellY, targetX, targetY);
			if (d < minDistanceSquared) {
				minDistanceSquared = d;
				dx = -1;
				dy = 0;
			}
		}

		enemy.dx = dx;
		enemy.dy = dy;
		enemy.move();
	}

	function setEnemyBehavior(enemyBehavior) {
		pacmanGame.enemyBehavior = enemyBehavior;

		const interval = pacmanGame.enemyBehavior == pacmanGame.Chase ? gameConsts.getEnemyChaseDurationInterval() :
				gameConsts.getEnemyScatterDurationInterval();
		enemyBehaviorTimer.interval = interval[0] + Math.random() * (interval[1] - interval[0]);
	}

	onCompleted: {
		pacmanGame.init();
	}
}
