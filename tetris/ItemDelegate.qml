import "tetrisConsts.js" as gameConsts;

Rectangle {
	id: rect;

	property int animationDuration: 1000;

	width: gameConsts.getBlockSize();
	height: gameConsts.getBlockSize();

	color: model.value === -1 ? colorTheme.globalBackgroundColor : colorTheme.backgroundColor;
	opacity: model.value === 0 ? 0.0 : 1.0;

	Rectangle {
		id: innerRect;

		anchors.centerIn: parent;

		width: model.sizeW;
		height: model.sizeW;

		color: gameConsts.getColor(model.colorIndex);

		visible: model.value > 0;

		onWidthChanged: {
		}

		Behavior on width { animation: Animation { duration: rect.animationDuration; easingType: Animation.OutCirc;} }
		Behavior on height { animation: Animation { duration: rect.animationDuration; easingType: Animation.OutCirc;} }
	}
}
