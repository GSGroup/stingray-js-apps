Rectangle {
	id: pauseRect;

	focus: true;
	color: colorTheme.backgroundColor;

	visible: false;

	Text {
		anchors.centerIn: parent;

		text: qsTr("Пауза...");
		color: colorTheme.highlightPanelColor;
		font: bodyFont;
	}

	onKeyPressed: {
		if (key === "8") {
			pauseRect.visible = false;

			movingTetraminos.setFocus();
			animTimer.start();
		}
		return true;
	}

	function show() {
		pauseRect.visible = true;
		pauseRect.setFocus();
	}
}
