// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.Media;
import controls.Spinner;
import "PlaybackProgress.qml";

import stingray.AudioOutputManager;

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

	focus: true;

	visible: false;

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

		disableAutoShow: spinner.visible;
		showControls: canShow;

		isPlaying: !playerProto.paused;

		text: playerProto.title;

		onTogglePause: { playerProto.togglePause(); }

		onSeek: { playerProto.seekAbs(position); }

		onSeeked: { playerProto.seekAbs(position); }
		onPlayPressed: { playerProto.togglePause(); }
		onPausePressed: { playerProto.togglePause(); }
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
			AudioOutputManager.Feature.volumeUp();
			return true;
		}
		else if (key == "Volume Down" || key == "Left")
		{
			AudioOutputManager.Feature.volumeDown();
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
			AudioOutputManager.Feature.toggleMute();
			playerProto.isMuted = AudioOutputManager.Feature.muted;
			return true;
		}
		else if (!this.disableControls)
			playbackProgress.visible = true;

		return true;
	}

	Image {
		anchors.left: safeArea.left;
		anchors.top: mainWindow.top;
		anchors.topMargin: 130hph;

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

		Behavior on opacity { animation: Animation { duration: 100; easingType: ui.Animation.EasingType.InOutQuad; } }

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

		Behavior on opacity { animation: Animation { duration: playIcon.animationDuration; easingType: ui.Animation.EasingType.InQuad; } }
	}

	onVisibleChanged: { this.isMuted = AudioOutputManager.Feature.muted; }

	pause: { this.togglePause(); }

	abort: {
		console.log("Player: abort playing");

		this._player.stop();
		this.paused = false;
		this.isStopped = true;
		playerProto.stopped();
	}

	togglePause: {
		this.paused = !this.paused;
		this._player.pause(this.paused);
	}

	stop: {
		console.log("Player: stop playing");

		this._player.stop();
		this.visible = false;
		this.isStopped = true;
	}

	function seek(msDelta) {
		if (!this.paused)
			this._player.seek(msDelta);
	}

	function seekAbs(position) {
		this._player.seekAbs(position);
		this.paused = false;
	}

	function playMedia(mediaData) {
		if (this.paused && Object.entries(mediaData.info).toString() === Object.entries(this._currentMediaData.info).toString())
		{
			this.togglePause();
			return;
		}

		console.log("Player: start playing " + Object.entries(mediaData.info).toString());

		this._player.stop();
		this._currentMediaData = mediaData;

		this.visible = true;
		this.paused = false;
		spinner.show = true;

		var self = playerProto;

		this._player.started = function (started) {
			if (started)
			{
				console.log("Player: play is started");
				spinner.show = false;
			}

			self.isStopped = !started;
			self.started(started)
		};

		this._player.finished = function (finished) {
			if (finished)
				self.stop();

			self.finished(finished);
		};

		this._player.durationChanged = function (duration) {
			playbackProgress.duration = duration;
		};

		this._player.progressChanged = function (progress) {
			playbackProgress.progress = progress;
		};

		this._currentMediaData.play();
	}

	function playUrl(url) {
		this.playMedia({
			info: { url: url },
			play: () => this._player.playUrl(url)
		});
	}

	function playHls(url) {
		this.playMedia({
			info: { url: url },
			play: () => this._player.playHls(url)
		});
	}

	function playRtsp(url, protocol, login, password) {
		this.playMedia({
			info: { url: url, protocol: protocol, credentialsHash: md5Hash(md5Hash(login) + md5Hash(password)) },
			play: () => this._player.playRtsp(url, protocol, login, password)
		});
	}

	onCompleted: {
		this._player = new Media.Player();
		this._currentMediaData = null;
	}
}
