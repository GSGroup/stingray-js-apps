// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

ActivePanel {
	id: simpleButton;

	property alias font: buttonText.font;
	property string icon;
	property string text;

	property Color textColor: activeFocus ? colorTheme.focusedTextColor : colorTheme.activeTextColor;
	property int contentMargin: 12;
	property bool textInCenter: true;

	width: Math.max(176hpw, iconTextItem.width + contentMargin * 2);
	height: 53;

	nonFocusColor: colorTheme.buttonColor;

	Row {
		id: iconTextItem;

		x: simpleButton.textInCenter ? (parent.width - width) / 2 : simpleButton.contentMargin;

		focus: true;
		spacing: 12;

		Image {
			id: buttonIcon;

			width: 34hpw;
			height: 34;

			anchors.verticalCenter: simpleButton.verticalCenter;

			source: simpleButton.icon;

			color: simpleButton.textColor;

			visible: source != "";
		}

		BodyText {
			id: buttonText;

			anchors.verticalCenter: simpleButton.verticalCenter;

			text: simpleButton.text;

			color: simpleButton.textColor;
		}
	}
}
