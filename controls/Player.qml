import "controls/media.js" as media;

Player : Item {
	id: playerObj;

	VideoOverlay {
		anchors.fill: parent;
	}

	focus: true;
	anchors.fill: mainWindow;
	visible: false;

	signal finished(state);

	property bool paused: false;
	property bool statusShow: false;
	property int duration: 0;

	Item {
		id: statusItem;
//		visible: parent.statusShow;
		opacity: parent.statusShow ? 1 : 0.01;
		anchors.fill: parent;
		anchors.margins: 20;

		Rectangle {
			id: emptyBar;
			color: colorTheme.disabledBackgroundColor;
			height: parent.height / 20;
			anchors.bottom: parent.bottom;
			anchors.left: parent.left;
			anchors.right: parent.right;

			Rectangle {
				id: progressBar;
				color: colorTheme.activeBorderColor;
				anchors.margins: parent.borderWidth;
				anchors.top: parent.top;
				anchors.left: parent.left;
				anchors.bottom: parent.bottom;
				Behavior on width {animation: Animation {duration: 2000;} }
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

	onCompleted: {
		this.player = new media.Player();
	}

	onBackPressed: {
		this.stop();
		this.finished();
	}

	onSelectPressed: {
		this.paused = !this.paused;
		this.player.pause();
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

	function playUrl(url) {
		log("Player: start playing " + url);
		this.visible = true;
		this.player.stop();
		this.player.playUrl(url);
		this.paused = false;
		playerObj.refreshBar();
		refreshBarTimer.start();
	}

	function stop() {
		log("Player: stop playing");
		this.player.stop();
		refreshBarTimer.stop();
		this.visible = false;
	}

	function refreshBar() {
		log("Progress: " + playerObj.player.getProgress());
//		log("Seekable progress: " + playerObj.player.getSeekableProgress());
		progressBar.width = playerObj.player.getProgress() / playerObj.duration * emptyBar.width;
		log("ProgressBar width: " + progressBar.width);
		log("EmptyBar width: " + emptyBar.width);
	}

}

PreviewPlayer : Item {
	id: previewItem;

	signal finished(state);
	property int duration;

	Player {
		id: previewPlayer;
		anchors.top: parent.top;
		anchors.bottom: controls.top;
		anchors.left: parent.left;
		anchors.right: parent.right;
		preview: true;
		statusShow: true;
		focus: false;
		duration: parent.duration;

		onFinished: {
			previewItem.finished(state);
		}
	}

	Item {
		id: controls;
		anchors.bottom: parent.bottom;
		anchors.left: parent.left;
		anchors.right: parent.right;
		height: 50;
		focus: true;

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
			source:	!previewPlayer.paused ? 
					activeFocus ? "res/apps/preview/arrowPlayActive.png" : "res/apps/preview/arrowPlay.png" :
					activeFocus ? "res/apps/preview/arrowPauseActive.png" : "res/apps/preview/arrowPause.png";
//			z: 100;
			
			onLeftPressed: {
				prevIm.setFocus();
			}

			onRightPressed: {
				nextIm.setFocus();
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
		}

	}
	
	function playUrl (url) {
		this.visible = true;
//		previewPlayer.playUrl(url);
	}
	
	function stop () {
		this.visible = false;
//		previewPlayer.stop();
	}
}
