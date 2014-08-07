import "controls/media.js" as media;
import controls.Text;
import controls.Spinner;

Player : Item {
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
			height: parent.height / 20;
			anchors.bottom: parent.bottom;
			anchors.left: parent.left;
			anchors.right: parent.right;
			anchors.bottomMargin: 20;

			Rectangle {
				id: seekBar;
				color: colorTheme.activeBackgroundColor;
				anchors.margins: parent.borderWidth;
				anchors.top: parent.top;
				anchors.left: parent.left;
				anchors.bottom: parent.bottom;
				Behavior on x {animation: Animation {id: seekAnim; duration: 200;} }
			}

			Rectangle {
				id: progressBar;
				color: colorTheme.activeBorderColor;
				anchors.margins: parent.borderWidth;
				anchors.top: parent.top;
				anchors.left: parent.left;
				anchors.bottom: parent.bottom;
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
				id: curTimeText;
				visible: !playerObj.preview;
				anchors.top: progressBar.bottom;
				anchors.right: emptyBar.right;
				anchors.topMargin: 5;
				color: "#e0e000"; //colorTheme.activeBorderColor;
				style: Shadow;
				text: playerObj.fullTimeStr;
				z: 1000;
			}

			Text {
				id: seekTimeText;
				anchors.bottom: cursorBar.top;
				anchors.horizontalCenter: cursorBar.horizontalCenter;
				style: Shadow;
				color: colorTheme.activeTextColor;
				visible: cursorBar.visible;
				font: playerObj.preview ? smallFont : mainFont;
				//fixme gognocode
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
				anchors.topMargin: playerObj.preview ? -30 : -45;

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
				anchors.margins: parent.borderWidth;
				anchors.left: parent.left;
				anchors.leftMargin: playerObj.cursorDist;
				width: 10;
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
			if (playerObj.duration >= 0) {
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
		log("Progress: " + p);
		log("Seekable progress: " + playerObj.player.getSeekableRangeEnd());
		if (p == 0 && this.seeking)
			return;
		this.seeking = false;
		progressBar.width = p / playerObj.duration * emptyBar.width;
//		seekBar.width = playerObj.player.getSeekableRangeEnd() / playerObj.duration * emptyBar.width;
	}

}

BorderedImageModel : ListModel {
	property string source;
}

BorderedImage : Panel {
	borderWidth: 1;
	borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.disabledBorderColor;
	width: 70;
	height: 70;

	SelectionGradient {
//		anchors.centerIn: parent;
		anchors.margins: 1;
		opacity: parent.activeFocus ? 1 : 0;
	}
	
	Image {
		anchors.centerIn: parent;
		source: model.source;
	}

}

PreviewPlayer : Item {
	id: previewItem;

	signal finished(state);
	signal fullscreen();

	property string title;
	property bool isFullscreen: false;
	property int duration;

	onActiveFocusChanged: {
		if (activeFocus) 
			controls.setFocus();
	}

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
		preview: !parent.isFullscreen;
//		duration: parent.duration;

		onFinished: {
			previewPlayer.focus = false;
			previewItem.finished(state);
			previewItem.isFullscreen = false;
//			previewPlayer.statusShow = true;
//			previewPlayer.statusHold = true;
			controls.opacity = 1;
		}

		onPausedChanged: {
			controlsView.model.set(2, {source: "apps/controls/res/preview/arrow" + (!paused ? "Pause.png" : "Play.png")});
		}

		onCursorVisibleChanged: {
			controlsView.model.set(2, {source: "apps/controls/res/preview/arrow" + (!cursorVisible ? "Pause.png" : "Play.png")});
		}
	}

	Item {
		id: controls;
		anchors.bottom: parent.bottom;
		anchors.left: parent.left;
		anchors.right: parent.right;
		height: 70;
		clip: true;
		focus: true;
		opacity: 1;
		z: 1000;

		MainText {
			anchors.verticalCenter: parent.verticalCenter;
			anchors.left: parent.right;
			anchors.leftMargin: -158;
			anchors.topMargin: 3;
			text: previewPlayer.curTimeStr;
			color: "#e0e000";
		}

		MainText {
			anchors.verticalCenter: parent.verticalCenter;
			anchors.right: parent.right;
			anchors.topMargin: 3;
			text: (previewPlayer.fullTimeStr.length ? "/ " : "") + previewPlayer.fullTimeStr;
			color: "#e0e000";
		}
		
		ListView {
			id: controlsView;
			anchors.top: parent.top;
			anchors.left: parent.left;
//			anchors.right: parent.right;
			anchors.bottom: parent.bottom;
			width: (70 + 10) * 4;
			spacing: 10;
			orientation: ListView.Horizontal;
			model: 
			ListModel {
				ListElement { source:"apps/controls/res/preview/fullscreen.png";}
				ListElement { source: "apps/controls/res/preview/arrowPrev.png";}
				ListElement { source: "apps/controls/res/preview/arrowPause.png";}
				ListElement { source: "apps/controls/res/preview/arrowNext.png";}
			}

			delegate: BorderedImage{}


			onSelectPressed: {
				switch (currentIndex) {
				case 0:
					previewPlayer.focus = true;
	//				previewPlayer.anchors.fill = mainWindow;
					previewItem.isFullscreen = true;
	//				previewPlayer.statusShow = false;
	//				previewPlayer.statusHold = false;
					previewPlayer.setFocus();
					previewItem.fullscreen();
					controls.opacity = 0;
					break;
				case 1:
					previewPlayer.onLeftPressed();
					break;
				case 2:
					previewPlayer.onSelectPressed();
					break;
				case 3:
					previewPlayer.onRightPressed();
					break;
				}
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
