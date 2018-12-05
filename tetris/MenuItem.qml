Rectangle {
	id: itemRect;

	property alias menuText: textItem.text;

	width: 244;
	height: 41;

	color: itemRect.activeFocus ? colorTheme.activeFocusTop : colorTheme.nonFocusablePanelColor;
	focus: true;

	SmallText {
		id: textItem;

		anchors.centerIn: itemRect;

		color: itemRect.activeFocus ? colorTheme.globalBackgroundColor : colorTheme.highlightPanelColor;
	}
}
