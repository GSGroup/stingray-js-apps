/******
*from controls/SimpleChooser.qml
******/
/*
PlayerChooserDelegate : Rectangle {
	color: focused ? colorTheme.activeBorderColor : colorTheme.backgroundColor;
	borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
	width: delegateText.width + 20;
	height: 28;
	anchors.verticalCenter: parent.verticalCenter;
	focus: true;
	
	SmallText {
		id: delegateText;
		x: 10;
		anchors.verticalCenter: parent.verticalCenter;
		color: parent.activeFocus ? colorTheme.activeTextColor : parent.parent.focused ? colorTheme.textColor : colorTheme.disabledTextColor;
		text: model.player;
		
		Behavior on color { animation: Animation { duration: 200; } }
	}

	Behavior on color { animation: Animation { duration: 200; } }
	Behavior on borderColor { animation: Animation { duration: 200; } }
	Behavior on x { animation: Animation { duration: 400; easingType: Animation.OutCirc; } }
}
*/

PlayerChooserDelegate : Item {
//	color: focused ? colorTheme.activeBorderColor : colorTheme.backgroundColor;
//	borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
	width: delegateText.width + 20;
	height: 28;
	anchors.verticalCenter: parent.verticalCenter;
	focus: true;
	
	SmallText {
		id: delegateText;
		x: 10;
		anchors.verticalCenter: parent.verticalCenter;
		color: parent.activeFocus ? colorTheme.activeTextColor : parent.parent.focused ? colorTheme.textColor : colorTheme.disabledTextColor;
		text: model.player;
		
		Behavior on color { animation: Animation { duration: 200; } }
	}
	
	Image {
		  
	}

	Behavior on x { animation: Animation { duration: 400; easingType: Animation.OutCirc; } }
}


DifficultyChooserDelegate : Rectangle {
	color: focused ? colorTheme.activeBorderColor : colorTheme.backgroundColor;
	borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
	width: delegateText.width + 20;
	height: 28;
	anchors.verticalCenter: parent.verticalCenter;
	focus: true;
	
	SmallText {
		id: delegateText;
		x: 10;
		anchors.verticalCenter: parent.verticalCenter;
		color: parent.activeFocus ? colorTheme.activeTextColor : parent.parent.focused ? colorTheme.textColor : colorTheme.disabledTextColor;
		text: model.name;
		
		Behavior on color { animation: Animation { duration: 200; } }
	}

	Behavior on color { animation: Animation { duration: 200; } }
	Behavior on borderColor { animation: Animation { duration: 200; } }
	Behavior on x { animation: Animation { duration: 400; easingType: Animation.OutCirc; } }
}

PlayerChooser : Item {
	id: pChooserItem;
	property bool showArrows: true;
	property bool showAtCenter: true;
	property bool onlyOneItemVisible: true;
	height: 50;
	property alias currentIndex: listView.currentIndex;
	property alias count: listView.count;
	property int spacing: 1;
	
	/*Image {
		anchors.left: parent.left;
		anchors.verticalCenter: listView.verticalCenter;
		anchors.rightMargin: 8;
		source: "res/style/" + colorTheme.name + "/left.png";
		visible: pChooserItem.showArrows;
		opacity: parent.activeFocus ? 1 : 0.3;
		width: 32;
		
		Behavior on opacity {
			animation: Animation {
				duration: 300;
			}
		}
	}*/
	
	ListView {
		id: listView;
		anchors.fill: parent;
		anchors.leftMargin: (pChooserItem.showAtCenter ? Math.max((pChooserItem.width - 60 - contentWidth) / 2, 0) : 0) + 30;
		anchors.rightMargin: 30;
		orientation: ListView.Horizontal;
		keyNavigationWraps: true;
		clip: true;
		delegate: PlayerChooserDelegate { }
		model: ListModel { }
		spacing: pChooserItem.spacing;

		onCurrentIndexChanged: {
			postPositioningTimer.restart();
		}
	}
	
	/*Image {
		anchors.right: parent.right;
		anchors.verticalCenter: listView.verticalCenter;
		anchors.rightMargin: 8;
		source: "res/style/" + colorTheme.name + "/right.png";
		visible: pChooserItem.showArrows;
		opacity: parent.activeFocus ? 1 : 0.3;
		width: 32;
		
		Behavior on opacity {
			animation: Animation {
				duration: 300;
			}
		}
	}*/

	Timer {
		id: postPositioningTimer; // delegate's widths calculate correctly after next tick
		interval: 100;

		onTriggered: {
			//listView->PositionViewAtIndex(listView->currentIndex);
		}
	}

	function append(obj) {
		log("appending to player chooser " );
		this.listView.model.append(obj);
	}
	
	Behavior on opacity {
		animation: Animation {
			duration: 300;
		}
	}
}

DifficultyChooser : Item {
	id: dChooserItem;
	property bool showArrows: true;
	property bool showAtCenter: true;
	property bool onlyOneItemVisible: true;
	height: 50;
	property alias currentIndex: listView.currentIndex;
	property alias count: listView.count;
	property int spacing: 1;
	
	/*Image {
		anchors.left: parent.left;
		anchors.verticalCenter: listView.verticalCenter;
		anchors.rightMargin: 8;
		source: "res/style/" + colorTheme.name + "/left.png";
		visible: dChooserItem.showArrows;
		opacity: parent.activeFocus ? 1 : 0.3;
		width: 32;
		
		Behavior on opacity {
			animation: Animation {
				duration: 300;
			}
		}
	}*/
	
	ListView {
		id: listView;
		anchors.fill: parent;
		anchors.leftMargin: (dChooserItem.showAtCenter ? Math.max((dChooserItem.width - 60 - contentWidth) / 2, 0) : 0) + 30;
		anchors.rightMargin: 30;
		orientation: ListView.Horizontal;
		keyNavigationWraps: true;
		clip: true;
		delegate: DifficultyChooserDelegate { }
		model: ListModel { }
		spacing: dChooserItem.spacing;

		onCurrentIndexChanged: {
			postPositioningTimer.restart();
		}
	}
	
/*	Image {
		anchors.right: parent.right;
		anchors.verticalCenter: listView.verticalCenter;
		anchors.rightMargin: 8;
		source: "res/style/" + colorTheme.name + "/right.png";
		visible: dChooserItem.showArrows;
		opacity: parent.activeFocus ? 1 : 0.3;
		width: 32;
		
		Behavior on opacity {
			animation: Animation {
				duration: 300;
			}
		}
	}*/

	Timer {
		id: postPositioningTimer; // delegate's widths calculate correctly after next tick
		interval: 100;

		onTriggered: {
			//listView->PositionViewAtIndex(listView->currentIndex);
		}
	}

	function append(obj) {
		log("appending to difficulty chooser " );
		this.listView.model.append(obj);
	}
	
	Behavior on opacity {
		animation: Animation {
			duration: 300;
		}
	}
}
