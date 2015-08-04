Panel {
	anchors.left: parent.left;
	anchors.right: parent.right;
	active: parent.activeFocus;
	opacity: active ? 1 : 0.7;

	SelectionGradient {
		anchors.fill: parent;
		opacity: parent.activeFocus ? 1 : 0;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}
}
