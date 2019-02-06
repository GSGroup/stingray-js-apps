import "Game.qml";

Application {
	id: gTetris;

	name: "tetris";
	displayname: "Tetris";

	Game {
		id: tetris;
		appName: gTetris.name;
	}
	// TODO: should be replaced by onStopped() to handle the situation when box is powered off on timer
	// signal stopped() could not be found by successor yet
	onVisibleChanged: {
		if (!gTetris.visible)
		{
			tetris.resetGame();
		}
	}
}
