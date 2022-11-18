// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
	id: floatingTextItem;
	property string text;
	property Color color;
	property int maxWidth;
	property int floatingPeriod: 100;
	property bool maxWidthReached;
	property bool floating: false;
	property bool floatingNeeded;
	property int horizontalAlignment;

	height: innerText.height;
	color: colorTheme.activeTextColor;
	maxWidthReached: maxWidth > 0 && maxWidth < innerText.width;
	floatingNeeded: (floatingTextItem.width + 2) < innerText.paintedWidth;

	Behavior on color { animation: Animation { duration: 300; } }

	Item {
		anchors.fill: parent;
		anchors.topMargin: -10;
		anchors.bottomMargin: -10;
		clip: true;

		Text {
			id: innerText;
			anchors.verticalCenter: parent.verticalCenter;
			color: floatingTextItem.color;
			text: floatingTextItem.text; //TODO onTextChanged doesn't called for non-dynamic instances like Checkbox
			font: subheadFont;
			x: 0;

			Timer {
				id: movementTimer;
				interval: 1000;
				repeat: true;
				running: floatingTextItem.floating && floatingTextItem.floatingNeeded;

				onTriggered: {
					if (interval != 1000) {
						movementTimer.interval = 1000;
						floatingTextItem.reset();

						innerText.opacity = 0;
						opacityAnimation.complete();
						innerText.opacity = 1;
					} else {
						if (innerText.width > floatingTextItem.width) {
							innerText.x = -(innerText.width - floatingTextItem.width);
							movementTimer.interval = floatingTextItem.floatingPeriod + 1000;
						}
					}
				}
			}

			onWidthChanged: { floatingTextItem.reset(); }

			Behavior on opacity { animation: Animation { id: opacityAnimation; duration: 500; } }

			Behavior on x {
				animation: Animation {
					id: xAnamation;
					duration: floatingTextItem.floatingPeriod;
				}
			}
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
			innerText.x = -(innerText.width - this.width);
		}
	}

	onTextChanged:	{ this.preprocess(); }
	onWidthChanged:	{ this.preprocess(); }

	preprocess: {
		if (this.floating && innerText.width > floatingTextItem.width) {
			floatingTextItem.floatingPeriod = (innerText.width - floatingTextItem.width) * 20;
		}
	}

	reset: {
		var val = 0;
		switch (this.horizontalAlignment) {
		case this.AlignLeft: val = 0; break;
		case this.AlignRight: val = this.floatingNeeded ? 0 : (this.width - innerText.width); break;
		case this.AlignHCenter: val = this.floatingNeeded ? 0 : ((this.width - innerText.width) / 2); break;
		}
		innerText.x = val;
		xAnamation.complete();
	}

	updateWidth: {
		if (floatingTextItem.maxWidth <= 0)
			return;
		floatingTextItem.width = innerText.width > floatingTextItem.maxWidth ? floatingTextItem.maxWidth : innerText.width;
	}
}
