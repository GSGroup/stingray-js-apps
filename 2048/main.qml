import Game;

Application {
	id: g2048;
	name: "2048";
	displayname: "2048";
	focus: true;
	Rectangle {
	anchors.fill: parent;
	color: colorTheme.backgroundColor;
	Game {}
	}
}

