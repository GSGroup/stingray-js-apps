// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import Chooser;

ActivePanel {
	id: labeledChooserItem;

	property alias currentIndex: chooserItem.listView.currentIndex;
	property alias count: chooserItem.listView.count;
	property alias contentWidth: chooserItem.listView.contentWidth;
	property alias model: chooserItem.listView.model;

	property bool keyNavigationWraps: true;
	property string text;
	property int chooserWidth: 520; 

	width: textItem.width + chooserItem.width + 40;

	BodyText {
		id: textItem;

		text: parent.text;

		anchors.left: parent.left;
		anchors.leftMargin: 20;
		anchors.verticalCenter: parent.verticalCenter;

		color: parent.activeFocus ? colorTheme.focusedTextColor : colorTheme.textColor;

		Behavior on color { animation: Animation { duration: 300; } }
	}
	
	Chooser {
		id: chooserItem;

		anchors.right: parent.right;
		anchors.rightMargin: 10;

		backgroundVisible: false;
		keyNavigationWraps: parent.keyNavigationWraps;
		chooserWidth: parent.chooserWidth;
	}
}
