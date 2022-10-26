// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

GridView {
	id: highlightGridView;

	property bool showActiveFocus;
	property bool showShadow: true;

	property Color highlightColor: colorTheme.activeFocusColor;

	property bool showBackground: true;
	property Color backgroundColor: highlightGridView.activeFocus ? colorTheme.activePanelColor : colorTheme.focusablePanelColor;
	property real backgroundOpacity: 1;

	property int highlightWidthAnimationDuration: contentXAnimationDuration;
	property int highlightHeightAnimationDuration: contentYAnimationDuration;

	Rectangle {
		id: innerBackground;

		width: Math.min(highlightGridView.width - 2, highlightGridView.contentWidth - 2);
		height: Math.min(highlightGridView.height, highlightGridView.contentHeight);

		color: highlightGridView.backgroundColor;

		visible: highlightGridView.showBackground;
		opacity: highlightGridView.backgroundOpacity;

		Behavior on color { animation: Animation { duration: 300; } }
	}

	BorderShadow {
		anchors.fill: highlight;

		visible: highlightGridView.count && highlightGridView.showShadow;
		opacity: highlightGridView.activeFocus || highlightGridView.showActiveFocus ? 1 : 0;
		z: 10;
	}

	Rectangle {
		id: highlight;

		property int delegateX;
		property int delegateY;

		property bool disableContentAnimation;

		x: delegateX - highlightGridView.contentX;
		y: delegateY - highlightGridView.contentY;

		color: highlightGridView.highlightColor;

		visible: highlightGridView.count;
		opacity: highlightGridView.activeFocus || highlightGridView.showActiveFocus ? 1 : 0;

		Behavior on delegateX {
			id: highlightXAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightGridView.contentXAnimationDuration;
				easingType: highlightGridView.contentXAnimationType;
			}
		}

		Behavior on delegateY {
			id: highlightYAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightGridView.contentYAnimationDuration;
				easingType: highlightGridView.contentYAnimationType;
			}
		}

		Behavior on width {
			id: highlightWidthAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightGridView.highlightWidthAnimationDuration;
				easingType: highlightGridView.contentXAnimationType;
			}
		}

		Behavior on height {
			id: highlightHeightAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightGridView.highlightHeightAnimationDuration;
				easingType: highlightGridView.contentYAnimationType;
			}
		}

		Behavior on opacity {
			id: highlightOpacityAnim;

			animation: Animation { duration: 300; }
		}
	}

	function onEnableContentAnimations(enable) {
		highlight.disableContentAnimation = !enable;
	}

	onVisibleChanged: { this.updateHighlight(); }

	onContentHeightChanged:	{ this.updateHighlight(); }
	onContentWidthChanged:	{ this.updateHighlight(); }

	onCurrentIndexChanged:	{ this.updateHighlight(); }
	onCountChanged:			{ this.updateHighlight(); }

	completeHighlightAnimation: {
		highlightXAnim.complete();
		highlightYAnim.complete();

		highlightWidthAnim.complete();
		highlightHeightAnim.complete();

		highlightOpacityAnim.complete();
	}

	updateHighlight: {
		if (!this.visible || this.count <= 0)
			return;

		var delegateRect = this.getDelegateRect(this.currentIndex);

		highlight.delegateX = delegateRect.Left;
		highlight.delegateY = delegateRect.Top;

		highlight.width =  delegateRect.Width();
		highlight.height = delegateRect.Height();
	}
}
