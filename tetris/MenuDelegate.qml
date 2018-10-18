Rectangle {
	id: itemRect;

	width: itemMenu.width;
	height: itemMenu.height * 2 / 3;

	anchors.centerIn: itemMenu;

	color: itemMenu.activeFocus ? colorTheme.activeFocusTop : colorTheme.nonFocusablePanelColor;

	BodyText {
		id: textItem;

		anchors.centerIn: itemRect;

		color: itemMenu.activeFocus ? colorTheme.globalBackgroundColor : colorTheme.highlightPanelColor;
		text: model.text;
	}
}
