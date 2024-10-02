// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.FloatingText;
import controls.HighlightListViewDelegate;

HighlightListViewDelegate {
	id: highlightLeftPanelViewDelegateProto;

	property bool wide;
	property bool showFocused;

	property string text: model.text != undefined ? tr(model.text) : "";

	height: 80hph;

	passive: focused && showFocused;

	Image {
		id: menuItemImage;

		anchors.left: contentSafeArea.left;
		anchors.verticalCenter: parent.verticalCenter;

		sourceWidth: 50hpw;
		sourceHeight: 50hph;

		color: highlightLeftPanelViewDelegateProto.isActiveFocused ? colorTheme.focusedTextColor : colorTheme.activeTextColor;
		source: model.imageSource != undefined ? model.imageSource : "";
		fillMode: ui.Image.FillMode.Stretch;

		opacity: highlightLeftPanelViewDelegateProto.wide || highlightLeftPanelViewDelegateProto.passive ? 1 : 0.3;

		Behavior on color { animation: Animation { } }
		Behavior on opacity { animation: Animation { } }
	}

	FloatingText {
		anchors.left: menuItemImage.right;
		anchors.leftMargin: 16hpw;
		anchors.right: parent.right;
		anchors.rightMargin: 16hpw;
		anchors.verticalCenter: parent.verticalCenter;

		horizontalAlignment: ui.Text.HorizontalAlignment.AlignLeft;

		floating: parent.activeFocus;

		color: highlightLeftPanelViewDelegateProto.isActiveFocused ? colorTheme.focusedTextColor : colorTheme.activeTextColor;

		text: highlightLeftPanelViewDelegateProto.text;

		opacity: highlightLeftPanelViewDelegateProto.wide || highlightLeftPanelViewDelegateProto.passive ? 1.0 : 0.3;
	}
}
