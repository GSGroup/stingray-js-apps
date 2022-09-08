// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.Utils;
import controls.HighlightListView;
import "ChooserDelegate.qml";

Item {
	id: chooserItem;

	property alias currentIndex: listView.currentIndex;
	property alias count: listView.count;
	property alias contentWidth: listView.contentWidth;
	property alias model: listView.model;
	property alias backgroundVisible: chooserBackground.visible;

	property bool showArrows: true;
	property bool wrapNavigation;

	property int chooserWidth: 520;

	property Color gradientNonFocusColor: chooserBackground.nonFocusColor;
	property Color backgroundNonFocusColor: colorTheme.buttonColor;

	height: chooserBackground.height;
	width: Math.min(chooserWidth, listView.contentWidth + listView.anchors.leftMargin + listView.anchors.rightMargin);

	ActivePanel {
		id: chooserBackground;

		anchors.fill: parent;

		nonFocusColor: chooserItem.backgroundNonFocusColor;
		color: chooserItem.activeFocus ? focusColor : nonFocusColor;

		focus: false;
	}
	
	Image {
		id: leftImage;

		anchors.verticalCenter: listView.verticalCenter;
		anchors.right: listView.left;
		anchors.rightMargin: (30 - leftImage.width) / 2;

		forcedLoading: true;
		source: colorTheme.pathToStyleFolder + "/left.png";
		color: colorTheme.highlightPanelColor;

		visible : chooserItem.showArrows && listView.count > 1;
		opacity: parent.activeFocus ? 1 : 0;
		
		Behavior on opacity { animation: Animation { duration: 300; } }
	}
	
	Image {
		id: rightImage;

		anchors.verticalCenter: listView.verticalCenter;
		anchors.left: listView.right;
		anchors.leftMargin: (30 - rightImage.width) / 2;

		forcedLoading: true;
		source: colorTheme.pathToStyleFolder + "/right.png";
		color: colorTheme.highlightPanelColor;

		visible: chooserItem.showArrows && listView.count > 1;
		opacity: parent.activeFocus ? 1 : 0;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}
	
	HighlightListView {
		id: listView;

		height: parent.height;

		anchors.right: chooserItem.right;
		anchors.left: chooserItem.left;
		anchors.rightMargin: 30;
		anchors.leftMargin: 30;
		anchors.verticalCenter: parent.verticalCenter;

		wrapNavigation: chooserItem.wrapNavigation;
		handleNavigationKeys: false;
		orientation: Horizontal;
		clip: true;
		highlightColor: chooserItem.activeFocus ? colorTheme.highlightPanelColor : colorTheme.passiveHighlightPanel;
		positionMode: Center;

		delegate: ChooserDelegate { chooserFocused: listView.activeFocus; }
		
		Image {
			anchors.right: highlight.left;
			anchors.top: highlight.top;
			anchors.bottom: highlight.bottom;

			source: "res/common/shadow_left_" + colorTheme.shadowFilename + ".png";
			fillMode: TileVertically;
		}

		Image {
			anchors.left: highlight.right;
			anchors.top: highlight.top;
			anchors.bottom: highlight.bottom;

			source: "res/common/shadow_right_" + colorTheme.shadowFilename + ".png";
			fillMode: TileVertically;
		}
		
		onLeftPressed: { this.moveCurrentIndexBackward(); }
		onRightPressed: { this.moveCurrentIndexForward(); }
	}
	
	Item {
		width: 60;

		anchors.top: listView.top;
		anchors.left: listView.left;
		anchors.bottom: listView.bottom;

		opacity: (listView.contentWidth > listView.width) && (listView.currentIndex != 0) ? 1 : 0;

		Gradient {
			anchors.left: parent.left;
			anchors.top: parent.top;
			anchors.right: parent.right;
			anchors.bottom: parent.bottom;

			orientation: Horizontal;

			GradientStop {
				position: 0;
				color: chooserItem.activeFocus ? colorTheme.activeFocusColor : chooserItem.gradientNonFocusColor;

				Behavior on color { animation: Animation { duration: 300;} }
			}

			GradientStop {
				position: 1;
				color: Utils.setAlpha((chooserItem.activeFocus ? colorTheme.activeFocusColor : chooserItem.gradientNonFocusColor), 0);

				Behavior on color { animation: Animation { duration: 300;} }
			}
		}

		Behavior on opacity { animation: Animation { duration: 300;} }
	}

	Item {
		width: 60;

		anchors.top: listView.top;
		anchors.right: listView.right;
		anchors.bottom: listView.bottom;

		opacity: (listView.contentWidth > listView.width) && (listView.currentIndex != (listView.count - 1)) ? 1 : 0;

		Gradient {
			anchors.left: parent.left;
			anchors.top: parent.top;
			anchors.right: parent.right;
			anchors.bottom: parent.bottom;

			orientation: Horizontal;

		GradientStop {
				position: 0;
				color: Utils.setAlpha((chooserItem.activeFocus ? colorTheme.activeFocusColor : chooserItem.gradientNonFocusColor), 0);

				Behavior on color { animation: Animation { duration: 300;} }
			}

		GradientStop {
				position: 1;
				color: chooserItem.activeFocus ? colorTheme.activeFocusColor : chooserItem.gradientNonFocusColor;

				Behavior on color { animation: Animation { duration: 300;} }
			}
		}

		Behavior on opacity { animation: Animation { duration: 300;} }
	}
}
