/*ReversiDisc : Rectangle {
	radius: 15;
	height: 50;
	borderWidth: 2;
	Behavior on width { animation: Animation { duration: 200; } }
}*/

ReversiCell : Rectangle {
	id: cellItem;
	disc: "Empty";

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
		width: cellItem.disc == "White" ? 50: 0;
	}

	ReversiDisc {
		id: black;
		color: "#000";
		borderColor: "#fff";
		anchors.centerIn: parent;
		width: cellItem.disc == "Black" ? 50: 0;
	}
}
