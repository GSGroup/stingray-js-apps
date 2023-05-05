// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "BaseEdit.qml";
import "PasswordEditDelegate.qml";

BaseEdit {
	id: passwordEditItem;

	property bool showBackground: true;

	width: echoTextView.width;

	ActivePanel {
		anchors.fill: parent;

		visible: passwordEditItem.showBackground;
	}

	ListView {
		id: echoTextView;

		width: contentWidth;
		height: contentHeight;

		anchors.centerIn: parent;

		spacing: 12hpw;
		orientation: Horizontal;
		uniformDelegateSize: true;

		model: ListModel {
			id: listModel;
			property bool filled;
		}
		delegate: PasswordEditDelegate {
			editing: passwordEditItem.activeFocus;
			colorAnimable: passwordEditItem.maxLen != 0;
		}
	}

	Timer {
		id: clearPasswordTimer;

		interval: 100;

		onTriggered: { passwordEditItem.clear(); }
	}

	onKeyPressed: { passwordEditItem.finishDeferredClear(); }

	onTextChanged: {
		passwordEditItem.finishDeferredClear();
		passwordEditItem.fillModel();
	}

	function onMaxLenChanged() { passwordEditItem.fillModel(); }

	function clearWithDelay() { clearPasswordTimer.restart(); }

	function finishDeferredClear() {
		if (clearPasswordTimer.running)
		{
			clearPasswordTimer.stop();
			passwordEditItem.clear();
		}
	}

	function fillModel() {
		const textSize = passwordEditItem.text.length;
		const maxLength = passwordEditItem.maxLen;
		const modelRowsCount = maxLength ? maxLength : textSize;

		const rows = new Array();
		for (let i = 0; i < modelRowsCount; i++)
			rows.push({ filled: i < textSize });

		listModel.reset();
		listModel.append(...rows);
	}

	onCompleted: { passwordEditItem.fillModel(); }
}
