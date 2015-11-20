Rectangle {
	property bool active: activeFocus;
	height: 46;
	color: active ? colorTheme.activeFocusColor : colorTheme.focusablePanelColor;
	focus: true;
	radius: 3;

	Behavior on color { animation: Animation { duration: 300; } }
	Behavior on borderColor { animation: Animation { duration: 300; } }
}
