// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

GridView {
	id: highlightGridViewProto;

	property bool showActiveFocus;
	property bool showShadow: true;

	property bool showBackground: true;
	property Color backgroundColor: activeFocus ? colorTheme.activePanelColor : colorTheme.focusablePanelColor;
	property real backgroundOpacity: 1;

	property int highlightWidthAnimationDuration: contentXAnimationDuration;
	property int highlightHeightAnimationDuration: contentYAnimationDuration;

	Rectangle {
		id: innerBackground;

		width: Math.min(highlightGridViewProto.width, highlightGridViewProto.contentWidth);
		height: Math.min(highlightGridViewProto.height, highlightGridViewProto.contentHeight);

		color: highlightGridViewProto.backgroundColor;

		visible: highlightGridViewProto.showBackground;
		opacity: highlightGridViewProto.backgroundOpacity;

		Behavior on color { animation: Animation { duration: 300; } }
	}

	BorderShadow {
		id: borderShadow;

		x: highlight.x;
		y: highlight.y;

		width: highlight.width;
		height: highlight.height;

		visible: highlightGridViewProto.count && highlightGridViewProto.showShadow;
		opacity: highlightGridViewProto.activeFocus || highlightGridViewProto.showActiveFocus ? 1 : 0;
		z: 10;
	}

	Rectangle {
		id: highlight;

		property int delegateX;
		property int delegateY;

		property bool disableContentAnimation;

		x: delegateX - highlightGridViewProto.contentX;
		y: delegateY - highlightGridViewProto.contentY;

		color: colorTheme.activeFocusColor;

		visible: highlightGridViewProto.count;
		opacity: highlightGridViewProto.activeFocus || highlightGridViewProto.showActiveFocus ? 1 : 0;

		Behavior on delegateX {
			id: highlightXAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightGridViewProto.contentXAnimationDuration;
				easingType: highlightGridViewProto.contentXAnimationType;
			}
		}

		Behavior on delegateY {
			id: highlightYAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightGridViewProto.contentYAnimationDuration;
				easingType: highlightGridViewProto.contentYAnimationType;
			}
		}

		Behavior on width {
			id: highlightWidthAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightGridViewProto.highlightWidthAnimationDuration;
				easingType: highlightGridViewProto.contentXAnimationType;
			}
		}

		Behavior on height {
			id: highlightHeightAnim;

			animation: Animation {
				duration: highlight.disableContentAnimation ? 0 : highlightGridViewProto.highlightHeightAnimationDuration;
				easingType: highlightGridViewProto.contentYAnimationType;
			}
		}

		Behavior on opacity {
			id: highlightOpacityAnim;

			animation: Animation { duration: 300; }
		}
	}

	onEnableContentAnimations: (enable) {
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
