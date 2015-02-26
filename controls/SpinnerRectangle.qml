Rectangle {
	borderWidth: 2;
	opacity: active;
	visible: true;
	radius: height / 2;
	width: circleRadius * 2;
	height: width;
	color: colorTheme.activeFocusTop; 
	borderColor: color; 
	
	property float active;
	property float circleRadius;

	Behavior on opacity {
		animation: Animation {
			id: opacityAnimation;
			duration: 100;
		}
	}
}
