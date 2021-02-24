Item {
	id: baseEditItem;

	signal maxLenReached;
	signal invalidKeyEntered(std::string key);

	property string text;
	property string ignoreChars: "#*";

	property int maxLen;

	property bool clearAfterMaxlenReached: true;
	property bool handleDelete: true;
	property bool escapeAvailable;

	clip: true;
	focus: true;

	onKeyPressed: {
		var keyUsed = false;

		if ((key == "Backspace" || key == "Left") && baseEditItem.handleDelete && (baseEditItem.text.length || !escapeAvailable))
		{
			removeChar();
			keyUsed = true;
		}
		else if (key == "Space")
		{
			baseEditItem.text += " ";
			keyUsed = true;
		}
		else if (key.length == 1)
		{
			if (baseEditItem.ignoreChars.indexOf(key) != -1)
				return true;

			key = key.toLowerCase();
			var futureValue;

			if (baseEditItem.maxLen == 0 || baseEditItem.text.length < baseEditItem.maxLen)
				futureValue = baseEditItem.text + key;
			else if (baseEditItem.clearAfterMaxlenReached)
				futureValue = key;
			else
				futureValue = baseEditItem.text.substr(1) + key;

			baseEditItem.text = futureValue;

			keyUsed = true;
		}
		return keyUsed;
	}

	function removeChar() {
		if (baseEditItem.text.length == 0)
			return;

		var text = baseEditItem.text;
		var i = text.length - 1;

		while (i > 0 && (text[i] & 0xc0) == 0x80)
			i--;

		baseEditItem.text = text.substr(0, i);
	}

	function clear() {
		baseEditItem.text = "";
	}
}
