import "tetrisConsts.js" as gameConsts;

Rectangle {
	id: rect;

	property int animationDuration: 0;
	property bool isAnimated: model.needAnim;

	width: gameConsts.getBlockSize();
	height: gameConsts.getBlockSize();

	focus: true;

	color: model.value === -1 ? colorTheme.globalBackgroundColor : colorTheme.backgroundColor;
	opacity: model.value === 0 ? 0.0 : 1.0;

	Rectangle {
		id: innerRect;

		anchors.centerIn: parent;

		width: model.width;
		height: model.width;

		color: gameConsts.getColor(model.colorIndex);

		visible: model.value > 0;

		Behavior on width { animation: Animation { id: widthAnimation; duration: rect.animationDuration; easingType: ui.Animation.OutCirc; } }
		Behavior on height { animation: Animation { id: heightAnimation; duration: rect.animationDuration; easingType: ui.Animation.OutCirc; } }
	}

	onIsAnimatedChanged: {
		if (!rect.isAnimated)
		{
			widthAnimation.complete();
			heightAnimation.complete();
		}
	}
}
