// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
	id: movingArrowsProto;

	property bool showArrows;
	property bool showUpArrow: true;
	property bool showDownArrow: true;

	property int arrowHeight: upArrow.height + upArrow.anchors.bottomMargin;

	anchors.fill: parent;

	opacity: showArrows ? 1 : 0;

	Image {
		id: upArrow;

		anchors.bottom: parent.top;
		anchors.bottomMargin: 5hph;
		anchors.horizontalCenter: parent.horizontalCenter;

		source: colorTheme.pathToStyleFolder + "/up.svg";

		color: colorTheme.activeTextColor;

		opacity: movingArrowsProto.showUpArrow ? 1 : 0;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}

	Image {
		anchors.top: parent.bottom;
		anchors.topMargin: 5hph;
		anchors.horizontalCenter: parent.horizontalCenter;

		source: colorTheme.pathToStyleFolder + "/down.svg";

		color: colorTheme.activeTextColor;

		opacity: movingArrowsProto.showDownArrow ? 1 : 0;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}

	Behavior on opacity { animation: Animation { duration: 300; } }
}
