Rectangle {
	id: itemLevel;

	width: parent.cellWidth;
	height: parent.cellHeight;

	color: itemLevel.activeFocus ? colorTheme.activeFocusTop : colorTheme.nonFocusablePanelColor;

	SmallText {
		anchors.centerIn: itemLevel;

		color: itemLevel.activeFocus ? colorTheme.globalBackgroundColor : colorTheme.highlightPanelColor;

		text: model.text;
	}
}
