SelectionGradient : Gradient {
	anchors.fill: parent;

	GradientStop {
		position: 1;
		color: colorTheme.activeFocusBottom;
	}

	GradientStop {
		position: 0;
		color: colorTheme.activeFocusTop;
	}

	Behavior on opacity {
		animation: Animation {
			duration: 300;
		}
	}
}
