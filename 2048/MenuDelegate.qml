// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Delegate {
	width: parent.cellWidth;
	height: parent.cellHeight;

	anchors.horizontalCenter: parent.horizontalCenter;

	focus: true;

	Rectangle {
		width: parent.width;
		height: parent.height / 2;

		anchors.centerIn: parent;

		color: parent.activeFocus ? "#835a22ff" : "#734a12aa";
		radius: 10;

		Text {
			anchors.centerIn: parent;

			font: titleFont;
			color: "#ffffff";
			text: model.text;
		}
	}
}
