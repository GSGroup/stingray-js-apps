import "Game.qml";

Application {
	id: gTetris;

	name: "tetris";
	displayname: "tetris";

	focus: true;

	Rectangle {
		anchors.fill: parent;

		color: colorTheme.backgroundColor;

		focus: true;

		Game {
			focus:true;
		}
	}
}
