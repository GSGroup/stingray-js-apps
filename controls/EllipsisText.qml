// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
	id: ellipsisTextProto;
	property alias paintedWidth: innerText.paintedWidth;
	property alias paintedHeight: innerText.paintedHeight;
	property Color color;
	property variant font;
	property string text;
	property bool showEllipsis: innerText.paintedWidth + ellipsisText.paintedWidth > width;
	height: innerText.paintedHeight;

	Text {
		id: innerText;
		text: ellipsisTextProto.text;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.rightMargin: ellipsisText.visible ? ellipsisText.paintedWidth : 0;
		clip: ellipsisTextProto.showEllipsis;
		font: parent.font;
		color: parent.color;
	}

	Text {
		id: ellipsisText;
		anchors.bottom: innerText.bottom;
		anchors.left: innerText.right;
		visible: innerText.text != ellipsisTextProto.text;
		font: parent.font;
		color: innerText.color;
		text: "...";
	}

	onWidthChanged:			{ innerText.text = text; this.update(); }
	onShowEllipsisChanged:	{ this.update(); }

	onTextChanged: {
		innerText.text = text;
		this.update();
	}

	update: {
		if (!this.showEllipsis || !innerText.text.length || !this.width)
			return;

		while (innerText.paintedWidth + ellipsisText.paintedWidth > width && innerText.text.length)
			innerText.text = innerText.text.substr(0, innerText.text.length - 1);
	}
}
