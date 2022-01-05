Delegate {
	id: minigameDelegate;

	width: parent.cellWidth;
	height: parent.cellHeight;

	focus: true;

	Rectangle {
		anchors.fill: parent;
		borderWidth: 5;
		borderColor: minigameDelegate.activeFocus ? "#fff": "#222";
		color: model.fixed? "#0e0": "#e00";
	}
}
