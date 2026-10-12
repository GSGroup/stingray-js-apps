// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rectangle {
	height: 55hph;

	color: colorTheme.focusablePanelColor;
	opacity: enabled ? 1 : 0.3;

	Behavior on opacity { animation: Animation { id: opacityAnimation; duration: 300; } }
	Behavior on color { animation: Animation { id: colorAnimation; duration: 300; } }

	completePanelAnimation: {
		opacityAnimation.complete();
		colorAnimation.complete();
	}

	completeAnimation: { this.completePanelAnimation(); }
}
