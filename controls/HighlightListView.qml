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

	property int highlightWidthAnimationDuration: contentXAnimationDuration;
	property int highlightHeightAnimationDuration: contentYAnimationDuration;

	Rectangle {
		id: highlight;

		property int delegateX;
		property int delegateY;

		property bool disableContentAnimation;

		x: delegateX - highlightListView.contentX;
		y: delegateY - highlightListView.contentY;

		color: highlightListView.highlightColor;

		borderWidth: highlightListView.highlightBorderWidth;
		borderColor: highlightListView.highlightBorderColor;

		visible: highlightListView.count;
		opacity: highlightListView.activeFocus || highlightListView.showActiveFocus || highlightListView.showPassiveFocus ? 1 : 0;
		z: highlightListView.highlightOverDelegates ? 100 : 0;

		Behavior on delegateX {
			id: highlightXAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightListView.contentXAnimationDuration;
				easingType: highlightListView.contentXAnimationType;
			}
		}

		Behavior on delegateY {
			id: highlightYAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightListView.contentYAnimationDuration;
				easingType: highlightListView.contentYAnimationType;
			}
		}

		Behavior on width {
			id: highlightWidthAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightListView.highlightWidthAnimationDuration;
				easingType: highlightListView.contentXAnimationType;
			}
		}

		Behavior on height {
			id: highlightHeightAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightListView.highlightHeightAnimationDuration;
				easingType: highlightListView.contentYAnimationType;
			}
		}

		Behavior on color {
			id: highlightColorAnim;

			animation: Animation {
				duration: 300;
			}
		}
	}

	BorderShadow {
		anchors.fill: highlight;

		visible: highlightListView.count && highlightListView.showShadow;
		opacity: highlightListView.activeFocus || highlightListView.showActiveFocus ? 1 : 0;
		z: 1;
	}

	function onRowsInserted(begin, end) {
		if (this.currentIndex >= begin)
			this.updateHighlight();
	}

	function onRowsChanged(begin, end) {
		if (this.currentIndex >= begin)
			this.updateHighlight();
	}

	function onRowsRemoved(begin, end) {
		if (this.currentIndex >= begin)
			this.updateHighlight();
	}

	function onEnableContentAnimations(enable) {
		highlight.disableContentAnimation = !enable;
	}

	onWidthChanged: { this.updateHighlight(); }
	onHeightChanged: { this.updateHighlight(); }

	onVisibleChanged: { this.updateHighlight(); }

	onContentWidthChanged: { this.updateHighlight(); }
	onContentHeightChanged: { this.updateHighlight(); }

	onHighlightWidthChanged: { this.updateHighlight(); }
	onHighlightHeightChanged: { this.updateHighlight(); }

	onCurrentIndexChanged:	{ this.updateHighlight(); }

	completeHighlightAnimation: {
		highlightXAnim.complete();
		highlightYAnim.complete();

		highlightWidthAnim.complete();
		highlightHeightAnim.complete();

		highlightColorAnim.complete();
	}

	updateHighlight: {
		if (!this.visible || this.count <= 0)
			return;

		var delegateRect = this.getDelegateRect(this.currentIndex);

		if (this.highlightWidth)
		{
			highlight.width = this.highlightWidth;
			highlight.delegateX = delegateRect.Left;
		}
		else
		{
			highlight.delegateX = delegateRect.Left;
			highlight.width = this.orientation == 0 ? delegateRect.Width() : this.width;
		}

		if (this.highlightHeight)
		{
			highlight.height = this.highlightHeight;
			highlight.delegateY = delegateRect.Top;
		}
		else
		{
			highlight.delegateY = delegateRect.Top;
			highlight.height = this.orientation == 0 ? this.height : delegateRect.Height();
		}
	}
}
