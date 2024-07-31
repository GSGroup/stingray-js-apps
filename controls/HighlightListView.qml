// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.MovingArrows;

ListView {
	id: highlightListViewProto;

	property bool showActiveFocus;
	property bool showPassiveFocus: true;
	property Color passiveFocusColor: colorTheme.activePanelColor;
	property bool showShadow;
	property bool showArrows;

	property int highlightWidth;
	property int highlightHeight;

	property Color highlightColor: activeFocus || showActiveFocus ? colorTheme.activeFocusColor : showPassiveFocus ? passiveFocusColor : colorTheme.focusablePanelColor;
	property int highlightBorderWidth;
	property Color highlightBorderColor;
	property bool highlightOverDelegates;
	property bool highlightVisible: count;

	property int highlightWidthAnimationDuration: contentXAnimationDuration;
	property int highlightHeightAnimationDuration: contentYAnimationDuration;

	Rectangle {
		id: highlight;

		property int delegateX;
		property int delegateY;

		property bool disableContentAnimation;

		x: delegateX - highlightListViewProto.contentX;
		y: delegateY - highlightListViewProto.contentY;

		color: highlightListViewProto.highlightColor;

		borderWidth: highlightListViewProto.highlightBorderWidth;
		borderColor: highlightListViewProto.highlightBorderColor;

		visible: highlightListViewProto.highlightVisible;
		opacity: highlightListViewProto.activeFocus || highlightListViewProto.showActiveFocus || highlightListViewProto.showPassiveFocus ? 1 : 0;
		z: highlightListViewProto.highlightOverDelegates ? 100 : 0;

		Behavior on delegateX {
			id: highlightXAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightListViewProto.contentXAnimationDuration;
				easingType: highlightListViewProto.contentXAnimationType;
			}
		}

		Behavior on delegateY {
			id: highlightYAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightListViewProto.contentYAnimationDuration;
				easingType: highlightListViewProto.contentYAnimationType;
			}
		}

		Behavior on width {
			id: highlightWidthAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightListViewProto.highlightWidthAnimationDuration;
				easingType: highlightListViewProto.contentXAnimationType;
			}
		}

		Behavior on height {
			id: highlightHeightAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightListViewProto.highlightHeightAnimationDuration;
				easingType: highlightListViewProto.contentYAnimationType;
			}
		}

		Behavior on color {
			id: highlightColorAnim;

			animation: Animation {
				duration: 300;
			}
		}

		MovingArrows { showArrows: highlightListViewProto.showArrows; }
	}

	BorderShadow {
		anchors.fill: highlight;

		visible: highlightListViewProto.count && highlightListViewProto.showShadow;
		opacity: highlightListViewProto.activeFocus || highlightListViewProto.showActiveFocus ? 1 : 0;
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
