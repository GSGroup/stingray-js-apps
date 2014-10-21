ScaleImage : Image {
	id: scaleImage;
	property int scale: 1;
	property int xPos;
	property int yPos;
	property int xOffset;
	xOffset: (paintedWidth - width) / 2;
	property int yOffset;
	yOffset: (paintedHeight - height) / 2;
	x: xPos + xOffset;
	y: yPos + yOffset;
	property int maxScale: 3;
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
			duration: scaleImage.descale ? 0 : scaleImage.duration;
		}
	}

	Behavior on width {
		animation: Animation {
			duration: scaleImage.descale ? 0 : scaleImage.duration;
			easingType: Animation.OutCirc;
		}
	}

	Behavior on height {
		animation: Animation {
			duration: scaleImage.descale ? 0 : scaleImage.duration;
			easingType: Animation.OutCirc;
		}
	}
}
