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

		x: gameConsts.getSpaceBetweenBlocks();
		y: gameConsts.getSpaceBetweenBlocks();

		width: rect.width - gameConsts.getSpaceBetweenBlocks() * 2;
		height: rect.height - gameConsts.getSpaceBetweenBlocks() * 2;

		color: gameConsts.getColor(rect.blockColorIndex);

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
