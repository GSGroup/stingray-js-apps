Rectangle {
	id: rect;

	property int value: 0;

	width: game.blockSize ;
	height: game.blockSize;

	color: colorTheme.globalBackgroundColor;
	focus: false;

	visible: true;

	Rectangle{
		id: innerRect;

		x: game.spaceBetweenBlocks;
		y: game.spaceBetweenBlocks;

		width: game.blockSize - game.spaceBetweenBlocks * 2;
		height: game.blockSize - game.spaceBetweenBlocks * 2;

		focus: false;

		visible: rect.value > 0;

		Gradient {
			id: blockGradient;

			width: parent.width;

			anchors.fill: parent;

			orientation: Gradient.Horizontal;

			GradientStop {
				id: blockGradientStart;

				position: 0;

				color: "#E49C8B";
			}

			GradientStop {
				id: blockGradientEnd;

				position: 1;

				color: "#CE573D";
			}
		}
	}
}
