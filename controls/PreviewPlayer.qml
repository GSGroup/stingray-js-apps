import PreviewPlayerButton;

Item {
	id: previewItem;
	signal finished(state);
	signal stopped();
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
			controlsView.model.set(4, { source: "apps/controls/res/preview/" + (this.useHD ? "HD.png" : "SD.png") });
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
		title: parent.title;

		onStopped: {
			previewPlayer.focus = false;
			previewItem.stopped();
			previewItem.isFullscreen = false;
		}

		onFinished: {
			previewPlayer.focus = false;
			previewItem.finished(state);
			previewItem.isFullscreen = false;
		}

		updateIcon: {
			controlsView.model.set(2, { source: "apps/controls/res/preview/arrow" + (!paused && !isStopped ? "Pause.png" : "Play.png") });
		}

		onIsStoppedChanged:	{ updateIcon(); }
		onPausedChanged:	{ updateIcon(); }
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

		ListView {
			id: controlsView;
			anchors.top: parent.top;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.bottom: parent.bottom;
			width: (70 + 10) * count;
			spacing: 10;
			orientation: ListView.Horizontal;
			delegate: PreviewPlayerButton { }
			model: ListModel {
				ListElement { source: "apps/controls/res/preview/fullscreen.png"; }
				ListElement { source: "apps/controls/res/preview/arrowPrev.png"; }
				ListElement { source: "apps/controls/res/preview/arrowPause.png"; }
				ListElement { source: "apps/controls/res/preview/arrowNext.png"; }
			}

			onSelectPressed: {
				switch (currentIndex) {
				case 0:
					previewItem.isFullscreen = true;
					previewPlayer.setFocus();
					previewItem.fullscreen();
					if (previewPlayer.isStopped)
						previewItem.playPressed();
					break;
				case 1:
					previewPlayer.seek(-30000);
					break;
				case 2:
					if (previewPlayer.isStopped)
						previewItem.playPressed();
					else
						previewPlayer.togglePlay();
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

	stop:					{ previewPlayer.stop(); }
	onCompleted:			{ this.onShowHDChanged(); }
	function playUrl(url)	{ previewPlayer.playUrl(url); }
}
