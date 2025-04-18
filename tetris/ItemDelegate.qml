// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "generated_files/tetrisConsts.js" as gameConsts;

Delegate {
	id: itemDelegate;

	property int animationDuration: 0;

	width: gameConsts.getBlockSize();
	height: gameConsts.getBlockSize();

	focus: true;

	opacity: model.value === 0 ? 0.0 : 1.0;

	Rectangle {
		anchors.fill: parent;

		color: "#0000";

		Rectangle {
			anchors.centerIn: parent;

			width: model.width;
			height: model.width;

			color: gameConsts.getColor(model.colorIndex);

			visible: model.value > 0;

			Behavior on width { animation: Animation { id: widthAnimation; duration: itemDelegate.animationDuration; easingType: ui.Animation.EasingType.OutCirc; } }
			Behavior on height { animation: Animation { id: heightAnimation; duration: itemDelegate.animationDuration; easingType: ui.Animation.EasingType.OutCirc; } }
		}
	}
}
