import DifficultyChooserDelegate

Item {
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
