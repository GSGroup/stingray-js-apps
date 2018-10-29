Rectangle {
	id: pauseRect;

	signal continueGame();

	focus: true;
	color: colorTheme.backgroundColor;

	visible: false;

	BodyText {
		anchors.centerIn: parent;

		text: qsTr("Пауза...");
		color: colorTheme.highlightPanelColor;
	}

	onUpPressed: { pauseRect.continueGame(); }

	function show() {
		pauseRect.visible = true;
		pauseRect.setFocus();
	}
}
