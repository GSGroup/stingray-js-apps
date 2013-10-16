Line : Item {
	id: lineItem;
	height: 2;

	//property Color firstColor: "#1C1C1C";
	property Color firstColor: "#353535";
	property Color secondColor: "#4F4F4F";

	Rectangle {
		anchors.left: parent.left;
		anchors.right: parent.right;
		height: 1;
		color: lineItem.firstColor;
	}

	Rectangle {
		anchors.left: parent.left;
		anchors.right: parent.right;
		height: 1;
		y: 1;
		color: lineItem.secondColor;
	}
}
