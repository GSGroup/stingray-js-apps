SpinnerRectangle : Rectangle {
	borderWidth: 2;
	opacity: 0.5;
	visible: true;

	Behavior on opacity {
		animation: Animation {
			id: opacityAnimation;
			duration: 300;
		}
	}

	function fadeIn() {
		this.opacity = 1;
	}
	function fadeOut() {
		this.opacity = 0.5;
	}
}

Spinner : Row {
	id: spinner;
	width: 60;
	height: width / 3;
	property int activeSpinner;
	property Color color;
	property Color borderColor;
	color: colorTheme.activeBackgroundColor; 
	borderColor: colorTheme.activeBorderColor; 

	spacing: 2;
	collapseEmptyItems: false;

	SpinnerRectangle { id: rect1; width: parent.width / 3; height: parent.height; color: spinner.color; borderColor: spinner.borderColor; }
	SpinnerRectangle { id: rect2; width: parent.width / 3; height: parent.height; color: spinner.color; borderColor: spinner.borderColor; }
	SpinnerRectangle { id: rect3; width: parent.width / 3; height: parent.height; color: spinner.color; borderColor: spinner.borderColor; }

	function UpdateRectangle() {
		switch(this.activeSpinner) {
		case 0: rect3.fadeOut(); rect1.fadeIn(); break;
		case 1: rect1.fadeOut(); rect2.fadeIn(); break;
		case 2: rect2.fadeOut(); rect3.fadeIn(); break;
		}
	}

	Timer {
		id: timer;
		interval: 300;
		onTriggered: {
/*			rect1.visible = true;
			rect2.visible = true;
			rect3.visible = true;*/
			log ("ACTIVE: " + spinner.activeSpinner);
			spinner.activeSpinner = (spinner.activeSpinner + 1) % 4;
			spinner.UpdateRectangle();
			this.restart();
		}
	}

	onVisibleChanged: {
		if (this.visible) {
			spinner.activeSpinner = 0;
			timer.restart();
		} else {
			timer.stop();
		}
	}
}
