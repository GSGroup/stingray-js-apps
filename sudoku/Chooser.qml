/******
*from controls/SimpleChooser.qml
******/

PlayerChooserDelegate : Item {
	width: 99;
	height: 28;

	anchors.verticalCenter: parent.verticalCenter;
	focus: true;

	Image {
		id:pcDelegateImgage;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.verticalCenter: parent.verticalCenter;
		source: "apps/sudoku/img/btn_set_"+(parent.activeFocus? "focus": (parent.focused?"selected":"regular"))+".png";
	}

	SmallText {
		id: delegateText;
		x: 10;
//		anchors.left: parent.left;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.horizontalCenter: parent.horizontalCenter;
//		color: parent.activeFocus ? colorTheme.activeTextColor : parent.parent.focused ? colorTheme.textColor : colorTheme.disabledTextColor;
		color: "#581B18";
		text: model.player;
		
		Behavior on color { animation: Animation { duration: 200; } }
	}

	Behavior on x { animation: Animation { duration: 400; easingType: Animation.OutCirc; } }
}

DifficultyChooserDelegate : Item {
	width: 99;
	height: 28;
	anchors.verticalCenter: parent.verticalCenter;
	focus: true;

	Image {
		id:dcDelegateImgage;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.verticalCenter: parent.verticalCenter;
		source: "apps/sudoku/img/btn_set_"+(parent.activeFocus? "focus": (parent.focused?"selected":"regular"))+".png";
	}

	SmallText {
		id: delegateText;
		x: 10;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.horizontalCenter: parent.horizontalCenter;
//		color: parent.activeFocus ? colorTheme.activeTextColor : parent.parent.focused ? colorTheme.textColor : colorTheme.disabledTextColor;
		color: "#581B18";
		text: model.name;
		
		Behavior on color { animation: Animation { duration: 200; } }
	}

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
		spacing: 1 ;

		onCurrentIndexChanged: {
			postPositioningTimer.restart();
		}
	}

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
