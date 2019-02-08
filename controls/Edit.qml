Item {
	id: editItem;
	focus: true;
	width: 100;
	height: 40;
	clip: true;
	focus: true;

	//property Font font;
	property bool showBackground: true;
	property string text;
	property int maxLen;
	property bool clearAfterMaxlenReached: true;
	//property Validator validator;
	property string ignoreChars: "#*";
	property string mask: "*";
	property string hint;
	property bool alwaysShowCursor: false;
	property bool handleDelete: true;
	property bool passwordMode: false;
	property Color textColor;
	textColor: colorTheme.activeTextColor;

	property Color borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
	property int borderWidth: 2;
	property int radius: colorTheme.rounded ? 8 : 0;

	signal maxLenReached;
	signal invalidKeyEntered(std::string key);

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
		borderWidth: parent.borderWidth;
		radius: parent.radius;
		color: colorTheme.globalBackgroundColor;
		visible: editItem.showBackground;
		borderColor: parent.borderColor;

		Behavior on borderColor {
			animation: Animation {
				duration: 200;
			}
		}
	}

	SubheadText {
		anchors.bottom: borderRect.bottom;
		anchors.horizontalCenter: borderRect.horizontalCenter;
		opacity: 1;
		color: colorTheme.textColor; 
		opacity: editText.text == "" ? 0.8 : 0;
		text: editItem.hint;
		font: smallFont;

		Behavior on opacity {
			animation: Animation {
				duration: 500;
			}
		}
	}

	SubheadText {
		id: editText;
		anchors.fill: parent;
		verticalAlignment: Text.AlignVCenter;
		horizontalAlignment: Text.AlignHCenter;
		color: editItem.textColor;
		font: smallFont;

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
		visible: false;
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
		if (!recursiveVisible)
			return false;

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
