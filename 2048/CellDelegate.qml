Rectangle {
	id: rect;
	height: parent.cellHeight;
	width: parent.cellWidth;
	property int value: -1;
	property int added: false;
	Behavior on x { animation: Animation { duration: rect.value < 2 ? 0 : 500; } }
	Behavior on y { animation: Animation { duration: rect.value < 2 ? 0 : 500; } }
	z: value ? 1 : 0;

	Rectangle {
		id: innerRect;
		radius: 10;
		anchors.fill: parent;
		anchors.margins: 10;
		Behavior on color { animation: Animation { duration: 150; } }
		
		Text {
			text: rect.value ? rect.value : "";	
			anchors.centerIn: parent;
			color: rect.value <= 4 ? "#6D654E" : "#ffffff";
			font: bigFont;
		}
	} 

	Timer {
		id: scaleTimer;
		interval: 150;
		onTriggered: {
			innerRect.anchors.margins = 10;
		}
	}

	function doscale () {
		innerRect.anchors.margins = 0;
		scaleTimer.restart();
	}

	onValueChanged: {
		if (rect.value && rect.added) this.doscale();
		switch (rect.value) {
		case 0: innerRect.color =  "#ccc0b2"; break; 
		case 2: innerRect.color = "#eee4da"; break;
		case 4: innerRect.color = "#ECE0CA"; break;
		case 8: innerRect.color = "#EEB57E"; break;
		case 16: innerRect.color = "#F39562"; break;
		case 32: innerRect.color = "#FD7D60"; break;
		case 64: innerRect.color = "#F55837"; break;
		case 128: innerRect.color = "#F4CA78"; break;
		case 256: innerRect.color = "#EDCA6C"; break;
		case 512: innerRect.color = "#EFCA45"; break;
		case 1024: innerRect.color = "#F0C63C"; break;
		case 2048: innerRect.color = "#F0C129"; break;
		default: innerRect.color = "#000000"; 
		}
	}
	color: "#bcb0a200";
}
