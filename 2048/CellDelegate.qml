Rectangle {
	id: rect;

	property int value: -1;
	property int added: false;

	height: parent.cellHeight;
	width: parent.cellWidth;

	color: "#bcb0a200";
	z: value ? 1 : 0;

	Behavior on x { animation: Animation { duration: rect.value < 2 ? 0 : 500; } }
	Behavior on y { animation: Animation { duration: rect.value < 2 ? 0 : 500; } }


	Rectangle {
		id: innerRect;

		anchors.fill: parent;
		anchors.margins: 10;

		radius: 10;
		color: rect.value == 0 ? "#ccc0b2" :
			rect.value == 2 ? "#eee4da" :
			rect.value == 4 ? "#ece0ca" :
			rect.value == 8 ? "#eeb57e" :
			rect.value == 16 ? "#f39562" :
			rect.value == 32 ? "#fd7d60" :
			rect.value == 64 ? "#f55837" :
			rect.value == 128 ? "#f4ca78" :
			rect.value == 256 ? "#edca6c" :
			rect.value == 512 ? "#efca45" :
			rect.value == 1024 ? "#f0c63c" :
			rect.value == 2048 ? "#f0c129" :
			"#000000";

		Behavior on color { animation: Animation { duration: 150; } }
		
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
