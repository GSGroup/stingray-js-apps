import "Game.qml";

Application {
	id: g2048;

	name: "2048";
	displayname: "2048";
	focus: true;

	Rectangle {
		anchors.fill: parent;

		focus: true;

		color: colorTheme.backgroundColor;

		Game {
			focus: true;
		}
	}
}

