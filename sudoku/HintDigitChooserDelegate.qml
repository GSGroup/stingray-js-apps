Rectangle {
	width: parent.width;
	height: parent.width;

	focus: true;

	color: activeFocus ? colorTheme.activeBorderColor : colorTheme.backgroundColor;
	borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
	borderWidth: 2;

	Text {
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.verticalCenter: parent.verticalCenter;

		font: smallFont;
		color: parent.activeFocus ? colorTheme.activeTextColor : colorTheme.textColor;
		text: model.digit;
	}

	Behavior on color { animation: Animation { duration: 300; }}
}

