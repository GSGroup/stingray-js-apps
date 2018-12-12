Rectangle { 
	width: 70;
	height: 70;

	focus: true;

	color: activeFocus ? colorTheme.activeFocusColor : colorTheme.activePanelColor;

	Image {
		source: model.source;
		anchors.centerIn: parent;
		color: parent.activeFocus ? colorTheme.focusedTextColor : colorTheme.activeTextColor;
	}
}
