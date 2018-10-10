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

		width: model.disc == "White" ? 50 : 0;

		anchors.centerIn: parent;

		color: "#fff";
		borderColor: "#000";
	}

	ReversiDisc {
		id: black;

		width: model.disc == "Black" ? 50 : 0;

		anchors.centerIn: parent;

		color: "#000";
		borderColor: "#fff";
	}

	Cursor {
		visible: parent.activeFocus;
	}
}

