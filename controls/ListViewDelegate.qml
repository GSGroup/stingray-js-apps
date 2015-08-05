Panel {
	anchors.left: parent.left;
	anchors.right: parent.right;
	active: parent.activeFocus;

	SelectionGradient {
		anchors.fill: parent;
		opacity: parent.activeFocus ? 1 : 0;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}
}
