import GameObject

Enemy : GameObject {
	id: ghost;
	property Color color;
	property bool step;

	Rectangle {
		anchors.fill: parent;
		color: parent.color;
	}

	Rectangle {
		width: parent.width / 5;
		height: width;
		anchors.bottom: parent.bottom;
		color: "#003";
		x: (parent.step? 1: 0) + width;
	}

	Rectangle {
		width: parent.width / 5;
		height: width;
		x: (parent.step? 1: 0) + width * 3;
		anchors.bottom: parent.bottom;
		color: "#003";
	}

	//eyes
	Rectangle {
		x: parent.faceLeft? parent.width / 10: 7 * parent.width / 10;
		y: parent.width / 5;
		color: "#fff";
		width: parent.width / 5;
		height: width;
	}

	Rectangle {
		x: parent.faceLeft? 5 * parent.width / 10: 3 * parent.width / 10;
		y: parent.width / 5;
		color: "#fff";
		width: parent.width / 5;
		height: width;
	}

	Timer {
		repeat: true;
		running: true;
		interval : 200;
		onTriggered: { ghost.step = !ghost.step; }
	}
}
