Rectangle {
	anchors.fill: parent;
	color: colorTheme.activeFocusColor;

	Behavior on opacity {
		animation: Animation {
			duration: 300;
		}
	}
}
