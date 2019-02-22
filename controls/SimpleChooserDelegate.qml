Rectangle {
	color: activeFocus ? colorTheme.activeBorderColor : colorTheme.backgroundColor;
	borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
	width: delegateText.width + 20;
	height: 28;
	borderWidth: 2;
	radius: colorTheme.rounded ? 10 : 0;
	anchors.verticalCenter: parent.verticalCenter;
	focus: true;
	
	BodyText {
		id: delegateText;
		x: 10;
		anchors.verticalCenter: parent.verticalCenter;
		color: parent.activeFocus ? colorTheme.activeTextColor : parent.parent.focused ? colorTheme.textColor : colorTheme.disabledTextColor;
		text: model.text;
		
		Behavior on color { animation: Animation { duration: 200; } }
	}

	Behavior on color { animation: Animation { duration: 200; } }
	Behavior on borderColor { animation: Animation { duration: 200; } }
	Behavior on x { animation: Animation { duration: 400; easingType: ui.Animation.OutCirc; } }
}
