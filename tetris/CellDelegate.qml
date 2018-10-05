Rectangle {
	id: rect;

	width: game.cellSize + game.spaceBlocks * 2;
	height: game.cellSize + game.spaceBlocks * 2;

	color:"#000000";

	visible:true;

	Rectangle{
		id: innerRect;

		x: game.spaceBlocks;
		y: game.spaceBlocks;

		width: game.cellSize;
		height: game.cellSize;

		color:"#FCE27E";

		visible:true;
	}
}
