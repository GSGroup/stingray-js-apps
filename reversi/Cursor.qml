Rectangle {
	color: "#0000";
	anchors.fill: parent;
	borderWidth: 6;
//TODO: for black
   // borderColor: playerWhite ? "#ffffff" : "#000000";
   	borderColor: "#00ff00";
	radius: 5;
	Behavior on x { animation: Animation { duration: 200; } }
	Behavior on y { animation: Animation { duration: 200; } }
}

