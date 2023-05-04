// Copyright (c) 2011 - 2022, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "SpinnerRectangle.qml";

Row {
	id: spinnerProto;

	property int interval: 300;
	property int delayedTicks: 1;

	property Color color: colorTheme.activeFocusColor;

	width: (height * 3) + spacing * 2;
	height: 24hph;

	spacing: 6hpw;
	collapseEmptyItems: false;

	Timer {
		property int activeCircle;

		interval: spinnerProto.interval;
		running: spinnerProto.visible;
		repeat: true;

		onTriggered: {
			this.activeCircle = (this.activeCircle + 1) % (spinnerProto.children.length + spinnerProto.delayedTicks);
			if (this.activeCircle < spinnerProto.children.length)
				spinnerProto.children[this.activeCircle].fadeIn();
		}
	}

	SpinnerRectangle {
		height: spinnerProto.height;

		color: spinnerProto.color;
	}

	SpinnerRectangle {
		height: spinnerProto.height;

		color: spinnerProto.color;
	}

	SpinnerRectangle {
		height: spinnerProto.height;

		color: spinnerProto.color;
	}
}
