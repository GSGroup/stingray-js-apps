import "controls/media.js" as media;
import controls.MainText;
import controls.SmallText;
import controls.Spinner;

Item {
	id: playerObj;

	VideoOverlay {
//		visible: !loadSpinner.visible;
		anchors.fill: parent;
	}


	Spinner {	
		id: loadSpinner;
		anchors.centerIn: parent;
		z: 1000;
	}

//	focus: true;
//	anchors.fill: parent;
	visible: false;

	signal finished(state);

	property bool paused: false;
	property bool statusShow: false;
	property bool statusHold: false;
	property bool preview: false;
	property bool cursorVisible: cursorBar.visible;
	property int duration: 0;
	property int cursorPos: 0;
	property int cursorDist: cursorPos / duration * emptyBar.width - 2;
	property bool seeking: false;
	property int progress: 0;

	property int cursorGain: 1000;
	property string curTimeStr: "";
	property string fullTimeStr: "";

	Image {
		id: pauseImage;
		anchors.centerIn: parent;
		visible: parent.paused;
		source: "apps/controls/res/preview/icoPause.png";
	}

	Item {
		id: statusItem;
//		visible: parent.statusShow;
		opacity: parent.statusShow ? 1 : 0.01;
		anchors.fill: parent.width < safeArea.width ? parent : safeArea;
		anchors.margins: 10;

		Rectangle {
			id: emptyBar;
			color: "#808080";
			height: parent.height / 40;
			anchors.bottom: parent.bottom;
			anchors.left: parent.left;
			anchors.right: parent.right;
			anchors.bottomMargin: playerObj.preview ? 10 : 20;
			radius: height / 2;

			Rectangle {
				id: seekBar;
				color: colorTheme.activeBackgroundColor;
				anchors.margins: parent.borderWidth;
				anchors.top: parent.top;
				anchors.left: parent.left;
				anchors.bottom: parent.bottom;
				radius: height / 2;
				Behavior on x {animation: Animation {id: seekAnim; duration: 200;} }
			}

			Rectangle {
				id: progressBar;
				color: colorTheme.activeFocusColor;
				anchors.margins: parent.borderWidth;
				anchors.top: parent.top;
				anchors.left: parent.left;
				anchors.bottom: parent.bottom;
				radius: height / 2;
				Behavior on width {animation: Animation {id: progressAnim; duration: 2000;} }
				z: 100;
			}


			AlphaControl {
				alphaFunc: MaxAlpha;
			}

			MainText {
				id: curTimeText;
				visible: !playerObj.preview;
				anchors.top: progressBar.bottom;
				anchors.left: emptyBar.left;
				anchors.topMargin: 5;
				color: "#e0e000"; //colorTheme.activeBorderColor;
				style: Shadow;
				text: playerObj.curTimeStr;
				z: 1000;
			}

			MainText {
			   visible: !playerObj.preview;
			   anchors.top: progressBar.bottom;
			   anchors.right: emptyBar.right;
			   anchors.topMargin: 5;
			   color: "#e0e000"; //colorTheme.activeBorderColor;
			   style: Shadow;
			   text: playerObj.fullTimeStr;
			   z: 1000;
			}

			SmallText {
				id: seekTimeText;
				anchors.verticalCenter: cursorBar.verticalCenter;
				anchors.left: cursorBar.right;
				anchors.leftMargin: playerObj.cursorDist + width + 10 > parent.width ? - width - cursorBar.width : 5;
				style: Shadow;
				color: colorTheme.activeTextColor;
				visible: cursorBar.visible;
				text: (playerObj.cursorPos / 1000 / 60 >= 10 ? "" : "0") + 
						Math.floor(playerObj.cursorPos / 1000 / 60) + ":" +
					  (playerObj.cursorPos / 1000 % 60 >= 10 ? "" : "0") +
					  	Math.floor(playerObj.cursorPos / 1000 % 60);
				z: 1000;
			}

			Gradient {
				anchors.bottom: playerObj.bottom;
				anchors.right: playerObj.right;
				anchors.left: playerObj.left;
				anchors.top: parent.top;
				anchors.topMargin: -10;

				GradientStop {
					position: 1;
					color: "#000000";
				}

				GradientStop {
					position: 0;
					color: "#00000050";
				}
			}

			Rectangle {
				id: cursorBar;
				color: "#ffffff";
				visible: false;
				anchors.top: parent.top;
				anchors.bottom: parent.bottom;
				anchors.topMargin: -2;
				anchors.bottomMargin: -2;
				anchors.left: parent.left;
				anchors.leftMargin: playerObj.cursorDist;
				width: height;
				radius: width / 2;
				Behavior on x {animation: Animation {id: cursorAnim; duration: 200;}}
				z: 200;
			}
		}

		Behavior on opacity {animation: Animation {duration: 400;} }
	}

	Timer {
		id: refreshBarTimer;
		interval: 2000;

		onTriggered: {
			playerObj.refreshBar();
			this.restart();
		}
	}

	Timer {
		id: refreshTimeTimer;
		interval: 100;

		onTriggered: {
			var p = playerObj.player.getProgress();
			playerObj.progress = p / 1000;
			if (p && playerObj.duration >= 0) {
				//fixme: gognocode
				playerObj.curTimeStr = 
								   (p / 1000 / 60 >= 10 ? "" : "0") +
								   		Math.floor(p / 1000 / 60) + ":" + 
								   (p / 1000 % 60 >= 10 ? "" : "0") + 
								   		Math.floor(p / 1000 % 60);
				playerObj.fullTimeStr = 
								   (playerObj.duration / 1000 / 60 >= 10 ? "" : "0") + 
										Math.floor(playerObj.duration / 1000 / 60) + ":" + 
								   (playerObj.duration / 1000 % 60 >= 10 ? "" : "0") + 
								   		Math.floor(playerObj.duration / 1000 % 60);
			} else {
				playerObj.curTimeStr = "";
				playerObj.fullTimeStr = "";
				playerObj.progress = 0;
			}
			this.restart();
		}
	}


	Timer {
		id: statusTimer;
		interval: 5000;

		onTriggered: {
			if (!playerObj.statusHold) { 
				playerObj.statusShow = false;
			}
			cursorBar.visible = false;
			playerObj.cursorPos = playerObj.player.getProgress();
		}
	}

	Timer {
		id: holdTimer;
		interval: 250;
	}

	Timer {
		id: spinnerTimer;
		interval: 100;
		
		onTriggered: {
			if (playerObj.player.getProgress() != 0) {
				var d = playerObj.player.getDuration();
				if (d) {
					playerObj.duration = d;
					log("DURATION: " + d);
					loadSpinner.visible = false;
				} 
				else this.restart();
			}
			else this.restart();
		}
	}

	onCompleted: {
		this.player = new media.Player();
	}

	onRightPressed: {
		if (holdTimer.running) {
			this.cursorGain += 1000;
		} else this.cursorGain = 1000;
		holdTimer.restart();
		statusTimer.restart();
		cursorBar.visible = true;
		if (this.cursorPos + this.cursorGain  <=  playerObj.player.getSeekableRangeEnd())
			this.cursorPos += this.cursorGain;
		else 
			this.cursorPos = playerObj.player.getSeekableRangeEnd();
	}

	onLeftPressed: {
		if (holdTimer.running) {
			this.cursorGain += 1000;
		} else this.cursorGain = 1000;
		holdTimer.restart();
		statusTimer.restart();
		cursorBar.visible = true;
		if (this.cursorPos - this.cursorGain >=  playerObj.player.getSeekableRangeStart())
			this.cursorPos -= this.cursorGain;
		else 
			this.cursorPos = playerObj.player.getSeekableRangeStart();
	}

	onBackPressed: {
//		this.stop();
		this.finished();
	}

	onSelectPressed: {
		statusTimer.restart();
		if (cursorBar.visible) {
			cursorBar.visible = false;
			log ("Seeking at " + this.cursorPos);
			this.player.seek(this.cursorPos);
			this.seeking = true;
			loadSpinner.visible = true;
			progressBar.width = this.cursorDist;
			spinnerTimer.restart();
			this.refreshBar();
		}
		else {
			this.paused = !this.paused;
		}
	}

	onPausedChanged: {
		this.player.pause(this.paused);
	}

	onKeyPressed: {
		return true;
	}

	onUpPressed: {
		onDownPressed();
	}
	
	completeAnim: {
		progressAnim.complete();
		seekAnim.complete();
		cursorAnim.complete();
	}

	onDownPressed: {
		playerObj.statusShow = !playerObj.statusShow;
		playerObj.refreshBar();
		cursorBar.visible = false;
		playerObj.completeAnim();
	}

	onStatusHoldChanged: {
		if (playerObj.statusShow && !playerObj.statusHold) {
			statusTimer.start();
		}
		if (statusHold) {
			playerObj.statusShow = true;
			statusTimer.stop();
		}
	}

	onPreviewChanged: {
		playerObj.refreshBar();
		playerObj.completeAnim();
	}

	onStatusShowChanged: {
		playerObj.completeAnim();
		if (statusShow && !statusHold) {
			statusTimer.start();
		}
		if (statusShow) {
			playerObj.cursorPos = playerObj.player.getProgress();
		}
	}

	function playUrl(url) {
		log("Player: start playing " + url);
		loadSpinner.visible = true;
		spinnerTimer.restart();
		refreshTimeTimer.restart();
		this.duration = -1;
		this.visible = true;
		this.player.stop();
		this.player.playUrl(url);
		this.paused = false;
		refreshBarTimer.start();
		playerObj.refreshBar(); //could throw exception and timer will not start
	}

	function stop() {
		log("Player: stop playing");
		this.player.stop();
		refreshBarTimer.stop();
		refreshTimeTimer.stop();
		this.visible = false;
	}
	
	property int prevProgress;

	function refreshBar() {
		var p = playerObj.player.getProgress();
		this.prevProgress = p;
		//log("Progress: " + p);
		//log("Seekable progress: " + playerObj.player.getSeekableRangeEnd());
		if (p == 0 && this.seeking)
			return;
		this.seeking = false;
		progressBar.width = p / playerObj.duration * emptyBar.width;
//		seekBar.width = playerObj.player.getSeekableRangeEnd() / playerObj.duration * emptyBar.width;
	}

}
