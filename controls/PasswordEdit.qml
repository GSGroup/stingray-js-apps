// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "BaseEdit.qml";
import "PasswordEditDelegate.qml";

BaseEdit {
	id: passwordEditItem;

	property Color pinDotColor: activeFocus ? colorTheme.focusedTextColor : colorTheme.activeTextColor;

	width: pinList.width;
	height: 12;
	
	focus: true;

	ListView {
		id: pinList;

		property int currentPinLength;
		property Color pinDotColor: passwordEditItem.pinDotColor;

		width: listModel.count ? listModel.count * 12 + (listModel.count - 1) * this.spacing : 0;
		height: parent.height;

		spacing: 12;
		orientation: Horizontal;

		model: ListModel { id: listModel; }
		delegate: PasswordEditDelegate {
			filled: pinList.currentPinLength >= (modelIndex + 1);
			color: pinList.pinDotColor;
		}

		onCompleted: {
			if (passwordEditItem.maxLen)
				passwordEditItem.fillModel(passwordEditItem.maxLen);
			else
				passwordEditItem.fillModel(passwordEditItem.text.length);
		}
	}

	onTextChanged: {
		pinList.currentPinLength = passwordEditItem.text.length;

		if (!passwordEditItem.maxLen)
			passwordEditItem.fillModel(passwordEditItem.text.length);
	}

	function fillModel(textSize) {
		while (listModel.count != textSize)
		{
			if (listModel.count > textSize)
				listModel.remove(listModel.count - 1);
			else
				listModel.append({ });
		}
	}
}
