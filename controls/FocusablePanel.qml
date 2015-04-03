Rectangle {
	height: 46;
	focus: true;
	property bool active: activeFocus;
	color: active ? colorTheme.activePanelColor : colorTheme.focusablePanelColor;
	borderWidth: 2;
	borderColor: active ? colorTheme.activeBorderColor : colorTheme.borderColor;

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
