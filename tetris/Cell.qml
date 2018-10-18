import "engine.js" as engine

Rectangle {
	id: rect;

	property int value: -1;
	property int spaceBetweenBlocks : game.spaceBetweenBlocks;
	property alias blockColor: innerRect.indexColor;

	width: game.blockSize;
	height: game.blockSize;

	color: colorTheme.globalBackgroundColor;

	Rectangle{
		id: innerRect;

		property int indexColor: 0;

		x: rect.spaceBetweenBlocks;
		y: rect.spaceBetweenBlocks;

		width: rect.width - rect.spaceBetweenBlocks * 2;
		height: rect.height - rect.spaceBetweenBlocks * 2;

		visible: rect.value > 0;

		Gradient {
			id: blockGradient;

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
