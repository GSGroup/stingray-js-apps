GameObject : Item {
	property int cellX;
	property int cellY;
	property int speed;
	property bool faceLeft;

	z: 1;

	x: width * cellX;
	y: height * cellY;

	Behavior on x { animation: Animation { duration: playerItem.speed; } }
	Behavior on y { animation: Animation { duration: playerItem.speed; } }
}
