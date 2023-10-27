// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "GameObject.qml";

GameObject {
	id: enemyProto;

	property Color color;
	property bool step;

	Rectangle {
		anchors.fill: parent;

		color: parent.color;
	}

	Rectangle {
		x: (parent.step ? 1hpw : 0) + width;

		width: parent.width / 5;
		height: parent.height / 5;

		anchors.bottom: parent.bottom;
	}

	Rectangle {
		x: (parent.step ? 1hpw : 0) + width * 3;

		width: parent.width / 5;
		height: parent.height / 5;

		anchors.bottom: parent.bottom;
	}

	// Eyes
	Rectangle {
		x: parent.faceLeft ? parent.width / 10 : 7 * parent.width / 10;
		y: parent.height / 5;

		width: parent.width / 5;
		height: parent.height / 5;

		color: "#FFF";
	}

	Rectangle {
		x: parent.faceLeft ? 5 * parent.width / 10 : 3 * parent.width / 10;
		y: parent.height / 5;

		width: parent.width / 5;
		height: parent.height / 5;

		color: "#FFF";
	}

	Timer {
		repeat: true;
		running: true;
		interval: 200;
		onTriggered: { enemyProto.step = !enemyProto.step; }
	}
}
