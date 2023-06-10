// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Delegate {
	width: parent.cellWidth;
	height: parent.cellHeight;

	clip: true;

	Rectangle {
		width: parent.width / 4;
		height: parent.height / 4;

		anchors.centerIn: parent;

		color: "#eee";
		radius: width / 2;

		visible: model.dot;
	}

	Rectangle {
		width: parent.width / 3;
		height: parent.height;

		anchors.top: parent.verticalCenter;
		anchors.horizontalCenter: parent.horizontalCenter;

		color: "#cc0";
		radius: width;

		visible: model.walls & 4;
	}

	Rectangle {
		width: parent.width / 3;
		height: parent.height;

		anchors.bottom: parent.verticalCenter;
		anchors.horizontalCenter: parent.horizontalCenter;

		color: "#cc0";
		radius: width;

		visible: model.walls & 1;
	}

	Rectangle {
		width: parent.width;
		height: parent.height / 3;

		anchors.verticalCenter: parent.verticalCenter;
		anchors.left: parent.horizontalCenter;

		color: "#cc0";
		radius: height;

		visible: model.walls & 2;
	}

	Rectangle {
		width: parent.width;
		height: parent.height / 3;

		anchors.verticalCenter: parent.verticalCenter;
		anchors.right: parent.horizontalCenter;

		color: "#cc0";
		radius: height;

		visible: model.walls & 8;
	}
}
