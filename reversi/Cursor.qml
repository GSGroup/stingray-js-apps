Rectangle {
	anchors.fill: parent;

	color: "#0000";
	borderWidth: 6;
   	borderColor: "#00ff00";
	radius: 5;

	Behavior on x { animation: Animation { duration: 200; } }
	Behavior on y { animation: Animation { duration: 200; } }
}

