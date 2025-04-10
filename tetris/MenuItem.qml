// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rectangle {
	id: itemRect;

	property alias menuText: textItem.text;

	height: 53hph;

	color: itemRect.activeFocus ? colorTheme.activeFocusColor : colorTheme.buttonColor;
	focus: true;

	BodyText {
		id: textItem;

		anchors.centerIn: itemRect;

		color: itemRect.activeFocus ? colorTheme.focusedTextColor : colorTheme.activeTextColor;
	}

	BorderShadow3D {
		anchors.fill: itemRect;

		opacity: itemRect.activeFocus;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}
}
