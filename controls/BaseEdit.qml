// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
	id: baseEditItem;

	signal maxLenReached;
	signal invalidKeyEntered(key);

	property string text;
	property string ignoreChars: "#*";
	property variant validator;

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

			var futureValue;

			if (baseEditItem.maxLen == 0 || baseEditItem.text.length < baseEditItem.maxLen)
				futureValue = baseEditItem.text + key;
			else if (baseEditItem.clearAfterMaxlenReached)
				futureValue = key;
			else
				futureValue = baseEditItem.text.substr(1) + key;

			if (baseEditItem.validator == null || baseEditItem.validator.validate(futureValue))
			{
				baseEditItem.text = futureValue;

				if (baseEditItem.text.length == baseEditItem.maxLen)
					maxLenReached();
			}
			else
				invalidKeyEntered(key);

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
