import BigText;

Item {
	 id: fsTimerItem;
	 property int sec:0;

	 BigText {
		 id: timerDecMinutes;
		 anchors.right: timerCenter.left;
		 anchors.rightMargin: 25;
		 color: "#813722" ;
		 style: Shadow;
		 text: Math.floor(fsTimerItem.sec/600);
	 }

	 BigText {
		 id:timerMinutes;
		 anchors.right: timerCenter.left;
		 anchors.rightMargin: 5;
		 color: "#813722" ;
		 style: Shadow;
		 text: Math.floor(fsTimerItem.sec/60)%10;
	 }

	 BigText {
		 id: timerCenter;
		 color: "#813722";
		 style: Shadow;
		 text: ":";
	 }

	 BigText {
		 id:timerDecSeconds;
		 anchors.left: timerCenter.right;
		 anchors.leftMargin: 5;
		 color: "#813722" ;
		 style: Shadow;
		 text: Math.floor(fsTimerItem.sec%60/10);
	 }

	 BigText {
		 id:timerSeconds;
		 anchors.left: timerCenter.right;
		 anchors.leftMargin: 25;
		 color: "#813722" ;
		 style: Shadow;
		 text: (fsTimerItem.sec%60)%10;
	 }

}
