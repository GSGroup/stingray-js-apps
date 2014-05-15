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

	onCompleted: {
		this.player = new media.Player();
	}

	onBackPressed: {
		this.player.stop();
		this.visible = false;
		this.finished();
	}

	onSelectPressed: {
		pause = !pause;
		this.player.pause();
	}

	function playUrl(url) {
		log("Player: start playing " + url);
		this.visible = true;
		this.player.playUrl(url);
		this.paused = false;
	}

	function stop() {
		log("Player: stop playing");
		this.player.stop();
	}
}
