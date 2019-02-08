Rectangle {
	id: keyItem;

	property string text;

	height: 27;
	width: height;
	anchors.margins: 2;

	focus: true;
	color: activeFocus ? colorTheme.activeFocusColor : colorTheme.disabledBackgroundColor;
	radius: 5;

	borderWidth: 1;
	borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
	
	BodyText {
		id: buttonText;

		anchors.centerIn: parent;
		anchors.topMargin: 4; //need to fix fonts instead

		text: keyItem.text;
		color: parent.focused ? colorTheme.activeTextColor : colorTheme.textColor;
	}
}

