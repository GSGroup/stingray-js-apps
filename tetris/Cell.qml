import "engine.js" as engine

Rectangle {
	id: rect;

	property int value: -1;
	property alias blockColor:innerRect.indexColor;

	width: game.blockSize;
	height: game.blockSize;

	color: colorTheme.globalBackgroundColor;

	visible: true;

	Rectangle{
		id: innerRect;

		property int indexColor: 0;

		x: game.spaceBetweenBlocks;
		y: game.spaceBetweenBlocks;

		width: game.blockSize - game.spaceBetweenBlocks * 2;
		height: game.blockSize - game.spaceBetweenBlocks * 2;

		visible: rect.value > 0;

		Gradient {
			id: blockGradient;

			width: parent.width;

			anchors.fill: parent;

			orientation: Gradient.Horizontal;

			GradientStop {
				id: blockGradientStart;

				position: 0;

				color: engine.getGradientStart(innerRect.indexColor);
			}

			GradientStop {
				id: blockGradientEnd;

				position: 1;

				color: engine.getGradientEnd(innerRect.indexColor);
			}
		}
	}
}
