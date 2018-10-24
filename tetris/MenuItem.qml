Rectangle {
	id: itemRect;

	property string menuText: " ";

	color: itemRect.activeFocus ? colorTheme.activeFocusTop : colorTheme.nonFocusablePanelColor;

	BodyText {
		id: textItem;

		anchors.centerIn: itemRect;

		color: itemRect.activeFocus ? colorTheme.globalBackgroundColor : colorTheme.highlightPanelColor;
		text: itemRect.menuText;
	}
}
