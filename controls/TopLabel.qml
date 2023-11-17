// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
	id: topLabelProto;

	property int textWidth: width;
	property string text;
	property string additionalText;

	enum { AlignLeft, AlignRight, AlignHCenter };
	property int horizontalAlignment: AlignLeft;

	height: innerTexts.height;

	anchors.left: safeArea.left;
	anchors.leftMargin: 10hpw;
	anchors.right: safeArea.right;
	anchors.rightMargin: 10hpw;
	anchors.top: safeArea.top;
	anchors.topMargin: 10hph;

	Gradient {
		height: safeArea.y + 120hph;

		anchors.left: mainWindow.left;
		anchors.right: mainWindow.right;
		anchors.top: mainWindow.top;

		GradientStop {
			position: 0;
			color: "#000";
		}

		GradientStop {
			position: 1;
			color: "#0000";
		}
	}

	Column {
		id: innerTexts;

		width: Math.min(topLabelProto.textWidth, Math.max(topLabelText.initialTextWidth, topLabelAdditionalText.initialTextWidth));

		x: topLabelProto.horizontalAlignment == topLabelProto.AlignLeft ? 0 :
				topLabelProto.horizontalAlignment == topLabelProto.AlignRight ? topLabelProto.width - width :
				topLabelProto.width / 2 - width / 2;

		spacing: 8hph;

		ElidedText {
			id: topLabelText;

			width: parent.width;
			height: paintedHeight;

			horizontalAlignment: topLabelProto.horizontalAlignment == topLabelProto.AlignLeft ? ui.Text.HorizontalAlignment.AlignLeft :
					topLabelProto.horizontalAlignment == topLabelProto.AlignRight ? ui.Text.HorizontalAlignment.AlignRight :
					ui.Text.HorizontalAlignment.AlignHCenter;
			text: topLabelProto.text;
			font: titleFont;
		}

		ElidedText {
			id: topLabelAdditionalText;

			width: parent.width;
			height: paintedHeight;

			horizontalAlignment: topLabelProto.horizontalAlignment == topLabelProto.AlignHCenter ? ui.Text.HorizontalAlignment.AlignHCenter :
					topLabelProto.horizontalAlignment == topLabelProto.AlignLeft ? ui.Text.HorizontalAlignment.AlignLeft :
					ui.Text.HorizontalAlignment.AlignRight;
			text: topLabelProto.additionalText;
			font: subheadFont;
		}
	}
}
