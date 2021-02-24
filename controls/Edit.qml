// Copyright (c) 2011 - 2019, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
	id: editItem;

	signal maxLenReached;
	signal invalidKeyEntered(std::string key);

	property bool showBackground: true;
	property string text;
	property int maxLen;
	property bool clearAfterMaxlenReached: true;
	property string ignoreChars: "#*";
	property string mask: "*";
	property string hint;
	property bool alwaysShowCursor: false;
	property bool handleDelete: true;
	property bool passwordMode: false;
	property Color textColor: colorTheme.activeTextColor;
	property Color borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
	property int borderWidth: 2;
	property int radius: colorTheme.rounded ? 8 : 0;

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

	SubheadText {
		anchors.bottom: borderRect.bottom;
		anchors.horizontalCenter: borderRect.horizontalCenter;

		color: colorTheme.textColor;
		text: editItem.hint;
		font: bodyFont;

		opacity: editText.text == "" ? 0.8 : 0;

		Behavior on opacity { animation: Animation { duration: 500; } }
	}

	SubheadText {
		id: editText;

		anchors.fill: parent;

		verticalAlignment: ui.Text.AlignVCenter;
		horizontalAlignment: ui.Text.AlignHCenter;

		font: bodyFont;
		color: editItem.textColor;

		Behavior on opacity { animation: Animation { duration: 300; } }

		function updateText() {
			log("text changed " + editItem.text);

			var line = editItem.text;
			if (editItem.maxLen > 0)
				line = line.substr(0, editItem.maxLen);

			if (!editItem.passwordMode)
				editText.text = line;
			else
				editText.text = new Array(line.length + 1).join(mask);
		}
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
	}

	Timer {
		id: cursorBlinkTimer;

		interval: 500;
		repeat: true;
		
		onTriggered: { cursorRect.visible = !cursorRect.visible; }
	}

	onKeyPressed: {
		if (!recursiveVisible)
			return false;

		var keyUsed = false;

		if ((key == "Backspace" || key == "Left") && editItem.handleDelete)
		{
			removeChar();
			keyUsed = true;
		}
		else if (key == "Space")
		{
			editItem.text += " ";
			keyUsed = true;
		}
		else if (key.length == 1)
		{
			if (editItem.ignoreChars.indexOf(key) != -1)
				return true;

			key = key.toLowerCase();
			var futureValue;

			if (editItem.maxLen == 0 || editItem.text.length < editItem.maxLen)
				futureValue = editItem.text + key;
			else if (editItem.clearAfterMaxlenReached)
				futureValue = key;
			else
				futureValue = editItem.text.substr(1) + key;

			editItem.text = futureValue;

			keyUsed = true;
		}
		return keyUsed;
	}

	onTextChanged: { editText.updateText(); }

	onActiveFocusChanged: {
		cursorRect.visible = activeFocus || alwaysShowCursor;

		if (cursorRect.visible)
			cursorBlinkTimer.restart();
		else
			cursorBlinkTimer.stop();
	}

	function removeChar() {
		if (editItem.text.length == 0)
			return;

		var text = editItem.text;
		var i = text.length - 1;

		while (i > 0 && (text[i] & 0xc0) == 0x80)
			i--;

		editItem.text = text.substr(0, i);
	}

	function clear() {
		editItem.text = "";
		editText.width = 0;
	}

	onCompleted: { editText.updateText(); }
}
