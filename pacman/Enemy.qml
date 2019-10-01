// Copyright (c) 2011 - 2019, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "GameObject.qml";

GameObject {
	id: ghost;
	property Color color;
	property bool step;

	Rectangle {
		anchors.fill: parent;
		color: parent.color;
	}

	Rectangle {
		width: parent.width / 5;
		height: width;
		anchors.bottom: parent.bottom;
		color: "#003";
		x: (parent.step? 1: 0) + width;
	}

	Rectangle {
		width: parent.width / 5;
		height: width;
		x: (parent.step? 1: 0) + width * 3;
		anchors.bottom: parent.bottom;
		color: "#003";
	}

	//eyes
	Rectangle {
		x: parent.faceLeft? parent.width / 10: 7 * parent.width / 10;
		y: parent.width / 5;
		color: "#fff";
		width: parent.width / 5;
		height: width;
	}

	Rectangle {
		x: parent.faceLeft? 5 * parent.width / 10: 3 * parent.width / 10;
		y: parent.width / 5;
		color: "#fff";
		width: parent.width / 5;
		height: width;
	}

	Timer {
		repeat: true;
		running: true;
		interval : 200;
		onTriggered: { ghost.step = !ghost.step; }
	}
}
