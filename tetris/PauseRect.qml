Rectangle {
	id: pauseRect;

	focus: true;
	color: colorTheme.backgroundColor;

	visible: false;

	BodyText {
		anchors.centerIn: parent;

		text: qsTr("Пауза...");
		color: colorTheme.highlightPanelColor;
	}

	on8Pressed: {
		pauseRect.visible = false;
		movingTetraminos.setFocus();

		return true;
	}

	function show() {
		pauseRect.visible = true;
		pauseRect.setFocus();
	}
}
