// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import Chooser;

ActivePanel {
	id: labeledChooserProto;

	property alias currentIndex: chooser.currentIndex;
	property alias model: chooser.model;
	property alias snapMode: chooser.snapMode;

	property string label;
	property bool showArrows: true;

	property int count: chooser.count;

	property int chooserWidth: Math.min(width * 2 / 3, width - textItem.width - textItem.anchors.leftMargin - 30hpw);

	BodyText {
		id: textItem;

		anchors.left: parent.left;
		anchors.leftMargin: 30hpw;
		anchors.verticalCenter: parent.verticalCenter;

		text: labeledChooserProto.label;
		color: parent.activeFocus ? colorTheme.focusedTextColor : colorTheme.activeTextColor;

		Behavior on color { animation: Animation { duration: 300; } }
	}

	Chooser {
		id: chooser;

		anchors.right: parent.right;

		backgroundVisible: false;
		showArrows: labeledChooserProto.showArrows;
		chooserWidth: labeledChooserProto.chooserWidth;
		gradientNonFocusColor: labeledChooserProto.nonFocusColor;
	}

	completeAnimation: {
		chooser.listView.completeContentAnimation();
		chooser.listView.completeHighlightAnimation();
	}
}
