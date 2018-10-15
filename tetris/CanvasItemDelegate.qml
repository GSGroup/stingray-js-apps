Rectangle {
	id: rect;

	property int value: model.value;

	width: game.blockSize ;
	height: game.blockSize;

	color: colorTheme.backgroundColor;
	focus: false;

	visible: true;

	Rectangle {
		id: innerRect;

		x: game.spaceBetweenBlocks;
		y: game.spaceBetweenBlocks;

		width: game.blockSize - game.spaceBetweenBlocks * 2;
		height: game.blockSize - game.spaceBetweenBlocks * 2;

		focus: false;

		visible: parent.value > 0;

		Gradient {
			id: blockGradient;

			property string gradientStartColor: model.gradientStartColor;
			property string gradientStopColor: model.gradientStopColor;

			width: parent.width;

			anchors.fill: parent;

			orientation: Gradient.Horizontal;


			GradientStop {
				id: blockGradientStart;

				position: 0;

				color: blockGradient.gradientStartColor;
			}

			GradientStop {
				id: blockGradientEnd;

				position: 1;

				color: blockGradient.gradientStopColor;
			}
		}
	}
}
