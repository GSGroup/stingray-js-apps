// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.Media;
import controls.Spinner;
import "PlaybackProgress.qml";

import stingray.Config;

Item {
	id: playerProto;

	signal started(started);
	signal finished(finished);
	signal stopped;

	property bool fullscreen: true;
	property bool hideSpinner;
	property bool disableControls;
	property string title;

	property bool paused;
	property bool isStopped: true;
	property bool isMuted;

	property alias isFullscreen: fullscreen;
	property bool seeking: false;
	property int duration: playbackProgress.duration;
	property int cursorPos: 0;
	property int progress: playbackProgress.progress;
	property int cursorGain: 1000;
	property int prevProgress;
	property string curTimeStr: playbackProgress.curTimeStr;
	property string fullTimeStr: playbackProgress.fullTimeStr;

	Timer {
		id: spinnerTimer;

		interval: 400;
		repeat: running;
		running: playerProto.visible;

		onTriggered: {
			playbackProgress.progress = playerProto.player.getProgress();
			playbackProgress.duration = playerProto.player.getDuration();

			if (!playerProto.isStopped && spinner.show)
				spinner.show = false;
		}
	}

	Timer {
		id: playIconHideTimer;

		interval: 800;

		onTriggered: {
			playIcon.animationDuration = pauseIcon.visible ? 100 : 300;
			playIcon.opacity = 0;
		}
	}

	VideoOverlay {
		anchors.fill: parent;

		visible: !playerProto.isStopped;
	}

	AlphaControl { alphaFunc: MaxAlpha; }

	PlaybackProgress {
		id: playbackProgress;

		property bool canShow: playerProto.fullscreen && playerProto.visible && !playerProto.disableControls;

		anchors.left: playerProto.fullscreen ? safeArea.left : playerProto.left;
		anchors.right: playerProto.fullscreen ? safeArea.right : playerProto.right;
		anchors.bottom: playerProto.fullscreen ? safeArea.bottom : playerProto.bottom;

		showControlPanel: !spinner.visible;

		isPlaying: !playerProto.paused;

		text: playerProto.title;

		onTogglePause: { playerProto.togglePause(); }

		onSeek: { playerProto.seekAbs(position); }

		onSeeked: { playerProto.seekAbs(position); }
		onPlayPressed: { playerProto.togglePause(); }
		onPausePressed: { playerProto.togglePause(); }

		onCanShowChanged: { playbackProgress.visible = canShow; }
	}

	Spinner {
		id: spinner;

		property bool show: true;

		anchors.centerIn: parent;

		visible: show && !playerProto.hideSpinner;
	}

	onKeyPressed: {
		if (key == "Record List" || key == "Menu" || (key == "Blue" && event.Source == "kids"))
			return false;

		if (key == "Volume Up" || key == "Right")
		{
			Config.Feature.volumeUp();
			return true;
		}
		else if (key == "Volume Down" || key == "Left")
		{
			Config.Feature.volumeDown();
			return true;
		}
		else if (key == "Last")
		{
			this.abort();
			return false;
		}
		else if (key == "Select" || key == "Pause")
		{
			if (!this.disableControls)
			{
				playbackProgress.resetSeek();
				playbackProgress.visible = true;
				playbackProgress.togglePause();
			}
			return true;
		}
		else if (key == "Fast Forward")
		{
			if (!this.disableControls)
			{
				playbackProgress.visible = true;
				playbackProgress.fastForward();
			}
			return true;
		}
		else if (key == "Rewind")
		{
			if (!this.disableControls)
			{
				playbackProgress.visible = true;
				playbackProgress.rewind();
			}
			return true;
		}
		else if (key == "Back" || key == "Stop")
		{
			playerProto.abort();
			return true;
		}
		else if (key == "Volume Mute")
		{
			Config.Feature.toggleMute();
			playerProto.isMuted = Config.Feature.muted;
			return true;
		}
		else if (!this.disableControls)
			playbackProgress.visible = true;

		return true;
	}

	Image {
		anchors.left: safeArea.left;
		anchors.top: safeArea.top;

		source: "res/common/mute.svg";

		opacity: playerProto.isMuted && playerProto.fullscreen ? 0.8 : 0;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}

	Image {
		id: pauseIcon;

		anchors.centerIn: parent;

		source: "res/common/player/big_pause.svg";

		visible: playerProto.paused && !spinner.visible;
		opacity: visible ? 0.8 : 0;

		Behavior on opacity { animation: Animation { duration: 100; easingType: InOutQuad; } }

		onVisibleChanged: {
			if (visible)
				playIconHideTimer.stopAndTrigger();
			else
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

		Behavior on opacity { animation: Animation { duration: playIcon.animationDuration; easingType: InQuad; } }
	}

	onVisibleChanged: { this.isMuted = Config.Feature.muted; }

	pause: { this.togglePause(); }

	abort: {
		this.player.stop();
		this.paused = false;
		this.isStopped = true;
		playerProto.stopped();
	}

	togglePause: {
		this.paused = !this.paused;
		this.player.pause(this.paused);
	}

	stop: {
		console.log("Player: stop playing");

		this.player.stop();
		this.visible = false;
		this.isStopped = true;
	}

	function seek(msDelta) {
		if (!this.paused)
			this.player.seek(msDelta);
	}

	function seekAbs(position) {
		this.player.seekAbs(position);
		this.paused = false;
	}

	function playMedia(mediaData) {
		if (this.paused && Object.entries(mediaData.info).toString() === Object.entries(this.currentMediaData.info).toString())
		{
			this.togglePause();
			return;
		}

		console.log("Player: start playing " + Object.entries(mediaData.info).toString());

		spinner.show = false;
		spinner.show = true;
		spinnerTimer.restart();

		this.currentMediaData = mediaData;
		this.visible = true;
		this.player.stop();

		this.paused = false;

		var self = playerProto;

		this.player.started = function (started) {
			if (started)
				console.log("Player: play is started");

			self.isStopped = !started;
			self.started(started)
		};

		this.player.finished = function (finished) {
			if (finished)
				self.stop();

			self.finished(finished);
		};

		this.currentMediaData.play();
	}

	function playUrl(url) {
		this.playMedia({
			info: { url: url },
			play: () => this.player.playUrl(url)
		});
	}

	function playRtsp(url, protocol, login, password) {
		this.playMedia({
			info: { url: url, protocol: protocol, credentialsHash: md5Hash(md5Hash(login) + md5Hash(password)) },
			play: () => this.player.playRtsp(url, protocol, login, password)
		});
	}

	onCompleted: {
		this.player = new Media.Player();
		this.currentMediaData = null;
	}
}
