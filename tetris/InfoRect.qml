// Copyright (c) 2011 - 2019, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "generatedfiles/tetrisConsts.js" as gameConsts;

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
	}

	TitleText {
		id: levelText;

		anchors.right: infoRect.right;
		anchors.rightMargin: 140;
		anchors.top: nextBlockView.bottom;
		anchors.topMargin: 67;

		text: infoRect.currentLevel;
	}

	BodyText {
		id: scoreRect;

		anchors.top: levelText.bottom;
		anchors.topMargin: 40;

		text: tr("Счет    ");
	}

	TitleText {
		id: scoreText;

		anchors.right: infoRect.right;
		anchors.rightMargin: 140;
		anchors.top: levelText.bottom;
		anchors.topMargin: 27;

		text: infoRect.gameScore;
	}
}

