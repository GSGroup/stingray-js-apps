ListView {
	id: highlightListView;
	property int hlWidth: 0;
	property int hlHeight: 0;
	property Color highlightColor: highlightListView.activeFocus ? colorTheme.activeFocusColor : colorTheme.focusablePanelColor;

	Rectangle {
		id: highlight;
		color: highlightListView.highlightColor;
		visible: highlightListView.count;

		doHighlight: {
			if (!highlightListView || !highlightListView.model || !highlightListView.count)
				return;

			var futurePos = highlightListView.getPositionViewAtIndex(highlightListView.currentIndex, highlightListView.positionMode);
			var itemRect = highlightListView.getItemRect(highlightListView.currentIndex);

			itemRect.Move(-futurePos.X, -futurePos.Y);

			if (highlightListView.hlHeight) {
				this.height = highlightListView.hlHeight;
				this.y = itemRect.Top;
			} else {
				this.y = itemRect.Top;
				this.height = highlightListView.orientation == 0 ? highlightListView.height : itemRect.Height();
			}

			if (highlightListView.hlWidth) {
				this.width = highlightListView.hlWidth;
				this.x = itemRect.Left;
			} else {
				this.x = itemRect.Left;
				this.width = highlightListView.orientation == 0 ? itemRect.Width() : highlightListView.width;
			}
		}

		updateHighlight: {
			if (highlightListView.visible) {
				this.doHighlight();
				crunchTimer.restart();
			}
		}

		Behavior on color { animation: Animation { duration: 300; } }

		Behavior on y {
			id: highlightYAnim;
			animation: Animation {
				duration: 200;
			}
		}

		Behavior on height {
			animation: Animation {
				duration: 200;
			}
		}

		Behavior on x {
			id: highlightXAnim;
			animation: Animation {
				duration: 200;
			}
		}

	}

	Timer {	//TODO: Remove this when GetItemRect will work correctly.
		id: crunchTimer;
		interval: 200;
		repeat: false;
		running: false;

		onTriggered: {
			highlight.doHighlight();
			this.stop();
		}
	}

	onActiveFocusChanged: {
		if (activeFocus)
			highlight.updateHighlight();
	}

	resetHighlight: {
		highlight.x = 0;
		highlightXAnim.complete();
		highlight.y = 0;
		highlightYAnim.complete();
	}

	onVisibleChanged: {
		if (visible)
			this.resetHighlight();
	}

	onCountChanged:			{ if (count == 1) highlight.updateHighlight(); }	// Call on first element added.
	onWidthChanged: 		{ highlight.updateHighlight(); }
	onHeightChanged: 		{ highlight.updateHighlight(); }
	onCurrentIndexChanged:	{ highlight.updateHighlight(); }
}
