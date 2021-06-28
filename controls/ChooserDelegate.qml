// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
	id: delegateItem;

	property bool chooserFocused;

	width: 20 + chooserDelegateText.width * chooserDelegateText.visible + chooserIcon.width * chooserIcon.visible + (chooserIcon.visible && chooserDelegateText.visible) * 10;
	height: parent.height;

	focus: true;
	
	Image {
		id: chooserIcon;

		anchors.left: parent.left;
		anchors.leftMargin: 10;
		anchors.verticalCenter: parent.verticalCenter;

		source: model.icon;
		color: delegateItem.activeFocus ? colorTheme.globalBackgroundColor :
			delegateItem.chooserFocused ? colorTheme.focusedTextColor : colorTheme.activeTextColor;

		visible: model.icon != undefined ? source != "" : false;
		opacity: parent.focused || delegateItem.chooserFocused ? 1 : 0.6;
		
		Behavior on color { animation: Animation { duration: 300; } }
		Behavior on opacity { animation: Animation { duration: 300; } }
	}
	
	BodyText {
		id: chooserDelegateText;

		anchors.right: parent.right;
		anchors.rightMargin: 10;
		anchors.verticalCenter: parent.verticalCenter;

		text: model.text;
		color: delegateItem.activeFocus ? colorTheme.globalBackgroundColor :
			delegateItem.chooserFocused ? colorTheme.focusedTextColor : colorTheme.activeTextColor;

		visible: model.text != undefined ? text != "" : false;
		opacity: parent.focused || delegateItem.chooserFocused ? 1 : 0.6;
		
		Behavior on color { animation: Animation { duration: 300; } }
		Behavior on opacity { animation: Animation { duration: 300; } }
	}
}
