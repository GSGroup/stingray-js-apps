Rectangle {
	id: pauseRect;

	signal continueGame();

	focus: true;
	color: colorTheme.backgroundColor;

	visible: false;

	SubheadText {
		anchors.centerIn: parent;

		text: tr("Пауза...");
		color: colorTheme.highlightPanelColor;
	}

	onUpPressed: { pauseRect.continueGame(); }

	function show() {
		pauseRect.visible = true;
		pauseRect.setFocus();
	}
}
