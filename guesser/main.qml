import "Game.qml";

Application {
	id: guesserApp;

	displayName: tr("Угадыватель");

	Game {
		id: game;
	}

	onVisibleChanged: {
		if (visible)
			game.init();
	}
}
