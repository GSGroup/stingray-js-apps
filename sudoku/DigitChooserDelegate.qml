Rectangle {
	width: parent.width;
	height: parent.width;

	focus: true;

	color: activeFocus ? colorTheme.activeBorderColor : colorTheme.backgroundColor;
	borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
	borderWidth: 2;

	Text {
		anchors.centerIn: parent;

		font: bigFont;
		color: "#FFFFFF";
		text: model.digit;
	}

	Behavior on color {animation: Animation { duration: 300;}}
}
