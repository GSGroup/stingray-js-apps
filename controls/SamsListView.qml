SamsListView : ListView {
	id: samsListViewItem;
	
	//keyNavigationWraps: false;
	//positionMode: this.Center;
	//anchors.topMargin: ((samsListViewItem.pullLenght) * samsListViewItem.pullDown) + Math.max(samsListViewItem.topMargin - samsListViewItem.contentY, 0);
	
	//property int pullDown;
	//property int pullLenght;
	//property int topMargin;
	//pullLenght: 50;
	//pullDown: 0; 
	
	//Timer {
		//id: pullTimer;
		//interval: 400;

		//onTriggered: {
			//samsListViewItem.pullDown = 0;
		//}
	//}
	
	//onUpPressed: {
		//if (count == 0)
			//return false;

		//if (currentIndex == 0) {
			//pullTimer.Restart();
			//pullDown = 2;
			//return true;
		//}
	//}
	
	//onDownPressed: {
		//if (count == 0)
			//return false;

		//if (currentIndex == this.count - 1) {
			//pullTimer.Restart();
			//pullDown = -2;
			//return true;
		//}
	//}
		
	//Behavior on contentX { animation: Animation { duration: 400; } }
	//Behavior on contentY { animation: Animation { duration: 400; } }
	//Behavior on y { animation: Animation { duration: 250; } }
	//Behavior on height { animation: Animation { duration: 250; } }
}
