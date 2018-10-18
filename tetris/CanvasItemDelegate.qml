Rectangle {
	id: rect;

	property int value: model.value;

	width: game.blockSize ;
	height: game.blockSize;

	color: colorTheme.backgroundColor;

	Rectangle {
		id: innerRect;

		x: game.spaceBetweenBlocks;
		y: game.spaceBetweenBlocks;

		width: rect.width - game.spaceBetweenBlocks * 2;
		height: rect.height - game.spaceBetweenBlocks * 2;

		visible: rect.value > 0;

		Gradient {
			id: blockGradient;

			orientation: Gradient.Horizontal;

			GradientStop {
				id: blockGradientStart;

				position: 0;

				color: model.gradientStartColor;
			}

			GradientStop {
				id: blockGradientEnd;

				position: 1;

				color: model.gradientStopColor;
			}
		}
	}
}
