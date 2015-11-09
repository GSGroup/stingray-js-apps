Item {
	id: cardProto;
	property string resPath: "apps/guesser/res/";
	property string shirt: resPath + "shirt4.png";
	property string cardNumber;
	property int number;
	property bool show: false;
	property int minWidth: 80;
	signal xDone;
	width: minWidth;
	height: 120;

	Rectangle {
		width: image.width;
		height: parent.height;
		anchors.top: image.top;
		anchors.left: image.left;
		anchors.margins: 5;
		radius: 15;
		color: "#0003";
	}

	Image {
		id: image;
		property bool show: false;
		width: cardProto.minWidth;
		height: parent.height;
		anchors.horizontalCenter: parent.horizontalCenter;
		source: show ? "apps/guesser/res/" + cardProto.cardNumber + ".png" : cardProto.shirt;
		fillMode: Image.Stretch;

		onShowChanged: { this.width = 80; }

		Behavior on width {
			animation: Animation {
				duration: 300;

				onRunningChanged: {
				if (!this.running)
					image.show = cardProto.show
				}
			}
		}
	}

	onShowChanged: { image.width = 0; }

	Behavior on y { animation: Animation { duration: 700; } }

	Behavior on x {
		animation: Animation {
			duration: 700;

			onRunningChanged: {
				if (!this.running)
					cardProto.xDone()
			}
		}
	}
}
