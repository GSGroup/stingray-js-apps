// © "Сifra" LLC, 2011-2023
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import PasswordEdit;

BaseDialog {
	id: enterPinDialogItem;

	signal accepted;
	signal refused;

	property string title: "Enter PIN";
	property string message;

	property bool horizontalDialog: true;
	property bool handleKidsBlueKey;

	property variant pinRequest;

	property int bodyColumnHeight: bodyColumn.height + bodyColumn.anchors.topMargin + 20hph;

	width: pinRow.width + 60hpw;
	height: bodyColumnHeight;

	Column {
		id: bodyColumn;

		anchors.left: parent.left;
		anchors.leftMargin: 30hpw;
		anchors.right: parent.right;
		anchors.rightMargin: 30hpw;
		anchors.top: parent.top;
		anchors.topMargin: 20hph;

		BodyText {
			id: messageText;

			width: parent.width;

			wrapMode: ui.Text.WrapMode.WordWrap;
			horizontalAlignment: ui.Text.HorizontalAlignment.AlignHCenter;

			text: enterPinDialogItem.message;

			visible: text && !enterPinDialogItem.horizontalDialog;
		}

		Item {
			width: parent.width;
			height: 20hph;

			visible: messageText.visible;
		}

		Row {
			id: pinRow;

			SubheadText {
				anchors.verticalCenter: parent.verticalCenter;

				text: enterPinDialogItem.title;

				visible: text && enterPinDialogItem.horizontalDialog;
			}

			Item {
				width: enterPinDialogItem.horizontalDialog ? 20hpw : (bodyColumn.width - pinEdit.width) / 2;
			}

			PasswordEdit {
				id: pinEdit;

				height: 53hph;
				width: 176hpw;

				maxLen: 4;

				onSelectPressed: {
					if (!enterPinDialogItem.pinRequest)
						return false;

					if (enterPinDialogItem.pinRequest.setPin(text))
						enterPinDialogItem.accepted();
					else
						clear();
				}

				onMaxLenReached: {
					if (enterPinDialogItem.pinRequest && enterPinDialogItem.pinRequest.setPin(text))
						enterPinDialogItem.accepted();

					clearWithDelay();
				}
			}
		}
	}

	onKeyPressed: {
		if (key == "Back" || (handleKidsBlueKey && key == "Blue" && event.Source == "kids"))
		{
			refused();
			return true;
		}
	}

	onVisibleChanged: {
		if (visible)
			pinEdit.clear();
	}
}
