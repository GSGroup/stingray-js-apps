import "SpinnerRectangle.qml";

// TODO: Rework to set correct sizes
Item {
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
		var h = 0, w = 0;
		
		for (var i = 0; i < this.circlesCount; i ++) {
			this.children[i].circleRadius = this.circleRadius;
			this.children[i].x = Math.sin(Math.PI * i / this.circlesCount * 2) * this.circleRadius * this.space - this.circleRadius;
			this.children[i].y = Math.cos(Math.PI * i / this.circlesCount * 2) * this.circleRadius * this.space - this.circleRadius;
			this.children[i].active = 0;
			
			h = Math.max(h, this.children[i].y + this.children[i].circleRadius * 2);
			w = Math.max(w, this.children[i].x + this.childre[i].circleRadius * 2);
		}
		
		this.height = h; this.width = w;
	}
}
