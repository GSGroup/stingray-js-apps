Rectangle {
	id: rect;

	property int value: 0;
	property int addedValue: 0;
	property bool added;
	property bool joined;
	property bool win: rect.value == 2048;

	height: parent.cellHeight;
	width: parent.cellWidth;

	color: "#bcb0a200";
	z: value;

	Behavior on x {
		animation: Animation {
			duration: rect.value < 2 ? 0 : 400;

			onRunningChanged: {
				if (!running && rect.joined)
				{
					rect.value *= 2;
					rect.joined = false;
				}
			}
		}
	}

	Behavior on y { animation: Animation { duration: rect.value < 2 ? 0 : 400; } }

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

		interval: 100;

		onTriggered: { innerRect.anchors.margins = 10; }
	}

	Timer {
		id: addTimer;

		interval: 300;

		onTriggered: {
			rect.value = rect.addedValue;
			rect.addedValue = 0;
			rect.added = false;
		}
	}

	onValueChanged: {
		if (rect.value && rect.added)
			this.doscale();
	}

	onAddedChanged: {
		if (added)
			addTimer.restart();
	}

	function doscale () {
		innerRect.anchors.margins = 0;
		scaleTimer.restart();
	}
}
