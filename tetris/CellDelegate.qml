Rectangle {
	id: rect;

	width: game.blockSize + game.spaceBetweenBlocks * 2;
	height: game.blockSize + game.spaceBetweenBlocks * 2;

	color: "#05090C";
	focus: false;

	visible: true;

	Rectangle{
		id: innerRect;

		x: game.spaceBetweenBlocks;
		y: game.spaceBetweenBlocks;

		width: game.blockSize;
		height: game.blockSize;

		color: "#FCE27E";
		focus: false;

		visible: true;

		Gradient {
			id: blockGradient;

			width: game.blockSize;

			anchors.fill: parent;

			GradientStop {
				id: blockGradientStart;

				position: 0;

				color: "#FDB2A5";
			}

			GradientStop {
				id: blockGradientEnd;

				position: 1;

				color: "#F95234";
			}
		}
	}
}
