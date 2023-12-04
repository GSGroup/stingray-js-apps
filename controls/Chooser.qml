// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.Utils;
import controls.HighlightListView;
import "ChooserDelegate.qml";

Item {
	id: chooserProto;

	property alias currentIndex: listView.currentIndex;
	property alias model: listView.model;

	property alias contentWidth: listView.contentWidth;
	property bool wrapNavigation: true;

	property int count: listView.count;
	property bool backgroundVisible: true;

	property enum { No, One } snapMode: No;

	property bool showArrows: true;

	property int chooserWidth: 520hpw;

	property int margins: listView.anchors.leftMargin + listView.anchors.rightMargin;

	property Color gradientNonFocusColor: colorTheme.focusablePanelColor;

	height: chooserBackground.height;
	width: snapMode == No ? Math.min(chooserWidth, listView.contentWidth + margins) :
			listView.getDelegateRect(listView.currentIndex).Width() + margins;

	Panel {
		id: chooserBackground;

		anchors.fill: parent;

		color: chooserProto.activeFocus ? colorTheme.activeFocusColor : colorTheme.focusablePanelColor;

		visible: chooserProto.backgroundVisible;
	}

	Image {
		id: leftImage;

		anchors.right: listView.left;
		anchors.rightMargin: (30hpw - leftImage.width) / 2;
		anchors.verticalCenter: listView.verticalCenter;

		forcedLoading: true;
		source: colorTheme.pathToStyleFolder + "/left.svg";
		color: colorTheme.highlightPanelColor;

		visible : chooserProto.showArrows && listView.count > 1;
		opacity: parent.activeFocus ? 1 : 0;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}

	Image {
		id: rightImage;

		anchors.left: listView.right;
		anchors.leftMargin: (30hpw - rightImage.width) / 2;
		anchors.verticalCenter: listView.verticalCenter;

		forcedLoading: true;
		source: colorTheme.pathToStyleFolder + "/right.svg";
		color: colorTheme.highlightPanelColor;

		visible: chooserProto.showArrows && listView.count > 1;
		opacity: parent.activeFocus ? 1 : 0;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}

	HighlightListView {
		id: listView;

		height: parent.height;

		anchors.left: chooserProto.left;
		anchors.leftMargin: 30hpw;
		anchors.right: chooserProto.right;
		anchors.rightMargin: 30hpw;
		anchors.verticalCenter: parent.verticalCenter;

		contentXAnimationDuration: chooserProto.snapMode == chooserProto.No ? 250 : 0;

		wrapNavigation: chooserProto.wrapNavigation;
		handleNavigationKeys: false;
		handleMouseEvents: MouseClickSwitchesItem;

		orientation: ui.ListView.Orientation.Horizontal;
		positionMode: ui.BaseView.PositionMode.Center;
		clip: true;

		highlightColor: chooserProto.activeFocus ? colorTheme.highlightPanelColor : colorTheme.passiveHighlightPanel;

		focus: true;

		delegate: ChooserDelegate {
			height: parent.height;

			chooserFocused: chooserProto.activeFocus;
		}
	}

	Image {
		anchors.right: listView.highlight.left;
		anchors.top: listView.highlight.top;
		anchors.bottom: listView.highlight.bottom;

		source: "res/common/shadow_left_" + colorTheme.shadowFilename + ".png";
		fillMode: ui.Image.FillMode.TileVertically;

		visible: parent.activeFocus;
	}

	Image {
		anchors.left: listView.highlight.right;
		anchors.top: listView.highlight.top;
		anchors.bottom: listView.highlight.bottom;

		source: "res/common/shadow_right_" + colorTheme.shadowFilename + ".png";
		fillMode: ui.Image.FillMode.TileVertically;

		visible: parent.activeFocus;
	}

	Item {
		width: 60hpw;

		anchors.left: listView.left;
		anchors.top: listView.top;
		anchors.bottom: listView.bottom;

		opacity: listView.contentWidth > listView.width && listView.currentIndex != 0 && chooserProto.snapMode == chooserProto.No ? 1 : 0;

		Gradient {
			anchors.left: parent.left;
			anchors.right: parent.right;
			anchors.top: parent.top;
			anchors.bottom: parent.bottom;

			orientation: ui.Gradient.Orientation.Horizontal;

			GradientStop {
				position: 0;

				color: chooserProto.activeFocus ? colorTheme.activeFocusColor : chooserProto.gradientNonFocusColor;

				Behavior on color { animation: Animation { duration: 300;} }
			}

			GradientStop {
				position: 1;

				color: Utils.setAlpha((chooserProto.activeFocus ? colorTheme.activeFocusColor : chooserProto.gradientNonFocusColor), 0);

				Behavior on color { animation: Animation { duration: 300;} }
			}
		}

		Behavior on opacity { animation: Animation { duration: 300;} }
	}

	Item {
		width: 60hpw;

		anchors.right: listView.right;
		anchors.top: listView.top;
		anchors.bottom: listView.bottom;

		opacity: listView.contentWidth > listView.width && listView.currentIndex != (listView.count - 1) && chooserProto.snapMode == chooserProto.No ? 1 : 0;

		Gradient {
			anchors.left: parent.left;
			anchors.right: parent.right;
			anchors.top: parent.top;
			anchors.bottom: parent.bottom;

			orientation: ui.Gradient.Orientation.Horizontal;

			GradientStop {
				position: 0;

				color: Utils.setAlpha((chooserProto.activeFocus ? colorTheme.activeFocusColor : chooserProto.gradientNonFocusColor), 0);

				Behavior on color { animation: Animation { duration: 300;} }
			}

			GradientStop {
				position: 1;

				color: chooserProto.activeFocus ? colorTheme.activeFocusColor : chooserProto.gradientNonFocusColor;

				Behavior on color { animation: Animation { duration: 300;} }
			}
		}

		Behavior on opacity { animation: Animation { duration: 300;} }
	}

	onLeftPressed:	{ listView.moveCurrentIndexBackward(); }
	onRightPressed:	{ listView.moveCurrentIndexForward(); }
}
