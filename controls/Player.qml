import "controls/media.js" as media;

Player : Item {
	id: playerObj;

	VideoOverlay {
		anchors.fill: parent;
	}

	Spinner {
		id: loadSpinner;
		anchors.centerIn: parent;
		z: 1000;
	}

	focus: true;
//	anchors.fill: parent;
	visible: false;

	signal finished(state);

	property bool paused: false;
	property bool statusShow: false;
	property bool statusHold: false;
	property int duration: 0;
	property int cursorPos: 0;
	property int cursorDist: cursorPos / duration * emptyBar.width - 2;
	property int cursorGain: 1000;

	Item {
		id: statusItem;
//		visible: parent.statusShow;
		opacity: parent.statusShow ? 1 : 0.01;
		anchors.fill: parent.width < safeArea.width ? parent : safeArea;
		anchors.margins: 10;

		Rectangle {
			id: emptyBar;
			color: colorTheme.disabledBackgroundColor;
			height: parent.height / 20;
			anchors.bottom: parent.bottom;
			anchors.left: parent.left;
			anchors.right: parent.right;

			Rectangle {
				id: seekBar;
				color: colorTheme.activeBackgroundColor;
				anchors.margins: parent.borderWidth;
				anchors.top: parent.top;
				anchors.left: parent.left;
				anchors.bottom: parent.bottom;
				Behavior on width {animation: Animation {duration: 2000;} }
			}

			Rectangle {
				id: progressBar;
				color: colorTheme.activeBorderColor;
				anchors.margins: parent.borderWidth;
				anchors.top: parent.top;
				anchors.left: parent.left;
				anchors.bottom: parent.bottom;
				Behavior on width {animation: Animation {duration: 2000;} }
				z: 100;
			}


			SmallText {
				anchors.top: progressBar.bottom;
				anchors.left: progressBar.left;
				anchors.topMargin: 2;

			}

			Rectangle {
				id: cursorBar;
				color: "#ffffff";
				visible: false;
				anchors.top: parent.top;
				anchors.bottom: parent.bottom;
				anchors.margins: parent.borderWidth;
				anchors.left: parent.left;
				anchors.leftMargin: playerObj.cursorDist;
				width: 10;
				Behavior on x {animation: Animation {duration: 200;}}
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
		id: statusTimer;
		interval: 5000;

		onTriggered: {
			if (!playerObj.statusHold) { 
				playerObj.statusShow = false;
			}
			cursorBar.visible = false;
			playerObj.cursorPos = 0;
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
		this.stop();
		this.finished();
	}

	onSelectPressed: {
		statusTimer.restart();
		if (cursorBar.visible) {
			cursorBar.visible = false;
			log ("Seeking at " + this.cursorPos);
			this.player.seek(this.cursorPos);
			this.refreshBar();
		}
		else {
			this.paused = !this.paused;
			this.player.pause(this.paused);
		}
	}

	onKeyPressed: {
		return true;
	}

	onUpPressed: {
		this.statusShow = !this.statusShow;
		this.refreshBar();
	}

	onDownPressed: {
		this.statusShow = !this.statusShow;
		this.refreshBar();
	}

	onStatusShowChanged: {
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
		this.visible = false;
	}

	function refreshBar() {
		log("Progress: " + playerObj.player.getProgress());
		log("Seekable progress: " + playerObj.player.getSeekableRangeEnd());
		progressBar.width = playerObj.player.getProgress() / playerObj.duration * emptyBar.width;
//		seekBar.width = playerObj.player.getSeekableRangeEnd() / playerObj.duration * emptyBar.width;
		log("ProgressBar width: " + progressBar.width);
		log("EmptyBar width: " + emptyBar.width);
	}

}

PreviewPlayer : Item {
	id: previewItem;

	signal finished(state);
	signal fullscreen();

	property string title;
	property bool isFullscreen: false;
	property int duration;

	Rectangle {
		anchors.top: previewItem.top;
		anchors.right: previewItem.right;
		anchors.left: previewItem.left;
		height: titleText.height;
		color: "#00000080";
		visible: !parent.isFullscreen;

		SmallText {
			id: titleText;
			anchors.top: previewItem.top;
			anchors.right: previewItem.right;
			anchors.left: previewItem.left;
			horizontalAlignment: Text.AlignHCenter;
			text: previewItem.title;
			wrapMode: Text.Wrap;
		}

		z: 1000;
	}

	Player {
		id: previewPlayer;
		anchors.top: parent.isFullscreen ? mainWindow.top : parent.top;
		anchors.bottom: parent.isFullscreen ? mainWindow.bottom : controls.opacity == 1 ? controls.top : parent.bottom;
		anchors.left: parent.isFullscreen ? mainWindow.left : parent.left;
		anchors.right: parent.isFullscreen? mainWindow.right : parent.right;
		anchors.bottomMargin: 10;
		statusShow: !parent.isFullscreen;
		statusHold: !parent.isFullscreen;
		focus: parent.isFullscreen;
//		duration: parent.duration;

		onFinished: {
			previewPlayer.focus = false;
			previewItem.finished(state);
			previewItem.isFullscreen = false;
//			previewPlayer.statusShow = true;
//			previewPlayer.statusHold = true;
			controls.opacity = 1;
		}
	}

	Item {
		id: controls;
		anchors.bottom: parent.bottom;
		anchors.left: parent.left;
		anchors.right: parent.right;
		height: 50;
		clip: true;
		focus: true;
		opacity: 1;
		z: 1000;

		onActiveFocusChanged: {
			if (activeFocus)
				fullIm.setFocus();
		}

		Image {
			id: playIm;
			anchors.centerIn: parent;
			width: 48;
			height: 48;
			focus: true;
			color: "#ff0000";
			source:	previewPlayer.paused ? 
					activeFocus ? "res/apps/preview/arrowPlayActive.png" : "res/apps/preview/arrowPlay.png" :
					activeFocus ? "res/apps/preview/pauseActive.png" : "res/apps/preview/pause.png";
//			z: 100;
			
			onLeftPressed: {
				prevIm.setFocus();
			}

			onRightPressed: {
				nextIm.setFocus();
			}

			onSelectPressed: {
				previewPlayer.onSelectPressed();
			}
		}

		Image {
			id: nextIm;
			anchors.top: playIm.top;
			anchors.bottom: playIm.bottom;
			anchors.left: playIm.right;
			width: 48;
			focus: true;
			source: activeFocus ? "res/apps/preview/arrowNextActive.png" : "res/apps/preview/arrowNext.png";

			onRightPressed: {
				fullIm.setFocus();
			}

			onLeftPressed: {
				playIm.setFocus();
			}

			onSelectPressed: {
				previewPlayer.onRightPressed();
			}
		}

		Image {
			id: prevIm;
			anchors.top: playIm.top;
			anchors.bottom: playIm.bottom;
			anchors.right: playIm.left;
			width: 48;
			focus: true;
			source: activeFocus ? "res/apps/preview/arrowPrevActive.png" : "res/apps/preview/arrowPrev.png";

			onRightPressed: {
				playIm.setFocus();
			}

			onSelectPressed: {
				previewPlayer.onLeftPressed();
			}
		}

		Image {
			id: fullIm;
			anchors.top: playIm.top;
			anchors.bottom: playIm.bottom;
			anchors.right: parent.right;
			width: 48;
			focus: true;
			source: activeFocus ? "res/apps/preview/fullscreenActive.png" : "res/apps/preview/fullscreen.png";

			onLeftPressed: {
				nextIm.setFocus();
			}

			onSelectPressed: {
				previewPlayer.focus = true;
//				previewPlayer.anchors.fill = mainWindow;
				previewItem.isFullscreen = true;
//				previewPlayer.statusShow = false;
//				previewPlayer.statusHold = false;
				previewPlayer.setFocus();
				previewItem.fullscreen();
				controls.opacity = 0;
			}
		}

	}
	
	function playUrl (url) {
		this.visible = true;
		previewPlayer.playUrl(url);
	}
	
	function stop () {
		this.visible = false;
		previewPlayer.stop();
	}
}
