// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Delegate {
	id: passwordEditDelegateProto;

	property bool editing;
	property bool filled: model.filled;
	property bool colorAnimable;

	width: 12hpw;
	height: 12hph;

	opacity: filled ? 1.0 : 0.2;

	Rectangle {
		anchors.fill: parent;

		radius: height / 2;

		color: passwordEditDelegateProto.editing ? colorTheme.focusedTextColor : colorTheme.activeTextColor;

		Behavior on color { animation: Animation { duration: passwordEditDelegateProto.colorAnimable ? 300 : 0; } }
	}
}
