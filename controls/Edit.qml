// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "BaseEdit.qml";

BaseEdit {
	id: editItem;

	property string hint;
	property variant font: subheadFont;

	property Color textColor: colorTheme.activeTextColor;
	property Color borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
	property Color color: activeFocus ? colorTheme.activeFocusColor : editItem.backgroundColor;

	property int lineAnimationDuration: 300;

	property string mask: "*";
	property bool showBackground: true;
	property bool alwaysShowCursor;
	property bool passwordMode;
	property int borderWidth: 2;
	property int radius: colorTheme.rounded ? 8 : 0;
	property bool showUnderLining: !showBackground;

	width: 100;
	height: 40;

	clip: true;
	focus: true;

	Rectangle {
		id: borderRect;

		anchors.fill: parent;

		borderWidth: parent.borderWidth;
		radius: parent.radius;
		color: colorTheme.globalBackgroundColor;
		borderColor: parent.borderColor;

		visible: editItem.showBackground;

		Behavior on borderColor { animation: Animation { duration: 200; } }
	}

	Rectangle {
		height: 3;

		anchors.bottom: parent.bottom;
		anchors.left: parent.left;
		anchors.right: parent.right;

		color: colorTheme.activeTextColor;

		opacity: editItem.showUnderLining && parent.activeFocus ? 1 : 0;

		Behavior on opacity { animation: Animation { duration: editItem.lineAnimationDuration; } }
	}

	SubheadText {
		id: editText;

		anchors.fill: parent;

		verticalAlignment: ui.Text.AlignVCenter;
		horizontalAlignment: ui.Text.AlignHCenter;

		font: editItem.font;
		color: editItem.textColor;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}

	SubheadText {
		id: hintText;

		anchors.bottom: borderRect.bottom;
		anchors.horizontalCenter: borderRect.horizontalCenter;

		color: colorTheme.textColor;
		text: editItem.hint;
		font: editItem.font;

		opacity: editText.text == "" ? 0.6 : 0;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}

	Rectangle {
		id: cursorRect;

		width: 2;

		anchors.top: parent.top;
		anchors.bottom: parent.bottom;
		anchors.left: editText.right;
		anchors.margins: 7;
		anchors.leftMargin: 2;

		color: editText.color;

		visible: false;
		opacity: borderRect.opacity;

		Behavior on color { animation: Animation { duration: 200; } }
	}

	Timer {
		id: cursorBlinkTimer;

		interval: 500;
		repeat: true;
		running: cursorRect.visible;

		onTriggered: { cursorRect.visible = !cursorRect.visible; }
	}

	onTextChanged: { editItem.updateText(); }

	onActiveFocusChanged: { cursorRect.visible = activeFocus || alwaysShowCursor;}

	function updateText() {
		var line = editItem.text;
		if (editItem.maxLen > 0)
			line = line.substr(0, editItem.maxLen);

		if (!editItem.passwordMode)
			editText.text = line;
		else
			editText.text = new Array(line.length + 1).join(mask);
	}

	onCompleted: { editItem.updateText(); }
}
