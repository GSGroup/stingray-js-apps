import controls.FocusablePanel;
import controls.SmallText;

ActivePanel {
	id: simpleButton;
	property string text;
	property alias textColor: buttonText.color;
	property alias font: buttonText.font;
	property int textRightOffset: textInCenter ? 0 : 20;
	property bool textInCenter: true;
	height: buttonText.paintedHeight + 30;
	width: Math.max(140, buttonText.width + 30);
	radius: 3;

	SmallText {
		id: buttonText;
		anchors.verticalCenter: parent.verticalCenter;
		x: simpleButton.textInCenter ? (parent.width - paintedWidth) / 2 : simpleButton.textRightOffset;
		opacity: simpleButton.enabled ? 1 : 0.4;
		color: parent.activeFocus ? colorTheme.focusedTextColor : colorTheme.activeTextColor;
		font: smallFont;
		text: simpleButton.text;
		focus: true;

		Behavior on color { animation: Animation { duration: 300; } }
	}

	Behavior on color { animation: Animation { duration: 400; easingType: Linear; } }
}
