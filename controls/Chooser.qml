import "controls/utils.js" as utils;
import controls.HighlightListView;
import ChooserDelegate;

Item {
	id: chooserItem;
	property alias currentIndex: listView.currentIndex;
	property alias count: listView.count;
	property alias backgroundVisible: chooserBackground.visible;
	property alias inverted: chooserBackground.inverted;
	property bool showArrows: true;
	property bool arrowsInPanel: true;
	property int chooserWidth: 520;
	height: chooserBackground.height;
	width: Math.min(chooserWidth, listView.contentWidth + (30 + rightImage.width + leftImage.width) * (showArrows && arrowsInPanel));
	focusedChild: listView;
	
	ActivePanel {
		id: chooserBackground;
		color: inverted ? (parent.activeFocus ? colorTheme.highlightPanelColor : colorTheme.passiveHighlightPanel) 
						: (parent.activeFocus ? colorTheme.activeFocusColor : colorTheme.focusablePanelColor);
		focus: false;
		anchors.fill: parent;
	}
	
	Image {
		id: leftImage;
		anchors.verticalCenter: listView.verticalCenter;
		anchors.right: listView.left;
		anchors.rightMargin: 10;
		forcedLoading: true;
		source: colorTheme.pathToStyleFolder + "/left.png";
		opacity: parent.activeFocus ? 1 : 0;
		visible : chooserItem.showArrows;
		
		Behavior on opacity { animation: Animation { duration: 300; } }
	}
	
	Image {
		id: rightImage;
		anchors.verticalCenter: listView.verticalCenter;
		anchors.left: listView.right;
		anchors.leftMargin: 10;
		forcedLoading: true;
		source: colorTheme.pathToStyleFolder + "/right.png";
		opacity: parent.activeFocus ? 1 : 0;
		visible: chooserItem.showArrows;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}
	
	HighlightListView {
		id: listView;
		anchors.right: chooserItem.right;
		anchors.left: chooserItem.left;
		anchors.rightMargin: 10 + chooserItem.arrowsInPanel ? rightImage.width + 10 : 0;
		anchors.leftMargin: 10 + chooserItem.arrowsInPanel ? leftImage.width + 10 : 0;
		anchors.verticalCenter: parent.verticalCenter;
		height: parent.height;
		leftFocusMargin: 5;
        rightFocusMargin: 5;
        highlightFollowsCurrentItem: false;
        keyNavigationWraps: true;
		handleNavigationKeys: false;
		orientation: Horizontal;
		delegate: ChooserDelegate { }
		clip: true;
		highlight.color: chooserItem.activeFocus ? colorTheme.highlightPanelColor : colorTheme.passiveHighlightPanel;
		positionMode: Center;
		
		Image {
			anchors.right: highlight.left;
			anchors.top: highlight.top;
			anchors.bottom: highlight.bottom;
			source: "res/common/shadow_left.png";
			fillMode: TileVertically;
		}

		Image {
			anchors.left: highlight.right;
			anchors.top: highlight.top;
			anchors.bottom: highlight.bottom;
			source: "res/common/shadow_right.png";
			fillMode: TileVertically;
		}

		onLeftPressed:	{ this.decrementCurrentIndex(); }
		onRightPressed:	{ this.incrementCurrentIndex(); }
	}
	
	Item {
		anchors.top: listView.top;
		anchors.left: listView.left;
		anchors.bottom: listView.bottom;
		opacity: (listView.contentWidth > listView.width) && (listView.currentIndex != 0) ? 1 : 0;
		width: 64;

		Gradient {
			anchors.left: parent.left;
			anchors.top: parent.top;
			anchors.right: parent.right;
			anchors.bottom: parent.bottom;

			orientation: Horizontal;
			GradientStop {
				position: 0;
				color: chooserItem.activeFocus ? colorTheme.activeFocusColor : colorTheme.focusablePanelColor;
				Behavior on color { animation: Animation { duration: 300;} }
			}
			GradientStop {
				position: 1;
				color: utils.setAlpha((chooserItem.activeFocus ? colorTheme.activeFocusColor : colorTheme.focusablePanelColor), 0);
				Behavior on color { animation: Animation { duration: 300;} }
			}
		}
		Behavior on opacity { animation: Animation { duration: 300;} }
	}

	Item {
		anchors.top: listView.top;
		anchors.right: listView.right;
		anchors.bottom: listView.bottom;
		opacity: (listView.contentWidth > listView.width) && (listView.currentIndex != (listView.count - 1)) ? 1 : 0;
		width: 64;

		Gradient {
			anchors.left: parent.left;
			anchors.top: parent.top;
			anchors.right: parent.right;
			anchors.bottom: parent.bottom;

			orientation: Horizontal;
			GradientStop {
				position: 0;
				color: utils.setAlpha((chooserItem.activeFocus ? colorTheme.activeFocusColor : colorTheme.focusablePanelColor), 0);
				Behavior on color { animation: Animation { duration: 300;} }
			}
			GradientStop {
				position: 1;
				color: chooserItem.activeFocus ? colorTheme.activeFocusColor : colorTheme.focusablePanelColor;
				Behavior on color { animation: Animation { duration: 300;} }
			}
		}
		Behavior on opacity { animation: Animation { duration: 300;} }
	}
}
