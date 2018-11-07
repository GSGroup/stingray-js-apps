import "Game.qml";

Application {
	id: gameScreen;
	displayName: tr("PACMAN");

	Game {
		width: parent.height;
		height: width;
		anchors.centerIn: parent;
	}
}
