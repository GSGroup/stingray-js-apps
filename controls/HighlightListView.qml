// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

ListView {
	id: highlightListView;

	property bool showActiveFocus;
	property bool showPassiveFocus;
	property Color passiveFocusColor: colorTheme.activePanelColor;
	property bool showShadow;

	property int highlightWidth;
	property int highlightHeight;

	property Color highlightColor: highlightListView.activeFocus || highlightListView.showActiveFocus ? colorTheme.activeFocusColor :
		highlightListView.showPassiveFocus ? highlightListView.passiveFocusColor : colorTheme.focusablePanelColor;
	property int highlightBorderWidth;
	property Color highlightBorderColor;
	property bool highlightOverDelegates;

	Rectangle {
		id: highlight;

		color: highlightListView.highlightColor;

		borderWidth: highlightListView.highlightBorderWidth;
		borderColor: highlightListView.highlightBorderColor;

		visible: highlightListView.count;
		opacity: highlightListView.activeFocus || highlightListView.showActiveFocus || highlightListView.showPassiveFocus ? 1 : 0;
		z: highlightListView.highlightOverDelegates ? 100 : 0;

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

		Behavior on width { animation: Animation { duration: 200; easingType: EasingType.InOutQuad; } }

		Behavior on height { animation: Animation { duration: 200; easingType: EasingType.InOutQuad; } }
	}

	BorderShadow {
		anchors.fill: highlight;

		visible: highlightListView.count && highlightListView.showShadow;
		opacity: highlightListView.activeFocus || highlightListView.showActiveFocus ? 1 : 0;
		z: 1;
	}

	onWidthChanged: { this.updateHighlight(); }
	onHeightChanged: { this.updateHighlight(); }

	onActiveFocusChanged: {
		if (activeFocus)
			this.updateHighlight();
	}

	onCountChanged: {						// Call on first element added.
		if (count == 1)
			this.updateHighlight();
	}

	onContentWidthChanged: { this.updateHighlight(); }
	onContentHeightChanged: { this.updateHighlight(); }

	onHighlightWidthChanged: { this.updateHighlight(); }
	onHighlightHeightChanged: { this.updateHighlight(); }

	onCurrentIndexChanged:	{ this.updateHighlight(); }

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

	updateHighlight: {
		if (!this.visible || this.count <= 0)
			return;

		this.setContentPositionAtIndex(this.currentIndex, this.positionMode);

		var futurePos = {};
		futurePos.X = this.getEndValue("contentX");
		futurePos.Y = this.getEndValue("contentY");

		var itemRect = this.getDelegateRect(this.currentIndex);

		itemRect.Move(-futurePos.X, -futurePos.Y);

		if (this.highlightWidth)
		{
			highlight.width = this.highlightWidth;
			highlight.x = itemRect.Left;
		}
		else
		{
			highlight.x = itemRect.Left;
			highlight.width = this.orientation == 0 ? itemRect.Width() : this.width;
		}

		if (this.highlightHeight)
		{
			highlight.height = this.highlightHeight;
			highlight.y = itemRect.Top;
		}
		else
		{
			highlight.y = itemRect.Top;
			highlight.height = this.orientation == 0 ? this.height : itemRect.Height();
		}
	}
}
