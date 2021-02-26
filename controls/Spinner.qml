// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "SpinnerRectangle.qml";

Item {
	id: spinner;
	width: radius * 2;
	height: width;

	property int activeSpinner: 0;
	property int radius: 45;
	property int circlesRadius: 12;
	property int circlesCount: 8;
	property int interval: 100;

	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}

	function UpdateRectangle() {
		var o = 1;
		for (var i = this.activeSpinner; o >= 0; i = i === 0 ? spinner.circlesCount - 1 : i-1, o -= 0.15) {
			this.children[i].active = o;
		}
	}

	Timer {
		id: spinnerUpdateTimer;

		interval: spinner.interval;
		repeat: true;

		onTriggered: {
			spinner.activeSpinner = (spinner.activeSpinner + 1) % (spinner.circlesCount);
			spinner.UpdateRectangle();
		}
	}

	onVisibleChanged: {
		if (this.visible) {
			spinnerUpdateTimer.restart();
		} else {
			spinnerUpdateTimer.stop();
		}
	}

	onCompleted: {
		for (var i = 0; i < this.circlesCount; i ++) {
			this.children[i].radius = this.circlesRadius;
			this.children[i].x = Math.cos(Math.PI * i / this.circlesCount * 2) * (this.radius - this.circlesRadius) - this.circlesRadius + this.radius;
			this.children[i].y = Math.sin(Math.PI * i / this.circlesCount * 2) * (this.radius - this.circlesRadius) - this.circlesRadius + this.radius;
			this.children[i].active = 0;
		}
	}
}
