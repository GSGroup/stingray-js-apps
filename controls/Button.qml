import controls.FocusablePanel;

Button : FocusablePanel {
	id: simpleButton;

	property string text;
	property alias textColor: buttonText.color;
	property alias font: buttonText.font;

	property int textRightOffset: textInCenter ? 0 : 20;
	property bool textInCenter: true;

	width: Math.max(140, buttonText.width + 30);

	SmallText {
		id: buttonText;
		anchors.verticalCenter: parent.verticalCenter;
		x: simpleButton.textInCenter ? (parent.width - paintedWidth) / 2 : simpleButton.textRightOffset;
		opacity: simpleButton.enabled ? 1 : 0.4;
		color: parent.activeFocus ? colorTheme.activeTextColor : colorTheme.textColor;
		style: Shadow;
		font: smallFont;
		text: simpleButton.text;
		focus: true;

		Behavior on color {
			animation: Animation {
				duration: 300;
			}
		}
		
		onSelectPressed: {
			simpleButton.color = colorTheme.activeBorderColor;
			//simpleButton.color.ResetAnimation();
			simpleButton.color = colorTheme.activeBackgroundColor;
			return false;
		}
	}

	Behavior on color { animation: Animation { duration: 400; easingType: Linear; } }
}
