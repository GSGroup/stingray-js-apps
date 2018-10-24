Rectangle {
	id: rect;

	width: gameConsts.getBlockSize();
	height: gameConsts.getBlockSize();

	color: colorTheme.backgroundColor;

	Rectangle {
		id: innerRect;

		x: game.spaceBetweenBlocks;
		y: game.spaceBetweenBlocks;

		color: gameConsts.getColor(model.colorIndex);

		visible: model.value > 0;
	}
}
