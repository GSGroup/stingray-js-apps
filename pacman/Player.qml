import GameObject

Player : GameObject {
	id: playerItem;

	Rectangle {
		anchors.fill: parent;
		color: "#ee2";
		radius: width / 2;
	}

	//eye
	Rectangle {
		width: parent.width / 5;
		height: parent.height / 5;

		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.leftMargin: 3 * parent.width / 5 * (playerItem.faceLeft? -1: 1);
		anchors.top: parent.top;
		anchors.topMargin: height;
	}

	//mouth
	Rectangle {
		id: mouth;
		property bool opened;

		color: "#003";

		width: parent.width / 2;
		height: opened? parent.height / 4: 2;

		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.topMargin: parent.height / 2;

		anchors.leftMargin: (parent.width / 2 + 2) * (playerItem.faceLeft? -1: 1);

		Behavior on height { animation: Animation { duration: 100; } }
	}

	Timer {
		repeat: true;
		running: true;
		interval : 200;
		onTriggered: { mouth.opened = !mouth.opened; }
	}
}
