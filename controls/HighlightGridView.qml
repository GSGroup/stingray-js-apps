GridView {
	id: highlightGridView;

	BorderShadow3D {
		anchors.fill: highlight;
		opacity: highlightGridView.activeFocus ? 1 : 0;
		visible: highlightGridView.count;
	}

	Rectangle {
		id: highlight;
		opacity: parent.activeFocus && highlightGridView.count ? 1 : 0;
		color: colorTheme.activeFocusColor;

		updateHighlight: {
			this.doHighlight();
			crunchTimer.restart();
		}

		doHighlight: {
			if (!highlightGridView.model || !highlightGridView.model.count)
				return;

			var futurePos = highlightGridView.getPositionViewAtIndex(highlightGridView.currentIndex, highlightGridView.positionMode);
			var itemRect = highlightGridView.getItemRect(highlightGridView.currentIndex);
			itemRect.Move(-futurePos.X, -futurePos.Y);

			highlightXAnim.complete();
			highlightYAnim.complete();
			this.y = itemRect.Top;
			this.x = itemRect.Left;
			this.height = itemRect.Height();
			this.width =  itemRect.Width();
			if (this.y != itemRect.Top && this.x != itemRect.Left) {
				highlightXAnim.complete();
				highlightYAnim.complete();
			}
		}

		Behavior on y {
			id: highlightYAnim;
			animation: Animation {
				duration: 250;
				easingType: EasingType.InOutQuad;
			}
		}

		Behavior on x {
			id: highlightXAnim;
			animation: Animation {
				duration: 250;
				easingType: EasingType.InOutQuad;
			}
		}

		Behavior on width {
			animation: Animation {
				duration: 250;
				easingType: EasingType.InOutQuad;
			}
		}

		Behavior on height {
			animation: Animation {
				duration: 250;
				easingType: EasingType.InOutQuad;
			}
		}

		Behavior on opacity { animation: Animation { duration: 300; } }
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

	onContentHeightChanged:	{ highlight.updateHighlight(); }
	onContentWidthChanged:	{ highlight.updateHighlight(); }
	onCurrentIndexChanged:	{ highlight.updateHighlight(); }
	onCountChanged:			{ highlight.updateHighlight(); }
}
