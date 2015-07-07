import "controls/media.js" as media;
import controls.MainText;
import controls.SmallText;
import controls.Spinner;
import controls.TopLabel;
import controls.PlaybackProgress;

Item {
	id: playerObj;
	signal finished(state);
	property bool paused: false;
	property bool isFullscreen: false;
	property bool seeking: false;
	property int duration: 0;
	property int cursorPos: 0;
	property int progress: 0;
	property int cursorGain: 1000;
	property int prevProgress;
	property string curTimeStr: "";
	property string fullTimeStr: "";
	property string currentUrl: "";
	property string title;
	clip: true;

	VideoOverlay { anchors.fill: parent; }

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
			visible: false;

			onPlayPressed: {
				if (playerObj.currentUrl)
					playerObj.playUrl(playerObj.currentUrl);
			}

			onPausePressed:			{ playerObj.pause(); }
			onFastForwardPressed:	{ playerObj.seek(30000); }
			onRewindPressed:		{ playerObj.seek(-30000); }

			Behavior on opacity { animation: Animation { duration: 300; } }
		}
	}

	Image {
		id: pauseImage;
		anchors.centerIn: parent;
		visible: parent.paused;
		source: "apps/controls/res/preview/icoPause.png";
	}

	Spinner {
		id: loadSpinner;
		anchors.centerIn: parent;
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

			if (p && loadSpinner.visible && d)
				loadSpinner.visible = false;

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
		if (key == "Right" || key == "Volume Up" || (key == "Up" && playbackProgress.visible)) {
			//mainWindow.Local().volumePanel.volumeUp();
			return true;
		}
		if (key == "Left" || key == "Volume Down" || (key == "Down" && playbackProgress.visible)) {
			//mainWindow.Local().volumePanel.volumeDown();
			return true;
		}

		if (key == "Pause") {
			playbackProgress.show();
			playbackProgress.togglePlay();
			return true;
		}
		if (key == "Fast Forward") {
			playbackProgress.show();
			playbackProgress.doFF();
			return true;
		}
		if (key == "Rewind") {
			playbackProgress.show();
			playbackProgress.doRewind();
			return true;
		}

		if (key == "Back" || key == "Stop" || key == "Last") {
			playerObj.abort();
		} else if (key == "Volume Mute" || key == "V" || key == "v") {
			//App::Zapper().Mute(!App::Zapper().IsMuted());
			//mainWindow.Local().muteIcon.updateIcon();
		} else {
			playbackProgress.show();
		}
		return true;
	}

	onCompleted: {
		this.player = new media.Player();
		this.paused = true;
	}

	onBackPressed: {
		playerObj.abort();
	}

	abort: {
		this.player.stop();
		this.paused = true;
		playerObj.finished();
	}

	pause: {
		this.player.stop();
		this.paused = true;
	}

	function seek(msDelta) {
		if (!this.paused)
			this.player.seek(msDelta);
	}

	function stop() {
		log("Player: stop playing");
		this.player.stop();
		this.visible = false;
	}

	function playUrl(url) {
		log("Player: start playing " + url);
		loadSpinner.visible = false;
		loadSpinner.visible = true;
		spinnerTimer.restart();
		this.currentUrl = url
		this.visible = true;
		this.player.stop();
		this.player.playUrl(url);
		this.paused = false;
	}
}
