// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

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

			highlightListView.positionViewAtIndex(highlightListView.currentIndex, highlightListView.positionMode);

			var futurePos = {};
			futurePos.X = highlightGridView.getEndValue("contentX");
			futurePos.Y = highlightGridView.getEndValue("contentY");

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

		Behavior on x {
			id: highlightXAnim;
			animation: Animation {
				duration: 200;
			}
		}

		Behavior on height { animation: Animation { duration: 200; } }
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
