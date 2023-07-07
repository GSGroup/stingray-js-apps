// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

BodyText {
	property int milliseconds;

	property int hours: milliseconds / 3600000;
	property int minutes: milliseconds % 3600000 / 60000;
	property int seconds: milliseconds % 60000 / 1000;

	property string minSec: (minutes > 9 ? minutes : "0" + minutes) + ":" + (seconds > 9 ? seconds : "0" + seconds);

	property int hmWidth;
	property int hmsWidth;

	property bool showHours: hours > 0;

	width: showHours ? hmsWidth : hmWidth;

	color: colorTheme.activeTextColor;
	text: showHours ? (hours > 9 ? hours : "0" + hours) + ":" + minSec : minSec;

	onCompleted: {
		this.hmWidth = this.font.getTextRect("88:88").Width();
		this.hmsWidth = this.font.getTextRect("88:88:88").Width();
	}
}
