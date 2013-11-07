SelectionGradient : Gradient {
	anchors.fill: parent;

	GradientStop {
		position: 0;
		color: "#0096F0";
	}

	GradientStop {
		position: 1;
		color: "#004B7E";
	}

	Rectangle {
		height: 1;
		width: parent.width;
		color: "#45B4F6";
	}

	Rectangle {
		height: 1;
		y: parent.height - 1;
		width: parent.width;
		color: "#043B6D";
	}

	Behavior on opacity {
		animation: Animation {
			duration: 300;
		}
	}
}
