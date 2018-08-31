import "Cursor.qml";
import "ReversiDisc.qml";

Rectangle {
	width: parent.cellHeight;
	height: parent.cellWidth;

	color: "#151";
	borderColor: "#432100";
	borderWidth: 1;
	
	ReversiDisc {
		id: white;
		color: "#fff";
		borderColor: "#000";
		anchors.centerIn: parent;
		width: model.disc == "White" ? 50: 0;
	}

	ReversiDisc {
		id: black;
		color: "#000";
		borderColor: "#fff";
		anchors.centerIn: parent;
		width: model.disc == "Black" ? 50: 0;
	}
	Cursor {
		visible: parent.activeFocus ? true: false;
	}
}

