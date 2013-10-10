FocusablePanel : Rectangle {
	property bool enabled: true;

	height: 46;
	color: enabled ? activeFocus ? colorTheme.activeBackgroundColor : colorTheme.backgroundColor : colorTheme.disabledBackgroundColor;
	borderColor: enabled ? activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor : colorTheme.disabledBorderColor;
	borderWidth: 2;
	radius: colorTheme.rounded ? height/2 : 0;
	focus: true;

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
