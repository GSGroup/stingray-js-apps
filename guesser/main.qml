import "Game.qml";

Application {
	id: guesserApp;

	displayName: qsTr("Угадыватель");

	Game {
		id: game;
	}

	onVisibleChanged: {
		if (visible)
			game.init();
	}
}
