Rectangle {
	width: parent.cellWidth;
	height: parent.cellHeight;

	focus: true;

	borderWidth: 5;
	borderColor: activeFocus? "#fff": "#222";
	color: model.fixed? "#0e0": "#e00";
}
