// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

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
			font: titleFont;
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
