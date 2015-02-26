BorderedImage : Panel {
	borderWidth: 1;
	borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.disabledBorderColor;
	width: 70;
	height: 70;

	SelectionGradient {
//		anchors.centerIn: parent;
		anchors.margins: 1;
		opacity: parent.activeFocus ? 1 : 0;
	}
	
	Image {
		anchors.centerIn: parent;
		source: model.source;
	}

}
