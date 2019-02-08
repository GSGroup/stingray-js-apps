import "tetrisConsts.js" as gameConsts;

Rectangle {
	id: infoRect;

	property int currentLevel: 0;
	property int gameScore: 0;

	color: colorTheme.globalBackgroundColor;

	ItemGridView {
		id: nextBlockView;

		y: 38;

		width: gameConsts.getBlockSize() * 4;
		height: gameConsts.getBlockSize() * 4;
	}

	BodyText {
		id: levelRect;

		anchors.top: nextBlockView.bottom;
		anchors.topMargin: 80;

		text: tr("Уровень ");
		color: colorTheme.highlightPanelColor;
	}

	TitleText {
		id: levelText;

		anchors.left: levelRect.right;
		anchors.leftMargin: 20;
		anchors.top: nextBlockView.bottom;
		anchors.topMargin: 67;

		text: infoRect.currentLevel;
		color: colorTheme.highlightPanelColor;
	}

	BodyText {
		id: scoreRect;

		anchors.top: levelText.bottom;
		anchors.topMargin: 40;

		text: tr("Счет    ");
		color: colorTheme.highlightPanelColor;
	}

	TitleText {
		id: scoreText;

		anchors.left: levelRect.right;
		anchors.leftMargin: 20;
		anchors.top: levelText.bottom;
		anchors.topMargin: 27;

		text: infoRect.gameScore;
		color: colorTheme.highlightPanelColor;
	}
}

