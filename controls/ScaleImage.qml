ScaleImage : Image {
	id: scaleImage;
	property real scale: 1;
	property real maxScale: 2.5;
	property int xPos;
	property int yPos;
	property int xOffset;
	xOffset: (paintedWidth - width) / 2;
	property int yOffset;
	yOffset: (paintedHeight - height) / 2;
	x: xPos + xOffset;
	y: yPos + yOffset;
	property bool descale;
	property int duration: 400;
	fillMode: Image.Stretch;
	width: paintedWidth * scale;
	height: paintedHeight * scale;

	function doScale() {
		this.scaleImage.visible = true;
		this.descale = false;
		this.scale = this.maxScale;
		this.opacity = 0;
		descaleTimer.start();
	}

	Timer {
		id: descaleTimer;
		interval: scaleImage.duration;

		onTriggered: {
			scaleImage.descale = true;
			scaleImage.scale = 1;
			scaleImage.opacity = 1;
			scaleImage.visible = false;
		}
	}

	Behavior on opacity {
		animation: Animation {
			duration: scaleImage.descale ? 0 : 500;
		}
	}

	Behavior on scale {
		animation: Animation {
			duration: scaleImage.descale ? 0 : scaleImage.duration;
			easingType: Animation.OutCirc;
		}
	}
}
