Rectangle {
	id: itemLevel;

	width: parent.cellWidth;
	height: parent.cellHeight;

	color: itemLevel.activeFocus ? colorTheme.activeFocusTop : colorTheme.nonFocusablePanelColor;

	BodyText {
		anchors.centerIn: levelRect;

		color: itemLevel.activeFocus ? colorTheme.globalBackgroundColor : colorTheme.highlightPanelColor;

		text: model.text;
	}
}
