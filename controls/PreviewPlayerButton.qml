Rectangle { 
	width: 70;
	height: 70;
	color: activeFocus ? colorTheme.activeFocusColor : colorTheme.activePanelColor;

	Image {
		source: model.source;
		anchors.centerIn: parent;
		color: parent.activeFocus ? colorTheme.focusedTextColor : colorTheme.activeTextColor;
	}
}
