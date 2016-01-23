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
