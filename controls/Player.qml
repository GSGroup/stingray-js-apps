import "controls/media.js" as media;

Player : Item {
	id: playerObj;

	VideoOverlay {
		anchors.fill: parent;
	}

	focus: true;
	anchors.fill: mainWindow;
	visible: false;

	signal finished();

	property bool paused: false;
	property bool statusShow: false;
	property int duration: 0;

	Item {
		id: statusItem;
		visible: parent.statusShow;
		anchors.fill: parent;

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
//				width: 100;
				Behavior on width {animation: Animation {duration: 2000;} }
			}
		}
	}

	Timer {
		id: refreshBarTimer;
		interval: 2000;

		onTriggered: {
			playerObj.refreshBar();
		}
	}

	onCompleted: {
		this.player = new media.Player();
		if (statusShow)
			refreshBarTimer.start();
	}

	onBackPressed: {
		this.player.stop();
		this.visible = false;
		this.finished();
	}

	onSelectPressed: {
		this.paused = !this.paused;
		this.player.pause();
	}

	onStatusShowChanged: {
		if (statusShow) {
			playerObj.refreshBar();
			refreshBarTimer.start();
		}
		else 
			refreshBarTimer.stop();
	}

	onKeyPressed: {
		return true;
	}

	onUpPressed: {
		this.statusShow = !this.statusShow;
	}

	onDownPressed: {
		this.statusShow = !this.statusShow;
	}

	function playUrl(url) {
		log("Player: start playing " + url);
		this.visible = true;
		this.player.stop();
		this.player.playUrl(url);
		this.paused = false;
	}

	function stop() {
		log("Player: stop playing");
		this.player.stop();
	}

	function refreshBar() {
		log("Progress: " + playerObj.player.getProgress());
		log("Seekable progress: " + playerObj.player.getSeekableProgress());
		progressBar.width = playerObj.player.getProgress() / playerObj.duration * emptyBar.width;
		refreshBarTimer.restart();
	}

}
