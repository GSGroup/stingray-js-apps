// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.HighlightLeftPanelViewDelegate;
import controls.HighlightListPanel;

HighlightListPanel {
	id: highlightLeftPanelViewProto;

	property int minWidth: safeArea.x + 89hpw;
	property bool wide: highlightLeftPanelViewProto.activeFocus;
	property bool isMoving;

	width: highlightLeftPanelViewProto.wide ? safeArea.x + 326hpw : minWidth;

	anchors.left: mainWindow.left;
	anchors.top: safeArea.top;
	anchors.bottom: mainWindow.bottom;

	showScroll: false;
	uniformDelegateSize: true;
	clip: false;
	showFocused: true;
	wrapNavigation: true;

	focusColor: colorTheme.focusablePanelColor;
	nonFocusColor: colorTheme.globalBackgroundColor;

	highlightWidthAnimationDuration: 0;

	model: ListModel {
		property string text;
		property string imageSource;
	}
	delegate: HighlightLeftPanelViewDelegate {
		wide: highlightLeftPanelViewProto.wide;
		showActiveFocus: highlightLeftPanelViewProto.showActiveFocus;
		showFocused: highlightLeftPanelViewProto.showFocused;
	}

	Rectangle {
		anchors.left: mainWindow.left;
		anchors.right: parent.right;
		anchors.top: mainWindow.top;
		anchors.bottom: parent.top;

		color: highlightLeftPanelViewProto.backgroundColor;
	}

	Behavior on width {
		animation: Animation {
			duration: 300;

			onRunningChanged: { highlightLeftPanelViewProto.isMoving = running; }
		}
	}
}
