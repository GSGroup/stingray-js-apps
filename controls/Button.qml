// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

ActivePanel {
	id: simpleButton;

	property alias textColor: buttonText.color;
	property alias font: buttonText.font;

	property string text;
	property int textRightOffset: textInCenter ? 0 : 20;
	property bool textInCenter: true;

	width: Math.max(140, buttonText.width + 30);
	height: buttonText.paintedHeight + 30;

	radius: 3;

	BodyText {
		id: buttonText;

		x: simpleButton.textInCenter ? (parent.width - paintedWidth) / 2 : simpleButton.textRightOffset;

		anchors.verticalCenter: parent.verticalCenter;

		color: parent.activeFocus ? colorTheme.focusedTextColor : colorTheme.activeTextColor;
		text: simpleButton.text;

		focus: true;

		Behavior on color { animation: Animation { duration: 300; } }
	}

	Behavior on color { animation: Animation { duration: 400; easingType: Linear; } }
}
