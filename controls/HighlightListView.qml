// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

ListView {
	id: highlightListView;

	property int highlightWidth;
	property int highlightHeight;

	property Color highlightColor: highlightListView.activeFocus ? colorTheme.activeFocusColor : colorTheme.focusablePanelColor;

	Rectangle {
		id: highlight;

		color: highlightListView.highlightColor;

		visible: highlightListView.count;

		doHighlight: {
			if (!highlightListView || !highlightListView.model || !highlightListView.count)
				return;

			highlightListView.setContentPositionAtIndex(highlightListView.currentIndex, highlightListView.positionMode);

			var futurePos = {};
			futurePos.X = highlightGridView.getEndValue("contentX");
			futurePos.Y = highlightGridView.getEndValue("contentY");

			var itemRect = highlightListView.getDelegateRect(highlightListView.currentIndex);

			itemRect.Move(-futurePos.X, -futurePos.Y);

			if (highlightListView.highlightWidth)
			{
				this.width = highlightListView.highlightWidth;
				this.x = itemRect.Left;
			}
			else
			{
				this.x = itemRect.Left;
				this.width = highlightListView.orientation == 0 ? itemRect.Width() : highlightListView.width;
			}

			if (highlightListView.highlightHeight)
			{
				this.height = highlightListView.highlightHeight;
				this.y = itemRect.Top;
			}
			else
			{
				this.y = itemRect.Top;
				this.height = highlightListView.orientation == 0 ? highlightListView.height : itemRect.Height();
			}
		}

		updateHighlight: {
			if (highlightListView.visible)
			{
				this.doHighlight();
				crunchTimer.restart();
			}
		}

		Behavior on color { animation: Animation { duration: 300; } }

		Behavior on x {
			id: highlightXAnim;

			animation: Animation {
				duration: 200;
			}
		}

		Behavior on y {
			id: highlightYAnim;

			animation: Animation {
				duration: 200;
			}
		}

		Behavior on height { animation: Animation { duration: 200; } }
	}

	Timer {	//TODO: Remove this when GetDelegateRect will work correctly.
		id: crunchTimer;

		interval: 200;

		onTriggered: {
			highlight.doHighlight();
			this.stop();
		}
	}

	onWidthChanged: 		{ highlight.updateHighlight(); }
	onHeightChanged: 		{ highlight.updateHighlight(); }

	onActiveFocusChanged: {
		if (activeFocus)
			highlight.updateHighlight();
	}

	onCountChanged: {						// Call on first element added.
		if (count == 1)
			highlight.updateHighlight();
	}

	onCurrentIndexChanged:	{ highlight.updateHighlight(); }

	onVisibleChanged: {
		if (visible)
			this.resetHighlight();
	}

	resetHighlight: {
		highlight.x = 0;
		highlightXAnim.complete();
		highlight.y = 0;
		highlightYAnim.complete();
	}
}
