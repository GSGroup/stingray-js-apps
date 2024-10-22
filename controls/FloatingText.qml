// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
	id: floatingTextProto;

	property string text;

	property Color color: colorTheme.activeTextColor;
	property bool colorAnimable: true;

	property bool floating: false;
	property int floatingPeriod: 100;
	property bool floatingNeeded: (floatingTextProto.width + 2) < innerText.paintedWidth;

	property enum { AlignLeft, AlignRight, AlignHCenter } horizontalAlignment: AlignLeft;

	height: innerText.height;

	Behavior on color { animation: Animation { duration: floatingTextProto.colorAnimable ? 300 : 0; } }

	Item {
		anchors.topMargin: -10hph;
		anchors.bottomMargin: -10hph;
		anchors.fill: parent;

		clip: true;

		Text {
			id: innerText;

			x: 0;

			anchors.verticalCenter: parent.verticalCenter;

			color: floatingTextProto.color;
			font: subheadFont;
			text: floatingTextProto.text; //TODO onTextChanged doesn't called for non-dynamic instances like Checkbox

			Timer {
				id: movementTimer;

				interval: 1000;
				repeat: true;
				running: floatingTextProto.floating && floatingTextProto.floatingNeeded;

				onTriggered: {
					if (interval != 1000)
					{
						movementTimer.interval = 1000;
						floatingTextProto.reset();

						innerText.opacity = 0;
						opacityAnimation.complete();
						innerText.opacity = 1;
					}
					else if (innerText.width > floatingTextProto.width)
					{
						innerText.x = -(innerText.width - floatingTextProto.width);
						movementTimer.interval = floatingTextProto.floatingPeriod + 1000;
					}
				}
			}

			onWidthChanged: { floatingTextProto.reset(); }

			Behavior on opacity { animation: Animation { id: opacityAnimation; duration: 500; } }
			Behavior on x {	animation: Animation { id: xAnimation; duration: floatingTextProto.floatingPeriod; } }
		}
	}

	onFloatingNeededChanged: {
		if (!floatingTextProto.floatingNeeded)
			floatingTextProto.reset();
	}

	onFloatingChanged: {
		if (!floatingTextProto.floating)
			floatingTextProto.reset();
		else if (innerText.width > floatingTextProto.width)
		{
			floatingTextProto.floatingPeriod = (innerText.width - floatingTextProto.width) * 20;
			innerText.x = -(innerText.width - this.width);
		}
	}

	onHorizontalAlignmentChanged: { floatingTextProto.reset(); }

	onTextChanged:	{ floatingTextProto.preprocess(); }
	onWidthChanged:	{ floatingTextProto.preprocess(); }

	preprocess: {
		innerText.text = floatingTextProto.text.replaceAll("\n", " ");

		floatingTextProto.reset();
		if (floatingTextProto.floating && innerText.width > floatingTextProto.width)
			floatingTextProto.floatingPeriod = (innerText.width - floatingTextProto.width) * 20;
	}

	reset: {
		switch (floatingTextProto.horizontalAlignment)
		{
		case floatingTextProto.AlignLeft:
			innerText.x = 0;
			break;
		case floatingTextProto.AlignRight:
			innerText.x = floatingTextProto.floatingNeeded ? 0 : (floatingTextProto.width - innerText.width);
			break;
		case floatingTextProto.AlignHCenter:
			innerText.x = floatingTextProto.floatingNeeded ? 0 : ((floatingTextProto.width - innerText.width) / 2);
			break;
		}

		xAnimation.complete();
		movementTimer.interval = 1000;
	}

	onCompleted: { floatingTextProto.preprocess(); }
}
