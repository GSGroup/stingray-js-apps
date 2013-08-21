SamsListView : ListView {
	id: samsListViewItem;

	keyNavigationWraps: false;
	positionMode: ListView.Center;
	anchors.topMargin: (samsListViewItem.pullLenght * samsListViewItem.pullDown) + Math.max(samsListViewItem.topMargin - samsListViewItem.contentY, 0);

	property int pullDown;
	property int pullLenght: 50;
	property int topMargin;

	Timer {
		id: pullTimer;
		interval: 400;

		onTriggered: {
			samsListViewItem.pullDown = 0;
		}
	}
	
	onUpPressed: {
		if (this.count == 0)
			return false;

		if (this.currentIndex == 0) {
			samsListViewItem.pullDown = 2;
			pullTimer.restart();
			return true;
		}

		this.currentIndex--;
	}
	
	onDownPressed: {
		if (this.count == 0)
			return false;

		if (this.currentIndex == this.count - 1) {
			pullTimer.restart();
			this.pullDown = -2;
			return true;
		}

		this.currentIndex++;
	}
		
	Behavior on y { animation: Animation { duration: 250; } }
	//Behavior on height { animation: Animation { duration: 250; } }
}
