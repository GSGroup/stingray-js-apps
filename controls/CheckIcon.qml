// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
	id: checkIconProto;

	property Color color: checked ? colorTheme.accentGreenColor : colorTheme.activeTextColor;
	property bool checked;
	property int duration: 300;

	width: 60hpw;
	height: 24hph;

	Rectangle {
		id: checkIconRect;

		anchors.fill: parent;

		color: checkIconProto.color;
		radius: height / 2;

		opacity: checkIconProto.checked ? 1.0 : 0.3;

		Behavior on color { animation: Animation { id: checkIconRectColorAnimation; duration: checkIconProto.duration; easingType: ui.Animation.EasingType.InOutCirc; } }
	}

	Image {
		id: checkImage;

		width: 40hpw;
		height: width;

		x: checkIconProto.checked ? (checkIconProto.width - checkImage.width + 6hpw) : -5hpw;

		anchors.verticalCenter: checkIconRect.verticalCenter;

		sourceWidth: width;
		sourceHeight: height;

		source: "res/common/checkbox.svg";

		fillMode: ui.Image.FillMode.Stretch;

		Behavior on x { animation: Animation { id: checkImageXAnimation; duration: checkIconProto.duration; easingType: ui.Animation.EasingType.InOutCirc; } }
	}

	completeAnimation: {
		checkIconRectColorAnimation.complete();
		checkImageXAnimation.complete();
	}
}
