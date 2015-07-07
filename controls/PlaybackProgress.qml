import controls.PlaybackControl;
import controls.ProgressBar;

Item {
	id: playbackProgressItem;
	signal playPressed;
	signal pausePressed;
	signal fastForwardPressed;
	signal rewindPressed;
	property bool hideable: false;
	property bool isPlaying: false;
	property int gear: 0;
	property int duration;
	property int progress;
	property int barProgress: gear ? seekProgress : progress;
	property int seekProgress;
	property string curTimeStr: "";
	property string fullTimeStr: "";

	Timer {
		id: hideTimer;
		interval: 5000;
		running: playbackProgressItem.visible && playbackProgressItem.hideable;

		onTriggered: { playbackProgressItem.visible = false; }
	}

	//Timer {
		//id: seekTimer;
		//interval: 2000;

		//onTriggered: {
			//if (playbackProgressItem.gear != 0)
				//playbackProgressItem.Seek(playbackProgressItem.seekProgress.Ref());
			//playbackProgressItem.resetSeek();
		//}
	//}

	ProgressBar {
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.bottom: controlPanel.top;
		anchors.bottomMargin: 2;
		height: 5;
		barColor: colorTheme.accentColor;
		progress: playbackProgressItem.duration > 0 ? (1.0 * playbackProgressItem.barProgress) / playbackProgressItem.duration : 0;
		clip: false;
		animationDuration: 100;
		z: 2;

		//Rectangle {
			//anchors.horizontalCenter: filledArea.right;
			//anchors.verticalCenter: parent.verticalCenter;
			//height: 44;
			//width: height;
			//radius: height / 2;
			//color: colorTheme.accentColor;
			//opacity: 0.5;
			//visible: playbackProgressItem.gear != 0;

			//Rectangle {
				//anchors.centerIn: parent;
				//height: 28;
				//width: height;
				//radius: height / 2;
				//color: colorTheme.accentColor;

				//Item {
					//anchors.top: parent.top;
					//anchors.horizontalCenter: parent.horizontalCenter;
					//visible: playbackProgressItem.gear != 0;

					//Image {
						//id: triangle;
						//anchors.horizontalCenter: parent.horizontalCenter;
						//anchors.bottom: parent.top;
						//source: "res/apps/player/triangle.png";
						//fillMode: FillMode.PreserveAspectFit;
						//height: 15;
						//width: height * 2;
					//}

					//Rectangle {
						//id: bgRect;
						//anchors.bottom: triangle.top;
						//anchors.horizontalCenter: parent.horizontalCenter;
						//height: 30;
						//width: 80;
						//color: "#ffffff";
					//}

					//SmallText {
						//anchors.centerIn: bgRect;
						//color: "#000000";
						//text: argile.toString(playbackProgressItem.barProgress, "mm:ss");
					//}
				//}
			//}
		//}
	}

	Rectangle {
		id: controlPanel;
		property bool showHours: playbackProgressItem.duration > 3600000;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.bottom: parent.bottom;
		height: 60;
		color: colorTheme.activePanelColor;

		MainText {
			anchors.verticalCenter: parent.verticalCenter;
			anchors.left: parent.left;
			anchors.leftMargin: 10;
			text: playbackProgressItem.curTimeStr;
			visible: playbackProgressItem.duration > 0;
		}

		MainText {
			anchors.verticalCenter: parent.verticalCenter;
			anchors.right: parent.right;
			anchors.rightMargin: 10;
			text: playbackProgressItem.fullTimeStr;
			visible: playbackProgressItem.duration > 0;
		}

		Row {
			id: controls;
			height: parent.height;
			anchors.horizontalCenter: parent.horizontalCenter;
			focus: true;

			Item { //empty item
				height: 0;
				width: 0;

				BorderShadow {
					anchors.fill: highlighter;
					visible: controls.activeFocus;
				}

				Rectangle {
					id: highlighter;
					anchors.fill: rwBtn.activeFocus ? rwBtn : (playBtn.activeFocus ? playBtn : (ffBtn.activeFocus ? ffBtn : playBtn));
					visible: controls.activeFocus;
					color: colorTheme.activeFocusColor;
					opacity: visible ? 1 : 0;

					onVisibleChanged:	{ highLighXanim.complete(); }

					Behavior on x { animation: Animation { id:highLighXanim; duration: 150; } }
					Behavior on opacity { animation: Animation { duration: 100; } }
				}
			}

			PlaybackControl {
				id: rwBtn;
				source: "res/apps/player/ico_rw.png";

				onActiveFocusChanged:	{ playbackProgressItem.resetSeek(); }
				onSelectPressed:		{ this.press(); }
				onLeftPressed:			{ this.press(); }

				press: {
					playbackProgressItem.rewindPressed();
					hideTimer.restart();

					//seekTimer.restart();
					//if (playbackProgressItem.gear.Ref() < 0)
						//playbackProgressItem.gear -= 2;
					//else {
						//playbackProgressItem.seekProgress = playbackProgressItem.progress;
						//playbackProgressItem.gear = -1;
					//}
					//playbackProgressItem.seekProgress = std::max(playbackProgressItem.seekProgress.Ref() + playbackProgressItem.gear * 1000, 0);
				}
			}

			PlaybackControl {
				id: playBtn;
				source: "res/apps/player/ico_" + (!playbackProgressItem.isPlaying ? "play" : "pause") + ".png";

				onSelectPressed: {
					hideTimer.restart();
					playbackProgressItem.togglePlay();
				}
			}

			PlaybackControl {
				id: ffBtn;
				source: "res/apps/player/ico_ff.png";

				onActiveFocusChanged:	{ playbackProgressItem.resetSeek(); }
				onSelectPressed:		{ this.press(); }
				onRightPressed:			{ this.press(); }

				press: {
					playbackProgressItem.fastForwardPressed();
					hideTimer.restart();

					//seekTimer.restart();
					//if (playbackProgressItem.gear > 0)
						//playbackProgressItem.gear += 2;
					//else {
						//playbackProgressItem.seekProgress = playbackProgressItem.progress;
						//playbackProgressItem.gear = 1;
					//}

					//playbackProgressItem.seekProgress = std::min(playbackProgressItem.seekProgress + playbackProgressItem.gear * 1000, playbackProgressItem.duration.Ref());
				}
			}
		}
	}

	doFF:		{ ffBtn.press(); }
	doRewind:	{ rwBtn.press(); }

	onKeyPressed: {
		if (!visible)
			return false;

		if (key != "Back") {
			hideTimer.restart();
		} else {
			self.visible = false;
			return true;
		}
		return false;
	}

	togglePlay: {
		if (!this.isPlaying)
			this.playPressed();
		else
			this.pausePressed();
	}

	resetSeek: {
		this.gear = 0;
		this.seekProgress = 0;
		//seekTimer.stop();
		hideTimer.restart();
	}

	onHideableChanged: {
		if (!hideable)
			this.visible = true;
	}

	onVisibleChanged: {
		this.resetSeek();
		if (visible)
			playBtn.setFocus();
	}
}
