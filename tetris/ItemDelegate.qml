import "tetrisConsts.js" as gameConsts;

Rectangle {
	id: rect;

	width: gameConsts.getBlockSize();
	height: gameConsts.getBlockSize();

	color: model.value === -1 ? colorTheme.globalBackgroundColor : colorTheme.backgroundColor;
	opacity: model.value === 0 ? 0.0 : 1.0;

	Rectangle {
		id: innerRect;

		x: gameConsts.getSpaceBetweenBlocks();
		y: gameConsts.getSpaceBetweenBlocks();

		width: gameConsts.getBlockSize() - gameConsts.getSpaceBetweenBlocks() * 2;
		height: gameConsts.getBlockSize() - gameConsts.getSpaceBetweenBlocks() * 2;

		color: gameConsts.getColor(model.colorIndex);

		visible: model.value > 0;
	}
}
