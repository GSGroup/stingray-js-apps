import Game;

Application {
	id: gameScreen;
	displayName: qsTr("PACMAN");

	Game {
		width: parent.height;
		height: width;
		anchors.centerIn: parent;
	}
}
