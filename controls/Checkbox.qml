// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "ActivePanel.qml";
import "FloatingElidedText.qml";
import "CheckIcon.qml";

ActivePanel {
	id: checkboxProto;

	property string text;
	property Color textColor: activeFocus ? colorTheme.focusedTextColor : colorTheme.activeTextColor;
	property var font: bodyFont;
	property bool handleNavigationKeys;
	property bool checked;

	FloatingElidedText {
		id: checkboxText;

		anchors.left: parent.left;
		anchors.right: icon.left;
		anchors.leftMargin: 30hpw;
		anchors.rightMargin: 30hpw;

		anchors.verticalCenter: parent.verticalCenter;

		text: checkboxProto.text;
		color: checkboxProto.textColor;
		font: checkboxProto.font;

		floating: checkboxProto.activeFocus;
	}

	CheckIcon {
		id: icon;

		anchors.verticalCenter: parent.verticalCenter;
		anchors.right: parent.right;
		anchors.rightMargin: 30hpw;

		color: checked ? colorTheme.accentGreenColor :
				checkboxProto.activeFocus ? colorTheme.focusedTextColor :
				colorTheme.activeTextColor;

		checked: checkboxProto.checked;
	}

	onLeftPressed: {
		if (this.handleNavigationKeys && this.visible && this.activeFocus)
		{
			this.checked = false;
			return true;
		}

		return false;
	}

	onRightPressed: {
		if (this.handleNavigationKeys && this.visible && this.activeFocus)
		{
			this.checked = true;
			return true;
		}

		return false;
	}

	onSelectPressed: {
		if (this.visible && this.activeFocus)
		{
			this.checked = !this.checked;
			return true;
		}

		return false;
	}

	onActiveFocusChanged: { icon.completeAnimation(); }

	completeAnimation: {
		this.completePanelAnimation();
		icon.completeAnimation();
	}
}
