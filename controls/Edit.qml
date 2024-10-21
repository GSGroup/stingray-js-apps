// © "Сifra" LLC, 2011-2024
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
	property Color backgroundColor: colorTheme.focusablePanelColor;

	property Color color: activeFocus ? colorTheme.activeFocusColor : editItem.backgroundColor;

	property int lineAnimationDuration: 300;
	property int hintAnimationDuration: 300;

	property string mask: "*";
	property bool showBackground: true;
	property bool passwordMode;
	property bool activeShowCursor;
	property bool alwaysShowCursor;
	property bool showUnderLining: !showBackground;

	property alias horizontalAlignment: editText.horizontalAlignment;
	property alias paintedWidth: editText.paintedWidth;

	property bool isCursorActivated: (editText.text != "") && (alwaysShowCursor || (activeShowCursor && activeFocus));

	width: 100hpw;
	height: 40hph;

	Panel {
		id: bgRect;

		anchors.fill: parent;

		color: editItem.color;

		visible: editItem.showBackground;
	}

	Rectangle {
		height: 3hph;

		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.bottom: parent.bottom;

		color: colorTheme.highlightPanelColor;

		opacity: editItem.showUnderLining && parent.activeFocus ? 1 : 0;

		Behavior on opacity { animation: Animation { duration: editItem.lineAnimationDuration; } }
	}

	Text {
		id: editText;

		anchors.left: bgRect.left;
		anchors.right: bgRect.right;
		anchors.rightMargin: editItem.isCursorActivated ? 6hpw : 0;
		anchors.verticalCenter: bgRect.verticalCenter;

		horizontalAlignment: ui.Text.HorizontalAlignment.AlignHCenter;

		font: editItem.font;
		color: parent.activeFocus ? colorTheme.focusedTextColor : editItem.textColor;

		Behavior on opacity { animation: Animation { duration: 300; } }
		Behavior on color { animation: Animation { duration: 200; } }

		onTextChanged: { editItem.restartCursorBlinkTimer(); }
	}

	Text {
		id: hintText;

		anchors.centerIn: bgRect;

		text: editItem.hint;
		font: editItem.font;
		color: parent.activeFocus ? colorTheme.focusedTextColor : editItem.textColor;

		opacity: editText.text == "" ? 0.6 : 0;

		Behavior on opacity { animation: Animation { duration: editItem.hintAnimationDuration; } }
	}

	Rectangle {
		id: cursorRect;

		width: 2hpw;
		height: 30hph;

		anchors.right: editText.right;
		anchors.rightMargin: -2hpw - cursorRect.width
				+ (editText.horizontalAlignment == editText.AlignRight ? 0 :
						editText.horizontalAlignment == editText.AlignLeft ? editText.width - editText.paintedWidth :
								(editText.width - editText.paintedWidth) / 2);
		anchors.verticalCenter: bgRect.verticalCenter;

		color: editText.color;

		visible: false;
		opacity: 0.3;

		Behavior on color { animation: Animation { duration: 200; } }
	}

	Timer {
		id: cursorBlinkTimer;

		interval: 500;
		repeat: true;
		triggeredOnStart: true;

		onTriggered: { cursorRect.visible = !cursorRect.visible; }
	}

	onTextChanged: { editItem.updateText(); }

	onIsCursorActivatedChanged: { editItem.restartCursorBlinkTimer(); }

	function updateText() {
		var line = editItem.text;
		if (editItem.maxLen > 0)
			line = line.substr(0, editItem.maxLen);

		if (!editItem.passwordMode)
			editText.text = line;
		else
			editText.text = new Array(line.length + 1).join(mask);
	}

	function restartCursorBlinkTimer() {
		cursorBlinkTimer.stop();
		cursorRect.visible = false;

		if (editItem.isCursorActivated)
			cursorBlinkTimer.start();
	}

	onCompleted: { editItem.updateText(); }
}
