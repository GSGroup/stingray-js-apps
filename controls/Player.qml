// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.Media;
import controls.Spinner;
import "TopLabel.qml";
import "PlaybackProgress.qml";

Item {
	id: playerObj;
	signal started(started);
	signal finished(finished);
	signal stopped();
	property bool paused: false;
	property bool isStopped: true;
	property bool isFullscreen: false;
	property bool seeking: false;
	property bool hideSpinner: false;
	property bool disableControls: false;
	property int duration: 0;
	property int cursorPos: 0;
	property int progress: 0;
	property int cursorGain: 1000;
	property int prevProgress;
	property string curTimeStr: "";
	property string fullTimeStr: "";
	property string title;
	clip: true;

	VideoOverlay {
		anchors.fill: parent;
		visible: !playerObj.isStopped;
	}

	AlphaControl { alphaFunc: MaxAlpha; }

	Item {
		anchors.fill: parent;
		visible: playerObj.isFullscreen;

		TopLabel {
			visible: playbackProgress.visible;
			text: playerObj.title;
		}

		PlaybackProgress {
			id: playbackProgress;
			height: 70;
			anchors.bottom: safeArea.bottom;
			anchors.left: safeArea.left;
			anchors.right: safeArea.right;
			anchors.leftMargin: 5;
			anchors.rightMargin: 5;
			focus: true;
			isPlaying: !playerObj.paused;
			progress: playerObj.progress;
			opacity: visible ? 1 : 0;
			duration: playerObj.duration;
			curTimeStr: playerObj.curTimeStr;
			fullTimeStr: playerObj.fullTimeStr;
			visible: playerObj.visible && !playerObj.disableControls;

			onPlayPressed: {
				if (playerObj.currentMediaData)
					playerObj.playUrl(playerObj.currentMediaData);
			}

			onPausePressed:	{ playerObj.pause(); }
			onSeeked:		{ playerObj.seekAbs(position); }

			Behavior on opacity { animation: Animation { duration: 300; } }
		}
	}

	Image {
		id: pauseImage;
		anchors.centerIn: parent;
		visible: parent.paused && !playerObj.disableControls;
		fillMode: PreserveAspectFit;
		source: "apps/controls/res/preview/icoPause.png";
	}

	Spinner {
		id: loadSpinner;
		property bool show: true;
		anchors.centerIn: parent;
		visible: show && !playerObj.hideSpinner;
	}

	Timer {
		id: spinnerTimer;
		interval: 400;
		running: playerObj.visible;
		repeat: running;
		
		onTriggered: {
			var p = playerObj.player.getProgress();
			var d = playerObj.player.getDuration();
			playerObj.progress = p;
			playerObj.duration = d;

			if (!playerObj.isStopped && loadSpinner.show)
				loadSpinner.show = false;

			if (p && d >= 0) {
				//fixme: gognocode
				p /= 1000;
				d /= 1000;
				if (p < 0 || d < 0)
					return;

				var h = Math.floor(p / 3600);
				playerObj.curTimeStr = h > 0 ? h + ":" : "";
				p -= h * 3600;
				playerObj.curTimeStr +=
									(p / 60 >= 10 ? "" : "0") +
										Math.floor(p / 60) + ":" + 
									(p % 60 >= 10 ? "" : "0") + 
										Math.floor(p % 60);

				h = Math.floor(d / 3600);
				playerObj.fullTimeStr = h > 0 ? h + ":" : "";
				d -= h * 3600;
				playerObj.fullTimeStr += 
									(d / 60 >= 10 ? "" : "0") + 
										Math.floor(d / 60) + ":" + 
									(d  % 60 >= 10 ? "" : "0") + 
										Math.floor(d % 60);
			} else {
				playerObj.curTimeStr = "";
				playerObj.fullTimeStr = "";
			}
		}
	}

	onKeyPressed: {
		if (!visible || key == "Menu")
			return false;

		if (key == "Volume Up" || (playbackProgress.visible && key == "Up") || (!playbackProgress.visible && key == "Right")) {
			mainWindow.volumeUp();
			return true;
		}
		if (key == "Volume Down" || (playbackProgress.visible && key == "Down") || (!playbackProgress.visible && key == "Left")) {
			mainWindow.volumeDown();
			return true;
		}

		if (key == "Pause" && !this.disableControls) {
			playbackProgress.show();
			playbackProgress.togglePlay();
			return true;
		}
		if (key == "Fast Forward" && !this.disableControls) {
			playbackProgress.show();
			playbackProgress.doFF();
			return true;
		}
		if (key == "Rewind" && !this.disableControls) {
			playbackProgress.show();
			playbackProgress.doRewind();
			return true;
		}

		if (key == "Last") {
			playerObj.abort();
			return false;
		}

		if (key == "Back") {
			if (playbackProgress.visible)
				playbackProgress.hide();
			else
				playerObj.abort();
		}
		else if (key == "Stop") {
			playerObj.abort();
		} else if (key == "Volume Mute" || key == "V" || key == "v") {
			mainWindow.muteToggle();
		} else if (!this.disableControls) {
			playbackProgress.show();
		}
		return true;
	}

	pause: { this.togglePlay(); }

	abort: {
		this.player.stop();
		this.paused = false;
		this.isStopped = true;
		playerObj.stopped();
	}

	function togglePlay() {
		this.paused = !this.paused;
		this.player.pause(this.paused);
	}

	function seekAbs(position) {
		this.player.seekAbs(position);
	}

	function seek(msDelta) {
		if (!this.paused)
			this.player.seek(msDelta);
	}

	function stop() {
		log("Player: stop playing");
		this.player.stop();
		this.visible = false;
		this.isStopped = true;
	}

	function playMedia(mediaData)
	{
		if (this.paused && Object.entries(mediaData.info).toString() === Object.entries(this.currentMediaData.info).toString()) {
			this.togglePlay();
			return;
		}
		log("Player: start playing " + Object.entries(mediaData.info).toString());
		loadSpinner.show = false;
		loadSpinner.show = true;
		spinnerTimer.restart();
		this.currentMediaData = mediaData;
		this.visible = true;
		this.player.stop();

		this.paused = false;

		var self = playerObj;

		this.player.started = function (started) {
			if (started)
				log("Player: play is started");

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
