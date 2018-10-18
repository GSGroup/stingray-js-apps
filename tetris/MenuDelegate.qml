Item {
	id: itemMenu;

	width: parent.cellWidth;
	height: parent.cellHeight;

	anchors.horizontalCenter: parent.horizontalCenter;

	Rectangle {

		width: parent.width;
		height: parent.height * 2 / 3;

		anchors.centerIn: parent;

		color: parent.activeFocus ? colorTheme.activeFocusTop : colorTheme.nonFocusablePanelColor;

		Text {
			anchors.centerIn: parent;

			text: model.text;
			color: itemMenu.activeFocus ? colorTheme.globalBackgroundColor : colorTheme.highlightPanelColor;
			font: bodyFont;
		}
	}
}
