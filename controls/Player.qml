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
		opacity: parent.statusShow ? 1 : 0.1;
		anchors.fill: parent;
		anchors.margins: 20;

		Rectangle {
			id: emptyBar;
			color: colorTheme.disabledBackgroundColor;
			height: 40;
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
