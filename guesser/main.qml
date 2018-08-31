import "Game.qml";

Application {
	id: guesserApp;
	displayName: qsTr("Угадыватель");

	Game { id: game; }

	onStarted: {
		game.init();
	}
}
