// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "SpinnerRectangle.qml";

Row {
	id: spinner;
	width: radius * 2;
	height: width;

	property int activeSpinner: 0;
	property int radius: 45;
	property int circlesRadius: 12;
	property int circlesCount: 3;
	property int interval: 100;
	property int delayedTicks: 1;

	SpinnerRectangle{}
	SpinnerRectangle{}
	SpinnerRectangle{}

	Timer {
		id: spinnerUpdateTimer;

		property int activeCircle;

		interval: spinner.interval;
		running: spinner.visible;
		repeat: true;

		onTriggered: {
			this.activeCircle = (this.activeCircle + 1) % (spinner.children.length + spinner.delayedTicks);
			if (this.activeCircle < spinner.children.length)
				spinner.children[this.activeCircle].fadeIn();
		}
	}
}
