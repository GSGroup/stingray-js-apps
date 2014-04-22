import controls.Text;

FloatingText : Item {
	id: floatingTextItem;
	property string text;
	property Color color;
	property int maxWidth;
	property int floatingPeriod: 100;
	property bool maxWidthReached;
	property bool floating: false;
	property bool floatingNeeded;
	property int horizontalAlignment: innerText.horizontalAlignment;

	height: innerText.height;
	color: colorTheme.activeTextColor;
	maxWidthReached: maxWidth > 0 && maxWidth < innerText.width;
	floatingNeeded: (floatingTextItem.width + 2) < innerText.paintedWidth;

	Item {
		anchors.fill: parent;
		anchors.topMargin: -10;
		anchors.bottomMargin: -10;
		clip: true;

		Text {
			id: innerText;
			property int initPosition;	// TODO: When ResetAnimation will be implemented, just use it instead this.
			anchors.verticalCenter: floatingTextItem.verticalCenter;
			initPosition: 0;
			text: floatingTextItem.text;
			color: floatingTextItem.color;
			font: mainFont;
			x: 0;

			Timer {
				id: movementTimer;
				interval: 1000;
				repeat: true;
				running: floatingTextItem.floating && floatingTextItem.floatingNeeded;

				onTriggered: {
					if (movementTimer.interval != 1000) {
						movementTimer.interval = 1000;
						floatingTextItem.reset();

						innerText.opacity = 0;
						innerText.opacity = 1;
					} else {
						if (innerText.width > floatingTextItem.width && innerText.x == innerText.initPosition) {
							innerText.x = -(innerText.width - floatingTextItem.width);
							movementTimer.interval = floatingTextItem.floatingPeriod + 1000;
						}
					}
				}
			}

			Behavior on x { animation: Animation { duration: floatingTextItem.floatingPeriod; } }
			Behavior on opacity { animation: Animation { duration: 500; } }

			onWidthChanged: { floatingTextItem.updateWidth(); }
		}
	}

	onMaxWidthChanged: { this.updateWidth(); }
	onHorizontalAlignmentChanged: { this.reset(); }

	onFloatingNeededChanged: {
		if (!this.floatingNeeded) {
			this.reset();
		}
	}

	onFloatingChanged: {
		if (!floatingTextItem.floating) {
			this.reset();
		} else if (innerText.width > floatingTextItem.width) {
			floatingTextItem.floatingPeriod = (innerText.width - floatingTextItem.width) * 20;
		}
	}

	onTextChanged: {
		if (this.floating && innerText.width > floatingTextItem.width) {
			floatingTextItem.floatingPeriod = (innerText.width - floatingTextItem.width) * 20;
		}
	}

	reset: {
		var val = 0;
		switch (this.horizontalAlignment) {
		case Text.AlignLeft: val = 0; break;
		case Text.AlignRight: val = this.floatingNeeded ? 0 : (this.width - innerText.width); break;
		case Text.AlignHCenter: val = this.floatingNeeded ? 0 : ((this.width - innerText.width) / 2); break;
		}
		innerText.initPosition = val;
		innerText.x = val;
		movementTimer.interval = 1000;
	}

	start: { floating = true; }
	stop: { floating = false; }

	updateWidth: {
		if (floatingTextItem.maxWidth <= 0) {
			return;
		}

		floatingTextItem.width = innerText.width > floatingTextItem.maxWidth ? floatingTextItem.maxWidth : innerText.width;
	}
}
