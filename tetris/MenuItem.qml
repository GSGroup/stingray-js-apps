Rectangle {
	id: itemRect;

	property alias menuText: textItem.text;

	width: 240;
	height: 30;

	color: itemRect.activeFocus ? colorTheme.activeFocusTop : colorTheme.nonFocusablePanelColor;
	focus: true;

	BodyText {
		id: textItem;

		anchors.centerIn: itemRect;

		color: itemRect.activeFocus ? colorTheme.globalBackgroundColor : colorTheme.highlightPanelColor;
	}
}
