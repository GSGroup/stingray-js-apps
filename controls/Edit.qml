Edit : Item {
	id: editItem;
	focus: true;
	width: 100;
	height: 40;
	clip: true;

	property bool showBackground: true;
	property string text;
	property int maxLen;
	property bool clearAfterMaxlenReached: true;
	//property Validator validator;
	property string ignoreChars: "#*";
	property string mask: "*";
	property bool alwaysShowCursor: false;
	property bool handleDelete: true;
	property bool passwordMode: false;
	property Color textColor;
	textColor: colorTheme.activeTextColor;

	event maxLenReached;
	event invalidKeyEntered(std::string key);

	onActiveFocusChanged: {
		cursorRect.visible = activeFocus || alwaysShowCursor;

		if (cursorRect.visible)
			cursorBlinkTimer.restart();
		else
			cursorBlinkTimer.stop();
	}

	Rectangle {
		id: borderRect;
		anchors.fill: parent;
		borderWidth: 2;
		radius: colorTheme.rounded ? 8 : 0;
		borderColor: parent.activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
		color: colorTheme.globalBackgroundColor;
		visible: editItem.showBackground;

		Behavior on borderColor {
			animation: Animation {
				duration: 200;
			}
		}
	}

	MainText {
		id: editText;
		anchors.bottom: borderRect.bottom;
		anchors.horizontalCenter: borderRect.horizontalCenter;
		opacity: 1;
		color: editItem.textColor; 

		Behavior on opacity {
			animation: Animation {
				duration: 300;
			}
		}

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

	onTextChanged: {
		editText.updateText();
	}

	Rectangle {
		id: cursorRect;
		anchors.top: parent.top;
		anchors.bottom: parent.bottom;
		anchors.left: editText.right;
		anchors.margins: 7;
		anchors.leftMargin: 2;
		opacity: borderRect.opacity;
		width: 2;
		color: editText.color;
	}

	Timer {
		id: cursorBlinkTimer;
		interval: 500;
		repeat: true;
		
		onTriggered: {
			cursorRect.visible = !cursorRect.visible;
		}
	}

	onKeyPressed: {
		var keyUsed = false;

		if ((key == "Backspace" || key == "Left") && editItem.handleDelete) {
			removeChar();
			keyUsed = true;
		} else if (key == "Space") {
			editItem.text += " ";
			keyUsed = true;
		} else if (key.length == 1) {
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

			//if (text.length == editItem.maxLen)
				//editItem.maxLenReached();

			keyUsed = true;
		}
		return keyUsed;
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

	onCompleted: {
		editText.updateText();
	}
}
