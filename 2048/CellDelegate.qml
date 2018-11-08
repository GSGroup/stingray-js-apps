Rectangle {
	id: rect;

	property int value: -1;
	property int added: false;

	height: parent.cellHeight;
	width: parent.cellWidth;

	color: "#bcb0a200";
	z: value ? 1 : 0;

	Behavior on x { animation: Animation { duration: rect.value < 2 ? 0 : 450; } }
	Behavior on y { animation: Animation { duration: rect.value < 2 ? 0 : 450; } }


	Rectangle {
		id: innerRect;

		anchors.fill: parent;
		anchors.margins: 10;

		radius: 10;
		color: rect.value == 0 ? "#ccc0b2" :
			rect.value == 2 ? "#eee4da" :
			rect.value == 4 ? "#ede0c8" :
			rect.value == 8 ? "#f2b179" :
			rect.value == 16 ? "#f59563" :
			rect.value == 32 ? "#f67c5f" :
			rect.value == 64 ? "#f65e3b" :
			rect.value == 128 ? "#eedc9d" :
			rect.value == 256 ? "#c4ce78" :
			rect.value == 512 ? "#a6bf4d" :
			rect.value == 1024 ? "#83af1b" :
			rect.value == 2048 ? "#628316" :
			"#000000";

		Behavior on color { animation: Animation { duration: 100; } }
		
		Text {
			anchors.centerIn: parent;

			text: rect.value ? rect.value : "";
			color: rect.value <= 4 ? "#6D654E" : "#ffffff";
			font: bigFont;
		}
	} 

	Timer {
		id: scaleTimer;

		interval: 150;

		onTriggered: { innerRect.anchors.margins = 10; }
	}

	function doscale () {
		innerRect.anchors.margins = 0;
		scaleTimer.restart();
	}
}
