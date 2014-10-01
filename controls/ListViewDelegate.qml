ListViewDelegate : Panel {
	anchors.left: parent.left;
	anchors.right: parent.right;
	active: parent.activeFocus;
	
	SelectionGradient {
		anchors.fill: parent;
		radius: 5;
		opacity: parent.activeFocus ? 1 : 0;

		Behavior on opacity {
			animation: Animation {
				duration: 300;
			}
		}
	}

	Rectangle {
		anchors.bottom: parent.top;
		height: 1;
		anchors.left: parent.left;
		anchors.right: parent.right;
		color: colorTheme.focusablePanelColor;
	}

	Rectangle {
		anchors.bottom: parent.bottom;
		height: 1;
		anchors.left: parent.left;
		anchors.right: parent.right;
		color: colorTheme.focusablePanelColor;
	}

}
