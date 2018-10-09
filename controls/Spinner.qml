import "SpinnerRectangle.qml";

Item {
	id: spinner;
	width: radius * 2;
	height: width;

	property int activeSpinner: 0;
	property int radius: 45;
	property int circlesRadius: 12;
	property int circlesCount: 8;
	property int interval: 100;

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
		for (var i = this.activeSpinner; o >= 0; i = i === 0 ? spinner.circlesCount - 1 : i-1, o -= 0.15) {
			this.children[i].active = o;
		}
	}

	Timer {
		id: spinnerUpdateTimer;

		interval: spinner.interval;
		repeat: true;

		onTriggered: {
			spinner.activeSpinner = (spinner.activeSpinner + 1) % (spinner.circlesCount);
			spinner.UpdateRectangle();
		}
	}

	onVisibleChanged: {
		if (this.visible) {
			spinnerUpdateTimer.restart();
		} else {
			spinnerUpdateTimer.stop();
		}
	}

	onCompleted: {
		for (var i = 0; i < this.circlesCount; i ++) {
			this.children[i].radius = this.circlesRadius;
			this.children[i].x = Math.cos(Math.PI * i / this.circlesCount * 2) * (this.radius - this.circlesRadius) - this.circlesRadius + this.radius;
			this.children[i].y = Math.sin(Math.PI * i / this.circlesCount * 2) * (this.radius - this.circlesRadius) - this.circlesRadius + this.radius;
			this.children[i].active = 0;
		}
	}
}
