SimpleChooserDelegate : Rectangle {
	color: activeFocus ? colorTheme.activeBorderColor : colorTheme.backgroundColor;
	borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
	width: delegateText.width + 20;
	height: 28;
	borderWidth: 2;
	radius: colorTheme.rounded ? 10 : 0;
	anchors.verticalCenter: parent.verticalCenter;
	focus: true;
	
	SmallText {
		id: delegateText;
		x: 10;
		anchors.verticalCenter: parent.verticalCenter;
		color: parent.activeFocus ? colorTheme.activeTextColor : parent.parent.focused ? colorTheme.textColor : colorTheme.disabledTextColor;
		text: model.text;
		
		Behavior on color { animation: Animation { duration: 200; } }
	}

	Behavior on color { animation: Animation { duration: 200; } }
	Behavior on borderColor { animation: Animation { duration: 200; } }
	Behavior on x { animation: Animation { duration: 400; easingType: Animation.OutCirc; } }
}

SimpleChooser : Item {
	id: chooserItem;
	property bool showArrows: true;
	property bool showAtCenter: true;
	property bool onlyOneItemVisible: true;
	height: 50;
	property alias currentIndex: listView.currentIndex;
	property alias count: listView.count;
	property int spacing: 5;
	
	Image {
		anchors.left: parent.left;
		anchors.verticalCenter: listView.verticalCenter;
		anchors.rightMargin: 8;
		source: "res/style/" + colorTheme.name + "/left.png";
		visible: chooserItem.showArrows;
		opacity: parent.activeFocus ? 1 : 0.3;
		width: 32;
		
		Behavior on opacity {
			animation: Animation {
				duration: 300;
			}
		}
	}
	
	ListView {
		id: listView;
		anchors.fill: parent;
		anchors.leftMargin: (chooserItem.showAtCenter ? Math.max((chooserItem.width - 60 - contentWidth) / 2, 0) : 0) + 30;
		anchors.rightMargin: 30;
		orientation: ListView.Horizontal;
		keyNavigationWraps: true;
		clip: true;
		delegate: SimpleChooserDelegate { }
		model: ListModel { }
		spacing: chooserItem.spacing;

		onCurrentIndexChanged: {
			postPositioningTimer.restart();
		}
	}
	
	Image {
		anchors.right: parent.right;
		anchors.verticalCenter: listView.verticalCenter;
		anchors.rightMargin: 8;
		source: "res/style/" + colorTheme.name + "/right.png";
		visible: chooserItem.showArrows;
		opacity: parent.activeFocus ? 1 : 0.3;
		width: 32;
		
		Behavior on opacity {
			animation: Animation {
				duration: 300;
			}
		}
	}

	Timer {
		id: postPositioningTimer; // delegate's widths calculate correctly after next tick
		interval: 100;

		onTriggered: {
			//listView->PositionViewAtIndex(listView->currentIndex);
		}
	}

	function append(text) {
		log("appending to chooser " + text);
		listView.model.append({"text": text});
	}
	
	Behavior on opacity {
		animation: Animation {
			duration: 300;
		}
	}
}