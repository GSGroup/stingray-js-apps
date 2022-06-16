// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rectangle {
	id: keyItem;

	property string text;

	height: 27;
	width: height;
	anchors.margins: 2;

	focus: true;
	color: activeFocus ? colorTheme.activeFocusColor : colorTheme.disabledBackgroundColor;
	radius: 5;

	borderWidth: 1;
	borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
	
	BodyText {
		id: buttonText;

		anchors.centerIn: parent;
		anchors.topMargin: 4; //need to fix fonts instead

		text: keyItem.text;
		color: parent.focused ? colorTheme.activeTextColor : colorTheme.textColor;
	}
}

