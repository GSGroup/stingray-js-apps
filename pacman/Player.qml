// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "GameObject.qml";

GameObject {
	id: playerProto;

	property bool animated;

	Rectangle {
		anchors.fill: parent;

		color: "#FFFB00";
		radius: width / 2;
	}

	Rectangle {
		width: parent.width / 5;
		height: parent.height / 5;

		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.leftMargin: 3 * parent.width / 5 * (playerProto.faceLeft ? -1 : 1);
		anchors.top: parent.top;
		anchors.topMargin: height;
	}

	Rectangle {
		id: mouth;

		property bool opened;

		width: parent.width / 2;
		height: opened ? parent.height / 2 : 0;

		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.topMargin: parent.height / 2;

		anchors.leftMargin: (parent.width / 2 + 2hpw) * (playerProto.faceLeft ? -1 : 1);

		radius: width / 3;

		Behavior on height { animation: Animation { duration: 100; } }
	}

	Timer {
		repeat: true;
		running: playerProto.animated && (playerProto.dx || playerProto.dy);
		interval: 150;

		onTriggered: { mouth.opened = !mouth.opened; }

		onRunningChanged: {
			if (!running)
				mouth.opened = false;
		}
	}
}
