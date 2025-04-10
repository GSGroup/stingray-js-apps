// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.ButtonWithShadow;

Dialog {
	id: confirmDialogProto;

	signal accepted;
	signal refused;

	property string okButtonText;
	property string cancelButtonText;
	property enum { Ok, Cancel, None } defaultButton: Cancel;
	property bool unrefusable;

	height: headerColumnHeight + buttonRow.height + 30hph;

	JSRemoteControlObject {
		id: remoteControl;

		parentVisible: confirmDialogProto.visible;

		updateMessage: { this.setStringAttribute("message", confirmDialogProto.message); }

		updateCancelAction: {
			this.unregisterAction("cancel");

			if (cancelButton.visible)
				this.registerAction("cancel", confirmDialogProto.refuse, []);
		}

		onCompleted: { this.registerAction("ok", confirmDialogProto.accept, []); }
	}

	Row {
		id: buttonRow;

		y: confirmDialogProto.headerColumnHeight;

		anchors.left: parent.left;
		anchors.leftMargin: 30hpw;
		anchors.right: parent.right;
		anchors.rightMargin: 30hpw;

		spacing: 16hpw;

		ButtonWithShadow {
			id: okButton;

			width: confirmDialogProto.unrefusable ? Math.max(176hpw, iconTextItem.width + contentMargin * 2) : (buttonRow.width - buttonRow.spacing) / 2;

			anchors.left: buttonRow.left;
			anchors.leftMargin: confirmDialogProto.unrefusable ? (buttonRow.width - okButton.width) / 2 : 0 ;

			text: confirmDialogProto.okButtonText != "" ? confirmDialogProto.okButtonText : tr("OK");

			onSelectPressed: {
				confirmDialogProto.visible = false;
				confirmDialogProto.accepted();
			}
		}

		ButtonWithShadow {
			id: cancelButton;

			width: okButton.width;

			text: confirmDialogProto.cancelButtonText != "" ? confirmDialogProto.cancelButtonText : tr("Cancel");

			visible: !confirmDialogProto.unrefusable;

			onSelectPressed: { confirmDialogProto.refuse(); }

			onVisibleChanged: { remoteControl.updateCancelAction(); }

			onCompleted: { remoteControl.updateCancelAction(); }
		}
	}

	onBackPressed: { confirmDialogProto.refuse(); }

	onMessageChanged: { remoteControl.updateMessage(); }

	onVisibleChanged: {
		if (!this.visible)
			return;

		if (defaultButton == confirmDialogProto.Ok || (confirmDialogProto.unrefusable && defaultButton == confirmDialogProto.Cancel))
			okButton.setFocus();
		else if (defaultButton == confirmDialogProto.Cancel)
			cancelButton.setFocus();

		cancelButton.completePropertyAnimation("color");
		okButton.completePropertyAnimation("color");
	}

	accept: {
		this.visible = false;
		this.accepted();
	}

	refuse: {
		if (this.unrefusable)
			return;

		this.visible = false;
		this.refused();
	}

	onCompleted: { remoteControl.updateMessage(); }
}
