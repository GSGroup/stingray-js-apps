import controls.PlaybackControl;
import controls.ProgressBar;

Item {
	id: playbackProgressItem;
	property bool hideable: false;
	property int gear: 0;
	//property TimeDuration seekProgress;
	//property TimeDuration barProgress: gear == 0 ? progress : seekProgress;

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
			if (playbackProgressItem.gear.Ref() != 0)
				playbackProgressItem.Seek(playbackProgressItem.seekProgress.Ref());
			playbackProgressItem.resetSeek();
		}
	}

	ProgressBar {
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.bottom: controlPanel.top;
		anchors.bottomMargin: 2;
		height: 5;
		color: argile.setAlpha(barColor, 0.3);
		barColor: colorTheme.accentColor;
		//progress: argile.milliseconds(playbackProgressItem.duration) > 0 ? 1.0 * argile.milliseconds(playbackProgressItem.barProgress) / (float) argile.milliseconds(playbackProgressItem.duration) : 0;
		clip: false;
		animationDuration: 100;
		z: 2;

		Rectangle {
			//anchors.horizontalCenter: filledArea.right;
			//anchors.verticalCenter: parent.verticalCenter;
			//height: 44;
			//width: height;
			//radius: height / 2;
			//color: argile.setAlpha(colorTheme.accentColor, 0.5);
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
		}
	}

	Rectangle {
		id: controlPanel;
		//property bool showHours: argile.milliseconds(playbackProgressItem.duration) > 3600000;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.bottom: parent.bottom;
		height: 60;
		color: colorTheme.activePanelColor;

		MainText {
			anchors.verticalCenter: parent.verticalCenter;
			anchors.left: parent.left;
			anchors.leftMargin: 10;
			//text: argile.toString(playbackProgressItem.progress, controlPanel.showHours ? "hh:mm:ss" : "mm:ss");
			//visible: argile.milliseconds(playbackProgressItem.duration) > 0;
		}

		MainText {
			anchors.verticalCenter: parent.verticalCenter;
			anchors.right: parent.right;
			anchors.rightMargin: 10;
			//text: argile.toString(playbackProgressItem.duration, controlPanel.showHours ? "hh:mm:ss" : "mm:ss");
			//visible: argile.milliseconds(playbackProgressItem.duration) > 0;
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
					visible: controls.activeFocus;
					color: colorTheme.activeFocusColor;
					opacity: visible ? 1 : 0;

					onXChanged:			{ hideTimer.restart(); }
					onVisibleChanged:	{ highLighXanim.complete(); }

					Behavior on x { animation: Animation { id:highLighXanim; duration: 300; easingType: EasingType.OutCirc; } }
					Behavior on opacity { animation: Animation { duration: 100; } }
				}
			}

			PlaybackControl {
				id: rwBtn;
				source: "res/apps/player/ico_rw.png";

				onActiveFocusChanged: { playbackProgressItem.resetSeek(); }
				onSelectPressed:	{ self.press(); }
				onLeftPressed:		{ self.press(); }

				press: {
					//hideTimer.restart();
					//seekTimer.restart();
					//if (playbackProgressItem.gear.Ref() < 0)
						//playbackProgressItem.gear -= 2;
					//else {
						//playbackProgressItem.seekProgress = playbackProgressItem.progress;
						//playbackProgressItem.gear = -1;
					//}
					//playbackProgressItem.seekProgress.Ref() = std::max(playbackProgressItem.seekProgress.Ref() + stingray::TimeDuration::FromMilliseconds(playbackProgressItem.gear * 1000), stingray::TimeDuration());
				}
			}

			PlaybackControl {
				id: playBtn;
				//source: argile.toString("res/apps/player/ico_") + (playbackProgressItem.state != MediaSession.State.Playing ? "play" : "pause") + ".png";

				onSelectPressed: {
					//hideTimer.restart();
					//playbackProgressItem.PlayPause();
				}
			}

			PlaybackControl {
				id: ffBtn;
				source: "res/apps/player/ico_ff.png";

				onActiveFocusChanged: { playbackProgressItem.resetSeek(); }
				onSelectPressed:	{ this.press(); }
				onRightPressed:		{ this.press(); }

				press: {
					//hideTimer.restart();
					//seekTimer.restart();
					//if (playbackProgressItem.gear.Ref() > 0)
						//playbackProgressItem.gear += 2;
					//else {
						//playbackProgressItem.seekProgress = playbackProgressItem.progress;
						//playbackProgressItem.gear = 1;
					//}

					//playbackProgressItem.seekProgress.Ref() = std::min(playbackProgressItem.seekProgress.Ref() + stingray::TimeDuration::FromMilliseconds(playbackProgressItem.gear * 1000), playbackProgressItem.duration.Ref());
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

	resetSeek: {
		//gear = 0;
		//seekProgress = stingray::TimeDuration();
		//seekTimer.stop();
	}

	onHideableChanged: {
		//if (!hideable)
			//self.visible = true;
	}

	onVisibleChanged: {
		//self.resetSeek();
		//if (visible)
			//playBtn.setFocus();
	}
}
