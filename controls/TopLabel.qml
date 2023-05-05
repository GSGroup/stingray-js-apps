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

	height: innerTexts.height;

	anchors.left: safeArea.left;
	anchors.right: safeArea.right;
	anchors.top: safeArea.top;

	Gradient {
		height: 108hph;

		anchors.left: mainWindow.left;
		anchors.right: mainWindow.right;
		anchors.top: mainWindow.top;
		anchors.bottomMargin: -30hph;

		GradientStop {
			position: 0;
			color: colorTheme.globalBackgroundColor;
		}

		GradientStop {
			position: 1;
			color: "#0000";
		}
	}

	Column {
		id: innerTexts;

		width: Math.min(topLabelProto.textWidth, Math.max(topLabelText.initialTextWidth, topLabelAdditionalText.initialTextWidth));

		anchors.top: parent.top;
		anchors.horizontalCenter: parent.horizontalCenter;

		spacing: 8hph;

		ElidedText {
			id: topLabelText;

			width: parent.width;
			height: paintedHeight;

			horizontalAlignment: dummyText.AlignHCenter;
			text: topLabelProto.text;
			font: titleFont;
		}

		ElidedText {
			id: topLabelAdditionalText;

			width: parent.width;
			height: paintedHeight;

			horizontalAlignment: dummyText.AlignHCenter;
			text: topLabelProto.additionalText;
			font: bodyFont;
		}
	}

	Text { id: dummyText; } // TODO: revert after STB-34119
}
