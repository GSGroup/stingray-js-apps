SpinnerRectangle : Rectangle {
	borderWidth: 2;
	opacity: active;
	visible: true;
	radius: height / 2;
	width: circleRadius * 2;
	height: width;
	color: colorTheme.activeBorderColor; 
	borderColor: colorTheme.activeBorderColor; 
	
	property float active;
	property float circleRadius;

	Behavior on opacity {
		animation: Animation {
			id: opacityAnimation;
			duration: 100;
		}
	}
}

Spinner : Item {
	id: spinner;
//	width: 90;
//	height: width / 3;
	anchors.centerIn: parent;

	property int activeSpinner: 0;
	property int circleRadius: 12;
	property int space: 3;
	property int circlesCount: 8;
	property int speed: 50;


	collapseEmptyItems: false;

	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}
	SpinnerRectangle{}	SpinnerRectangle{}

	function UpdateRectangle() {
		var o = 1;
		for (var i = this.activeSpinner; o >= 0; i = i == 0 ? spinner.circlesCount - 1 : i-1, o -= 0.15) {
			this.children[i].active = o;
		}
	}

	Timer {
		id: timer;
		interval: spinner.speed;
		onTriggered: {
			spinner.activeSpinner = (spinner.activeSpinner + 1) % (spinner.circlesCount);
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

	onCompleted: {
		for (var i = 0; i < this.circlesCount; i ++) {
			this.children[i].circleRadius = this.circleRadius;
			this.children[i].x = Math.sin(Math.PI * i / this.circlesCount * 2) * this.circleRadius * this.space - this.circleRadius;
			this.children[i].y = Math.cos(Math.PI * i / this.circlesCount * 2) * this.circleRadius * this.space - this.circleRadius;
			this.children[i].active = 0;
		}
	}
}
