// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
	id: progressBarProto;

	property bool active;

	property real progress: 0; // 0..1
	property bool discreteProgress;

	property int widthAnimationDuration: 800;
	property int colorAnimationDuration: 0;

	property int radius;

	property Color color;
	property Color barColor;

 	height: 5hph;

	Rectangle {
		id: backgroundRect;

		width: parent.width;
		height: parent.height;

		radius: progressBarProto.radius;

		color: progressBarProto.color;

		opacity: 0.3;

		Behavior on color { id: backgroundRectColorAnimation; animation: Animation { duration: progressBarProto.colorAnimationDuration; } }
	}

	Rectangle {
		id: filledArea;

		property real progress: Math.min(1.0, Math.max(0.0, progressBarProto.progress));

		width: !progressBarProto.discreteProgress ? parent.width * progress :
				progress <= 0.5 ? Math.ceil(parent.width * progress) : Math.floor(parent.width * progress);
		height: parent.height;

		radius: progressBarProto.radius;

		color: progressBarProto.barColor;

		Behavior on width { id: filledAreaWidthAnimation; animation: Animation { duration: progressBarProto.widthAnimationDuration; } }
		Behavior on color { id: filledAreaColorAnimation; animation: Animation { duration: progressBarProto.colorAnimationDuration; } }
	}

	resetAnimation: {
		backgroundRectColorAnimation.complete();

		filledAreaColorAnimation.complete();
		filledAreaWidthAnimation.complete();
	}
}
