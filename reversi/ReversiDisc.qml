Rectangle {
	radius: 15;
	height: parent.height - 15;
	borderWidth: 2;
	Behavior on width { animation: Animation { duration: 200; } }
}
