import "tetrisConsts.js" as gameConsts;

Rectangle {
	id: rect;

	property int animationInterval: 0;

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

		Behavior on width {
			animation: Animation {
				id: widthAnimation;

				duration: rect.animationInterval;
			}
		}

		Behavior on height {
			animation: Animation {
				id: heightAnimation;

				duration: rect.animationInterval;
			}
		}
	}
}
