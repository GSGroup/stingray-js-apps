import "controls/utils.js" as utils;
import controls.HighlightListView;
import ChooserDelegate;

ActivePanel {
	id: chooserItem;
	property bool showArrows: true;
	property int chooserWidth: 520;
	width: (leftArrow.width + rightArrow.width + listView.contentWidth + 60) > chooserWidth ? chooserWidth : leftArrow.width + rightArrow.width + listView.contentWidth + 60;
	focusedChild: listView;

	Image {
		id: leftArrow;
		anchors.left: parent.left;
		anchors.leftMargin: 20;
        anchors.rightMargin: 10;
        anchors.verticalCenter: listView.verticalCenter;
		source: colorTheme.pathToStyleFolder + "/left.png";
		opacity: parent.activeFocus ? 1 : 0;
		visible: chooserItem.showArrows;

		Behavior on opacity { animation: Animation { duration: 300;} }
	}

	HighlightListView {
		id: listView;
		anchors.top: chooserItem.top;
		anchors.bottom: chooserItem.bottom;
		anchors.topMargin: chooserItem.borderWidth;
		anchors.bottomMargin: chooserItem.borderWidth;
        anchors.right: rightArrow.left;
        anchors.left: leftArrow.right;
        anchors.rightMargin: 10;
        anchors.leftMargin: 10;
        leftFocusMargin: 5;
        rightFocusMargin: 5;
        highlightFollowsCurrentItem: false;
		keyNavigationWraps: true;
		handleNavigationKeys: false;
		orientation: Horizontal;
		delegate: ChooserDelegate { }
		model: ListModel { }
		clip: true;
		highlightColor: chooserItem.activeFocus ? colorTheme.highlightPanelColor : colorTheme.passiveHighlightPanel;
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

		onLeftPressed:	{ 
			if (this.currentIndex > 0) 
				this.currentIndex--; 
			else 
				this.currentIndex = this.count - 1; 
		}
		onRightPressed:	{
			if (this.currentIndex < this.count - 1) 
				this.currentIndex++; 
			else 
				this.currentIndex = 0; 
		}
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
		visible: (listView.contentWidth > listView.width) && (listView.currentIndex != (listView.count - 1)) ? 1 : 0;
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

	Image {
		id: rightArrow;
		anchors.right: parent.right;
		anchors.rightMargin: 20;
        anchors.leftMargin: 10;
		anchors.verticalCenter: listView.verticalCenter;
		source: colorTheme.pathToStyleFolder + "/right.png";
		opacity: parent.activeFocus ? 1 : 0;
		visible: chooserItem.showArrows;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}
	
	function append(text, icon) {
		this.listView.model.append({"text": text, "icon": icon});
	}
}
