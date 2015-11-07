import Game;

Application {
	id: guesserApp;
	displayName: qsTr("Угадыватель");

	Game { id: game; }

	onStarted: {
		game.init();
	}
}
