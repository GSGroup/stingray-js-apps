// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "PlaybackProgressDurationText.qml";
import "ProgressBar.qml";
import "TopLabel.qml";

Item {
	id: playbackProgressItem;

	signal togglePause;
	signal seek(position);

	property bool disableAutoShow;
	property bool showControls: true;

	property int duration;
	property int progress;
	property int barProgress: gear == 0 && !postSeekTimer.running ? progress : seekProgress;
	property int seekProgress;

	property int gear;

	property bool isPlaying;

	property string text;
	property string additionalText;

	focus: true;

	opacity: visible ? 1 : 0;

	Timer {
		id: hideTimer;

		running: playbackProgressItem.visible;
		interval: 5000;

		onTriggered: { playbackProgressItem.visible = false; }
	}

	Timer {
		id: seekTimer;

		interval: 2000;

		onTriggered: {
			if (playbackProgressItem.gear != 0)
				playbackProgressItem.seek(playbackProgressItem.seekProgress);

			postSeekTimer.restart();
			playbackProgressItem.gear = 0;
		}
	}

	Timer {
		id: postSeekTimer;

		interval: 500;
	}

	TopLabel {
		text: playbackProgressItem.text;
		additionalText: playbackProgressItem.additionalText;
	}

	Gradient {
		height: safeAreaManager.bottomMargin + 120hph;

		anchors.left: mainWindow.left;
		anchors.right: mainWindow.right;
		anchors.bottom: mainWindow.bottom;

		GradientStop {
			position: 0;
			color: "#0000";
		}

		GradientStop {
			position: 1;
			color: "#000";
		}
	}

	PlaybackProgressDurationText {
		id: currentProgressText;

		property int hoursWidth;

		anchors.left: parent.left;
		anchors.leftMargin: 10hpw + durationText.showHours && !currentProgressText.showHours ? currentProgressText.hoursWidth : 0;
		anchors.verticalCenter: progressBar.verticalCenter;

		milliseconds: playbackProgressItem.progress;

		visible: progressBar.visible && playbackProgressItem.duration > 0;

		onCompleted: { this.hoursWidth = this.font.getTextRect("88:").Width(); }
	}

	ProgressBar {
		id: progressBar;

		property int maxSliderHeight: 33hph;
		property int sliderMargin: 6hph;

		anchors.left: currentProgressText.right;
		anchors.leftMargin: 24hpw;
		anchors.right: durationText.left;
		anchors.rightMargin: 24hpw;
		anchors.bottom: seekProgressText.top;
		anchors.bottomMargin: progressBar.sliderMargin + progressBar.maxSliderHeight / 2 - progressBar.height / 2;

		active: activeFocus;
		progress: playbackProgressItem.duration > 0 ? 1.0 * playbackProgressItem.barProgress / playbackProgressItem.duration : 0;
		widthAnimationDuration: 0;

		colorAnimationDuration: 250;

		color: colorTheme.activeTextColor;
		barColor: active ? colorTheme.activeFocusColor : colorTheme.activeTextColor;

		focus: visible;

		visible: playbackProgressItem.showControls;

		onKeyPressed: {
			if (key == "Select" || key == "Pause")
			{
				hideTimer.restart();

				if (seekTimer.running)
				{
					seekTimer.stopAndTrigger();

					if (key == "Pause")
						playbackProgressItem.togglePause();
				}
				else
				{
					playbackProgressItem.resetSeek();
					playbackProgressItem.togglePause();
				}

				progressBar.resetAnimation();

				return true;
			}
		}

		onLeftPressed: { playbackProgressItem.rewind(); }
		onRightPressed: { playbackProgressItem.fastForward(); }

		onWidthChanged: { progressBar.resetAnimation(); }
		onActiveFocusChanged: { hideTimer.restart(); }
	}

	Rectangle {
		id: sliderRect;

		width: height;
		height: progressBar.active ? progressBar.maxSliderHeight : 13hph;

		radius: height / 2;

		anchors.left: progressBar.filledArea.right;
		anchors.leftMargin: -sliderRect.width / 2;
		anchors.verticalCenter: progressBar.filledArea.verticalCenter;

		color: progressBar.barColor;

		visible: progressBar.visible;

		Image {
			id: playbackImage;

			anchors.centerIn: parent;

			color: colorTheme.focusedTextColor;

			source: playbackProgressItem.gear > 0 ? "res/apps/infopanel/playback/forward.svg" :
					playbackProgressItem.gear < 0 ? "res/apps/infopanel/playback/rewind.svg" :
					playbackProgressItem.isPlaying ? "res/apps/infopanel/playback/pause.svg" :
					"res/apps/infopanel/playback/play.svg";

			visible: progressBar.active;
		}
	}

	PlaybackProgressDurationText {
		id: seekProgressText;

		anchors.bottom: playbackProgressItem.bottom;
		anchors.bottomMargin: 10hph;
		anchors.horizontalCenter: sliderRect.horizontalCenter;

		milliseconds: playbackProgressItem.barProgress;

		visible: playbackProgressItem.gear != 0;
	}

	PlaybackProgressDurationText {
		id: durationText;

		anchors.right: parent.right;
		anchors.rightMargin: 10hpw;
		anchors.verticalCenter: progressBar.verticalCenter;

		milliseconds: playbackProgressItem.duration;

		visible: progressBar.visible && playbackProgressItem.duration > 0;
	}

	onBackPressed: { this.visible = false; }
	onRedPressed: { this.visible = false; }

	onKeyPressed: { hideTimer.restart(); }

	onVisibleChanged: {
		if (visible)
		{
			this.seekProgress = this.progress;
			progressBar.resetAnimation();

			if (progressBar.visible)
				progressBar.setFocus();
			else
				this.visible = false;
		}
		else
			this.resetSeek();
	}

	resetSeek: {
		this.gear = 0;
		this.seekProgress = 0;
		seekTimer.stop();
		postSeekTimer.stop();
	}

	fastForward: {
		hideTimer.restart();
		seekTimer.restart();

		if (this.gear > 0)
			this.gear += 2;
		else
		{
			if (this.gear == 0)
				this.seekProgress = this.progress;

			this.gear = 1;
		}

		postSeekTimer.stop();
		this.seekProgress = Math.min(this.seekProgress + this.gear * 1000, this.duration);
	}

	rewind: {
		hideTimer.restart();
		seekTimer.restart();

		if (this.gear < 0)
			this.gear -= 2;
		else
		{
			if (this.gear == 0)
				this.seekProgress = this.progress;

			this.gear = -1;
		}

		postSeekTimer.stop();
		this.seekProgress = Math.max(this.seekProgress + this.gear * 1000, 0);
	}

	onDisableAutoShowChanged: {
		if (!disableAutoShow && showControls)
		{
			hideTimer.restart();
			this.visible = true;
		}
	}

	onShowControlsChanged: {
		if (!showControls)
			hideTimer.stopAndTrigger();
		else if (!disableAutoShow)
		{
			hideTimer.restart();
			this.visible = true;
		}
	}
}
