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
	clip: true;

	VideoOverlay { anchors.fill: parent; }

	AlphaControl { alphaFunc: MaxAlpha; }

	Item {
		anchors.fill: parent;
		visible: playerObj.isFullscreen;

		TopLabel { id: title; }

		PlaybackProgress {
			id: playbackProgress;
			height: 70;
			anchors.bottom: safeArea.bottom;
			anchors.left: safeArea.left;
			anchors.right: safeArea.right;
			anchors.leftMargin: 5;
			anchors.rightMargin: 5;
			focus: true;
			//enabled: playerObj.visible;
			//hideable: playerObj.visible;
			opacity: visible ? 1 : 0;
			//visible: playerObj.isFullscreen;
			visible: false;

			Behavior on opacity { animation: Animation { duration: 300; } }
		}
	}

	Spinner {
		id: loadSpinner;
		anchors.centerIn: parent;
	}

	Image {
		id: pauseImage;
		anchors.centerIn: parent;
		visible: parent.paused;
		source: "apps/controls/res/preview/icoPause.png";
	}

	Timer {
		id: spinnerTimer;
		interval: 100;
		running: playerObj.visible;
		
		onTriggered: {
			//if (playerObj.player.getProgress()) {
				//var t = new TimeDuration(playerObj.player.getProgress());
				//log("pr: " +t + "; dur: " + playerObj.duration);
				//var d = playerObj.player.getDuration();
				//if (d) {
					//playerObj.duration = d;
					//log("DURATION: " + d);
					//loadSpinner.visible = false;
				//} else {
					//this.restart();
				//}
			//} else {
				//this.restart();
			//}
		}
	}

	Timer {
		id: refreshTimeTimer;
		interval: 100;

		onTriggered: {
			//playerObj.progress = p / 1000;
			//if (p && playerObj.duration >= 0) {
				////fixme: gognocode
				//playerObj.curTimeStr = 
								   //(p / 1000 / 60 >= 10 ? "" : "0") +
										   //Math.floor(p / 1000 / 60) + ":" + 
								   //(p / 1000 % 60 >= 10 ? "" : "0") + 
										   //Math.floor(p / 1000 % 60);
				//playerObj.fullTimeStr = 
								   //(playerObj.duration / 1000 / 60 >= 10 ? "" : "0") + 
										//Math.floor(playerObj.duration / 1000 / 60) + ":" + 
								   //(playerObj.duration / 1000 % 60 >= 10 ? "" : "0") + 
										   //Math.floor(playerObj.duration / 1000 % 60);
			//} else {
				//playerObj.curTimeStr = "";
				//playerObj.fullTimeStr = "";
				//playerObj.progress = 0;
			//}
			//this.restart();
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
		if (key == "Last") {
			//self.Abort();
			return false;
		}

		if (key == "Pause") {
			playbackProgress.visible = true;
			//playbackProgress.PlayPause();
			return true;
		}
		if (key == "Fast Forward") {
			playbackProgress.visible = true;
			//playbackProgress.doFF();
			return true;
		}
		if (key == "Rewind") {
			playbackProgress.visible = true;
			//playbackProgress.doRewind();
			return true;
		}

		//if ((key == "Back" && !playbackProgress.visible) || key == "Stop") {
		if (key == "Back" || key == "Stop") {
			playerObj.abort();
		} else if (key == "Volume Mute" || key == "V" || key == "v") {
			//App::Zapper().Mute(!App::Zapper().IsMuted());
			//mainWindow.Local().muteIcon.updateIcon();
		} else {
			playbackProgress.visible = true;
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
		//TODO: check puase.
		//this.player.pause();
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
		//refreshBarTimer.stop();
		refreshTimeTimer.stop();
		this.visible = false;
	}

	function playUrl(url) {
		log("Player: start playing " + url);
		loadSpinner.visible = true;
		spinnerTimer.restart();
		refreshTimeTimer.restart();
		//this.duration = -1;
		this.visible = true;
		this.player.stop();
		this.player.playUrl(url);
		this.paused = false;

		refreshBarTimer.start();
		playerObj.refreshBar(); //could throw exception and timer will not start
	}
}
