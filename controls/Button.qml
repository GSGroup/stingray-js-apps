// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

ActivePanel {
	id: buttonProto;

	property variant font: bodyFont;
	property string icon;
	property string text;

	property Color textColor: activeFocus ? colorTheme.focusedTextColor : colorTheme.activeTextColor;
	property int contentMargin: 12hpw;

	enum { Right, Center, Left };
	property int contentAlignment: Center;

	width: Math.max(176hpw, iconTextItem.width + contentMargin * 2);
	height: 53hph;

	nonFocusColor: colorTheme.buttonColor;

	Row {
		id: iconTextItem;

		x: buttonProto.contentAlignment == buttonProto.Center ? (parent.width - width) / 2 :
				buttonProto.contentAlignment == buttonProto.Left ? buttonProto.contentMargin :
				parent.width - width - buttonProto.contentMargin;

		focus: true;
		spacing: 12hpw;

		Image {
			id: buttonIcon;

			width: 34hpw;
			height: 34hph;

			anchors.verticalCenter: buttonProto.verticalCenter;

			source: buttonProto.icon;

			color: buttonProto.textColor;

			visible: source != "";
		}

		Text {
			id: buttonText;

			anchors.verticalCenter: buttonProto.verticalCenter;

			text: buttonProto.text;
			font: buttonProto.font;
			color: buttonProto.textColor;
		}
	}
}
