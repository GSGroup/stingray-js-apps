Item {
	id: smoothImageItem;
	property string source;
	property string previousSource;
	property bool inversed;
	property int duration: 500;
	// don't forget to set known width & height

	Image {
		id: firstImage;
		anchors.fill: parent;
		opacity: smoothImageItem.inversed ? 1 : 0;

		Behavior on opacity {
			animation: Animation {
				duration: 500;
			}
		}
	}

	Image {
		id: secondImage;
		anchors.fill: parent;
		opacity: smoothImageItem.inversed ? 0 : 1;

		Behavior on opacity {
			animation: Animation {
				duration: 500;
			}
		}
	}

	onSourceChanged: {
		log("source changed to " + smoothImageItem.source);
		smoothImageItem.updateSource();
	}

	function updateSource() {
		if (smoothImageItem.previousSource === smoothImageItem.source)
			return;

		smoothImageItem.previousSource = smoothImageItem.source;
		smoothImageItem.inversed = !smoothImageItem.inversed;

		if (smoothImageItem.inversed)
			firstImage.source = smoothImageItem.source;
		else
			secondImage.source = smoothImageItem.source;
	}

	onCompleted: {
		smoothImageItem.updateSource();
	}
}
