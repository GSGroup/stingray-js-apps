Item {
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

	BodyText {
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

