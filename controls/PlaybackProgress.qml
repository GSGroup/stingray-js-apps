import controls.PlaybackControl;
import controls.ProgressBar;

Item {
	id: playbackProgressItem;
	signal playPressed;
	signal pausePressed;
	signal seeked(position);
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

	Timer {
		id: seekTimer;
		interval: 2000;

		onTriggered: {
			if (playbackProgressItem.gear != 0)
				playbackProgressItem.seeked(playbackProgressItem.seekProgress);
			playbackProgressItem.gear = 0;
		}
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

					onVisibleChanged: { highLighXanim.complete(); }

					Behavior on x { animation: Animation { id:highLighXanim; duration: 150; } }
					Behavior on opacity { animation: Animation { duration: 100; } }
				}
			}

			PlaybackControl {
				id: rwBtn;
				source: "res/apps/player/ico_rw.png";

				onSelectPressed:		{ this.press(); }
				onLeftPressed:			{ this.press(); }

				press: {
					if (playbackProgressItem.gear < 0)
						playbackProgressItem.gear -= 2;
					else
						playbackProgressItem.gear = -1;
					var val = playbackProgressItem.seekProgress + playbackProgressItem.gear * 1000;
					playbackProgressItem.seekProgress = val > 0 ? val : 0;
					seekTimer.restart();
					hideTimer.restart();
					playbackProgressItem.updateSeekText();
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

				onSelectPressed:		{ this.press(); }
				onRightPressed:			{ this.press(); }

				press: {
					if (playbackProgressItem.gear > 0)
						playbackProgressItem.gear += 2;
					else
						playbackProgressItem.gear = 1;

					var val = playbackProgressItem.seekProgress + playbackProgressItem.gear * 1000;
					playbackProgressItem.seekProgress = val < playbackProgressItem.duration ? val : playbackProgressItem.duration;
					seekTimer.restart();
					hideTimer.restart();
					playbackProgressItem.updateSeekText();
				}
			}
		}
	}

	ProgressBar {
		id: seekProgressBar;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.bottom: controlPanel.top;
		anchors.bottomMargin: 2;
		height: 5;
		barColor: colorTheme.accentColor;
		progress: playbackProgressItem.duration > 0 ? (1.0 * playbackProgressItem.barProgress) / playbackProgressItem.duration : 0;
		animationDuration: 100;
		clip: false;
	}

	Rectangle {
		id: seekCursor;
		anchors.horizontalCenter: filledArea.right;
		anchors.verticalCenter: seekProgressBar.verticalCenter;
		height: 44;
		width: height;
		radius: height / 2;
		color: colorTheme.accentColor;
		opacity: 0.5;
		visible: playbackProgressItem.gear != 0;

		Rectangle {
			anchors.centerIn: parent;
			height: 28;
			width: height;
			radius: height / 2;
			color: colorTheme.accentColor;
		}
	}

	Item {
		anchors.top: seekCursor.top;
		anchors.horizontalCenter: seekCursor.horizontalCenter;
		visible: playbackProgressItem.gear != 0;

		Image {
			id: triangle;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.bottom: parent.top;
			source: "res/apps/player/triangle.png";
			fillMode: Image.PreserveAspectFit;
			height: 15;
			width: height * 2;
		}

		Rectangle {
			id: bgRect;
			anchors.bottom: triangle.top;
			anchors.horizontalCenter: parent.horizontalCenter;
			height: 30;
			width: seekText.paintedWidth + 20;
			color: "#fff";
		}

		SmallText {
			id: seekText;
			anchors.centerIn: bgRect;
			color: "#000";
		}
	}

	doFF:		{ ffBtn.press(); }
	doRewind:	{ rwBtn.press(); }

	updateSeekText: {
		var p = this.seekProgress;

		seekText.text = "";
		if (p >= 0) {
			//fixme: gognocode
			p /= 1000;
			if (p < 0)
				return;

			var h = Math.floor(p / 3600);
			seekText.text = h > 0 ? h + ":" : "";
			p -= h * 3600;
			seekText.text +=
							(p / 60 >= 10 ? "" : "0") +
								Math.floor(p / 60) + ":" + 
							(p % 60 >= 10 ? "" : "0") + 
								Math.floor(p % 60);
		}
	}

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
		seekTimer.stop();
		hideTimer.restart();
	}

	onHideableChanged: {
		if (!hideable)
			this.visible = true;
	}

	onVisibleChanged: {
		if (visible) {
			playbackProgressItem.seekProgress = playbackProgressItem.progress;
			playBtn.setFocus();
		} else {
			this.resetSeek();
		}
	}

	show: {
		this.visible = true;
		hideTimer.restart();
	}

	hide: {
		this.visible = false;
	}
}
