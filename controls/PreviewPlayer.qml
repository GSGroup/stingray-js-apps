import PreviewPlayerButton;

Item {
	id: previewItem;

	signal finished(state);
	signal fullscreen();
	signal hDPressed();

	property string title;
	property bool isFullscreen: false;
	property int duration;
	property bool showHD: false;
	property bool useHD;

	onCompleted: {
		this.onShowHDChanged();
	}

	onUseHDChanged: {
		if (this.showHD) 
			controlsView.model.set(4, {source: "apps/controls/res/preview/" + (this.useHD ? "HD.png" : "LD.png")});
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
			anchors.left: parent.left;
//			anchors.right: parent.right;
			anchors.bottom: parent.bottom;
			width: (70 + 10) * 5;
			spacing: 10;
			orientation: ListView.Horizontal;
			model: 
			ListModel {
				ListElement { source:"apps/controls/res/preview/fullscreen.png";}
				ListElement { source: "apps/controls/res/preview/arrowPrev.png";}
				ListElement { source: "apps/controls/res/preview/arrowPause.png";}
				ListElement { source: "apps/controls/res/preview/arrowNext.png";}
			}

			delegate: PreviewPlayerButton{}

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
				case 4:
					previewItem.hDPressed();
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
