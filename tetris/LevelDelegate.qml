Item {
	id: itemLevel;

	width: parent.cellWidth;
	height: parent.cellHeight;

	Rectangle {
		id: levelRect;

		width: parent.cellWidth;
		height: parent.cellHeight;

		anchors.fill: parent;

		color: itemLevel.activeFocus ? colorTheme.activeFocusTop : colorTheme.nonFocusablePanelColor;

		Text {
			anchors.centerIn: parent;

			color: itemLevel.activeFocus ? colorTheme.globalBackgroundColor : colorTheme.highlightPanelColor;
			font: bodyFont;

			text: model.text;
		}
	}
}
