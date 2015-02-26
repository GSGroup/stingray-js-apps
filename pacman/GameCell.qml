Item {
	width: parent.cellWidth;
	height: parent.cellHeight;
	clip: true;

	Rectangle {
		width: parent.width / 4;
		height: parent.height / 4;
		color: "#eee";
		radius: width / 2;
		anchors.centerIn: parent;
		visible: model.dot;
	}

	Rectangle {
		radius: width;
		width: parent.width / 3;
		height: parent.height;
		anchors.top: parent.verticalCenter;
		anchors.horizontalCenter: parent.horizontalCenter;
		color: "#cc0";
		visible: model.walls & 4;
	}

	Rectangle {
		radius: width;
		width: parent.width / 3;
		height: parent.height;
		anchors.bottom: parent.verticalCenter;
		anchors.horizontalCenter: parent.horizontalCenter;
		color: "#cc0";
		visible: model.walls & 1;
	}

	Rectangle {
		radius: height;
		width: parent.width;
		height: parent.height / 3;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.left: parent.horizontalCenter;
		color: "#cc0";
		visible: model.walls & 2;
	}

	Rectangle {
		radius: height;
		width: parent.width;
		height: parent.height / 3;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.right: parent.horizontalCenter;
		color: "#cc0";
		visible: model.walls & 8;
	}
}
