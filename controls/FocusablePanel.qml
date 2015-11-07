Rectangle {
	height: 46;
	property bool active: activeFocus;
	color: active ? colorTheme.activePanelColor : colorTheme.focusablePanelColor;
	focus: true;
	radius: 3;

	Behavior on color {
		animation: Animation {
			duration: 300;
		}
	}

	Behavior on borderColor {
		animation: Animation {
			duration: 300;
		}
	}
}
