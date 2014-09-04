Player : Item {
	id: playerItem;

	property int cellX;
	property int cellY;
	property int speed;
	property bool faceLeft;

	x: width * cellX;
	y: height * cellY;

	Behavior on x { animation: Animation { duration: playerItem.speed; } }
	Behavior on y { animation: Animation { duration: playerItem.speed; } }

	Rectangle {
		anchors.fill: parent;
		color: "#ee2";
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
