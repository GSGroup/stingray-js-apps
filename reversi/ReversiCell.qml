import "ReversiDisc.qml";

ReversiCell : Rectangle {
	id: cellItem;
	property enum { Empty, Black, White } disc: Empty;

	width: 65;
	height: 65;

	color: "#151";
	borderColor: "#432100";
	borderWidth: 1;

	ReversiDisc {
		id: white;
		color: "#fff";
		borderColor: "#000";
		anchors.centerIn: parent;
		width: cellItem.disc == ReversiCell::Disc::White? 50: 0;
	}

	ReversiDisc {
		id: black;
		color: "#000";
		borderColor: "#fff";
		anchors.centerIn: parent;
		width: cellItem.disc == ReversiCell::Disc::Black? 50: 0;
	}
}

