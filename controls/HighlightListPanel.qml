// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.HighlightListView;

HighlightListView {
	id: highlightListPanelProto;

	property bool showScroll: true;
	property bool showBackground: true;
	property bool showFocused;
	property bool active: activeFocus || showActiveFocus;

	property Color focusColor: colorTheme.activePanelColor;
	property Color nonFocusColor: colorTheme.focusablePanelColor;

	clip: true;
	highlightVisible: count > 0 && (showFocused || active);

	Rectangle {
		id: background;

		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.top: parent.top;
		anchors.bottom: parent.bottom;

		color: highlightListPanelProto.active ? highlightListPanelProto.focusColor : highlightListPanelProto.nonFocusColor;

		visible: highlightListPanelProto.showBackground;
		z: -1;

		Behavior on color { animation: Animation { duration: 300; } }
	}

	ScrollBar {
		id: scrollBar;

		targetView: highlightListPanelProto;
		visible: highlightListPanelProto.showScroll;
	}

	onCurrentIndexChanged: { scrollBar.show(); }
}
