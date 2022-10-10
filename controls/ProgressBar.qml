// Copyright (c) 2011 - 2022, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rectangle {
	id: progressBarItem;
	property bool active: true;
	property real progress: 0; // 0..1
	property Color barColor;
	property int animationDuration: 800;

	height: 15;
	color: active ? colorTheme.focusColor : "#000000";
	barColor: colorTheme.activeFocusTop;
	clip: true;
	radius: height / 2;

	Rectangle {
		id: filledArea;
		anchors.top: parent.top;
		anchors.left: parent.left;
		anchors.bottom: parent.bottom;
		width: parent.width * progressBarItem.progress;
		color: progressBarItem.active ? progressBarItem.barColor : colorTheme.borderColor;
		radius: progressBarItem.radius;

		Behavior on opacity { animation: Animation { duration: 500; } }
		Behavior on width { id: filledAreaWidthAnim; animation: Animation { duration: progressBarItem.animationDuration; } }
	}

	reset: { filledAreaWidthAnim.complete(); }
}
