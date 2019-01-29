import "Game.qml";

Application {
	id: gTetris;

	name: "tetris";
	displayname: "Tetris";

	Game {
		id: tetris;
		appName: gTetris.name;
	}

	onStopped: { tetris.resetGame(); }
}
