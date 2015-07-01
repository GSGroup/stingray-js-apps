import PreviewPlayerButton;

Item {
	id: previewItem;
	signal finished(state);
	signal fullscreen();
	signal hDPressed();
	signal playPressed();
	property string title;
	property int duration;
	property bool useHD;
	property bool isFullscreen: false;
	property bool showHD: false;

	onUseHDChanged: {
		if (this.showHD) 
			controlsView.model.set(4, {source: "apps/controls/res/preview/" + (this.useHD ? "HD.png" : "SD.png")});
	}

	onShowHDChanged: {
		if (this.showHD && controlsView.count < 5)
			controlsView.model.append({});
		if (!this.showHD && controlsView.count == 5)
			controlsView.model.remove(4);
		this.onUseHDChanged();
	}

	onActiveFocusChanged: {
		if (activeFocus) 
			controls.setFocus();
	}

	Rectangle {
		anchors.fill: previewPlayer;
		color: "#000";
		visible: !parent.isFullscreen;
	}

	Player {
		id: previewPlayer;
		height: parent.isFullscreen ? mainWindow.height : (parent.height - controls.height - 10);
		anchors.top: parent.isFullscreen ? mainWindow.top : parent.top;
		anchors.left: parent.isFullscreen ? mainWindow.left : parent.left;
		anchors.right: parent.isFullscreen ? mainWindow.right : parent.right;
		focus: parent.isFullscreen;
		isFullscreen: parent.isFullscreen;
		duration: parent.duration;

		onFinished: {
			previewPlayer.focus = false;
			previewItem.finished(state);
			previewItem.isFullscreen = false;
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
		visible: !parent.isFullscreen;

		SmallText {
			anchors.verticalCenter: parent.verticalCenter;
			anchors.left: parent.right;
			anchors.leftMargin: -140;
			anchors.topMargin: 3;
			text: previewPlayer.curTimeStr;
			color: "#e0e000";
		}

		SmallText {
			anchors.verticalCenter: parent.verticalCenter;
			anchors.right: parent.right;
			anchors.topMargin: 3;
			text: (previewPlayer.fullTimeStr.length ? "/ " : "") + previewPlayer.fullTimeStr;
			color: "#e0e000";
		}
		
		ListView {
			id: controlsView;
			anchors.top: parent.top;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.bottom: parent.bottom;
			width: (70 + 10) * 5;
			spacing: 10;
			orientation: ListView.Horizontal;
			model: ListModel {
				ListElement { source: "apps/controls/res/preview/fullscreen.png";}
				ListElement { source: "apps/controls/res/preview/arrowPrev.png";}
				ListElement { source: "apps/controls/res/preview/arrowPause.png";}
				ListElement { source: "apps/controls/res/preview/arrowNext.png";}
			}

			delegate: PreviewPlayerButton{}

			onSelectPressed: {
				switch (currentIndex) {
				case 0:
					previewItem.isFullscreen = true;
					previewPlayer.setFocus();
					previewItem.fullscreen();
					break;
				case 1:
					previewPlayer.seek(-30000);
					break;
				case 2:
					if (previewPlayer.paused)
						previewItem.playPressed();
					else
						previewPlayer.pause();
					break;
				case 3:
					previewPlayer.seek(30000);
					break;
				case 4:
					previewItem.hDPressed();
					break;
				}
			}
		}
	}

	stop:			{ previewPlayer.stop(); }
	onCompleted:	{ this.onShowHDChanged(); }
	function playUrl(url)	{ previewPlayer.playUrl(url); }
}
