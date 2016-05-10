import controls.SmallText;

Item {
	width: 20 + chooserDelegateText.width * chooserDelegateText.visible + chooserIcon.width * chooserIcon.visible + (chooserIcon.visible && chooserDelegateText.visible) * 10;
	height: parent.height;
	
	Image {
		id: chooserIcon;
		source: model.icon;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.left: parent.left;
		anchors.leftMargin: 10;
		anchors.topMargin: 10;
		anchors.bottomMargin: 10;
		anchors.top: parent.top;
		anchors.bottom: parent.bottom;
		fillMode: PreserveAspectFit;
		opacity: parent.focused ? 1 : 0.65;
		visible: model.icon != undefined ? source != "" : false;
		
		Behavior on opacity { animation: Animation { duration: 300; } }
	}
	
	SmallText {
		id: chooserDelegateText;
		text: model.text;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.right: parent.right;
		anchors.rightMargin: 10;
		color: parent.parent.activeFocus ? colorTheme.focusedTextColor : parent.focused ? colorTheme.activeTextColor : colorTheme.textColor;
		opacity: parent.focused ? 1 : 0.65;
		visible: model.text != undefined ? text != "" : false;
		
		Behavior on color { animation: Animation { duration: 300; } }
		Behavior on opacity { animation: Animation { duration: 300; } }
	}
}
