Player : Item {

	property int cellX;
	property int cellY;

	x: width * cellX;
	y: height * cellY;

	Rectangle {
		anchors.fill: parent;
		color: "#ee2";
	}

	Rectangle {
		width: parent.width / 5;
		height: parent.height / 5;

		anchors.right: parent.right;
		anchors.top: parent.top;
		anchors.topMargin: height;
		anchors.rightMargin: width;
	}

	Rectangle {
		id: mouth;
		property bool opened;

		color: "#003";

		width: parent.width / 2;
		height: opened? parent.height / 4: 2;

		anchors.right: parent.right;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.topMargin: parent.height / 2;

		Behavior on height { animation: Animation { duration: 100; } }
	}

	Timer {
		repeat: true;
		running: true;
		interval : 200;
		onTriggered: { mouth.opened = !mouth.opened; }
	}
}
