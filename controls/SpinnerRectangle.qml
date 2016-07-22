Rectangle {
	borderWidth: 2;
	opacity: active;
	visible: true;
	width: radius * 2;
	height: width;
	color: colorTheme.activeFocusTop; 
	borderColor: color; 
	
	property float active;

	Behavior on opacity {
		animation: Animation {
			id: opacityAnimation;
			duration: 100;
		}
	}
}
