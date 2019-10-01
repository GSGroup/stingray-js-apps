// Copyright (c) 2011 - 2019, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

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

	BodyText {
		id: buttonText;
		anchors.verticalCenter: parent.verticalCenter;
		x: simpleButton.textInCenter ? (parent.width - paintedWidth) / 2 : simpleButton.textRightOffset;
		opacity: simpleButton.enabled ? 1 : 0.4;
		color: parent.activeFocus ? colorTheme.focusedTextColor : colorTheme.activeTextColor;
		font: bodyFont;
		text: simpleButton.text;
		focus: true;

		Behavior on color { animation: Animation { duration: 300; } }
	}

	Behavior on color { animation: Animation { duration: 400; easingType: Linear; } }
}
