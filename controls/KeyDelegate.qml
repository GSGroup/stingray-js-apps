import controls.MainText

Rectangle {
	id: keyDelegate;
	width: parent.cellWidth;
	height: width;
	color: "#00000000";

	MainText {
//		anchors.margins: 5;
		anchors.centerIn: parent;
		text: model.letter;
	}
}
