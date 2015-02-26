Rectangle {

	height: 46;
	focus: true;
	property bool active: activeFocus;
	color: active ? colorTheme.activePanelColor : colorTheme.focusablePanelColor;

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
