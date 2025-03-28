// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
	id: bigPlaybackIconProto;

	property bool showIcons;
	property bool showPause;
	property int playIconDisplayDuration: 800;

	Timer {
		id: playIconHideTimer;

		interval: bigPlaybackIconProto.playIconDisplayDuration;

		onTriggered: {
			playIcon.animationDuration = bigPlaybackIconProto.showPause ? 100 : bigPlaybackIconProto.showIcons ? 300 : 0;
			playIcon.opacity = 0;
		}
	}

	Image {
		id: pauseIcon;

		anchors.centerIn: parent;

		source: "res/common/player/big_pause.svg";

		visible: bigPlaybackIconProto.showPause && bigPlaybackIconProto.showIcons;
		opacity: visible ? 0.8 : 0;

		Behavior on opacity { animation: Animation { duration: 100; easingType: ui.Animation.EasingType.InOutQuad; } }

		onVisibleChanged: {
			if (visible)
				playIconHideTimer.stopAndTrigger();
			else if (bigPlaybackIconProto.showIcons)
			{
				playIcon.animationDuration = 100;
				playIcon.opacity = 0.8;
				playIconHideTimer.restart();
			}
		}
	}

	Image {
		id: playIcon;

		property int animationDuration;

		anchors.centerIn: parent;

		source: "res/common/player/big_play.svg";

		opacity: 0;

		Behavior on opacity { animation: Animation { duration: playIcon.animationDuration; easingType: ui.Animation.EasingType.InQuad; } }
	}

	onShowIconsChanged: {
		if (!showIcons)
			playIconHideTimer.stopAndTrigger();
	}
}
