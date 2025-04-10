// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.Button;

import "js/constants.js" as constants;

Item {
	id: catalogPage;

	signal closed;
	signal watch;

	property alias title: titleText.text;
	property alias poster: posterImage.source;
	property alias year: yearText.text;
	property alias description: descriptionText.text;
	property string duration;
	property string restrict;
	property string iviRating;
	property string kpRating;
	property string imdbRating;

	Image {
		id: posterDefaultImage;

		anchors.top: catalogPage.top;
		anchors.left: catalogPage.left;

		sourceWidth: constants.poster["width"];
		sourceHeight: constants.poster["height"];

		source: constants.defaultPoster;

		fillMode: ui.Image.FillMode.PreserveAspectFit;

		visible: posterImage.status !== ui.Image.Status.Ready;
	}

	Image {
		id: posterImage;

		width: constants.poster["width"];
		height: constants.poster["height"];

		anchors.top: catalogPage.top;
		anchors.left: catalogPage.left;

		fillMode: ui.Image.FillMode.PreserveAspectFit;
	}

	SubheadText {
		id: titleText;

		anchors.top: catalogPage.top;
		anchors.left: posterDefaultImage.visible ? posterDefaultImage.right : posterImage.right;
		anchors.leftMargin: constants.margin / 2;
		anchors.right: parent.right;

		color: "#FFFFFF";

		wrapMode: ui.Text.WrapMode.Wrap;
	}

	BodyText {
		id: yearText;

		anchors.top: titleText.bottom;
		anchors.left: posterDefaultImage.visible ? posterDefaultImage.right : posterImage.right;
		anchors.leftMargin: constants.margin / 2;

		color: "#FFFFFF";
	}

	BodyText {
		id: restrictText;

		anchors.top: titleText.bottom;
		anchors.left: yearText.right;
		anchors.leftMargin: constants.margin / 4;

		text: catalogPage.restrict + "+";

		color: constants.colors["inactive"];
	}

	BodyText {
		id: durationText;

		anchors.top: titleText.bottom;
		anchors.left: restrictText.right;
		anchors.leftMargin: constants.margin / 4;

		text: catalogPage.duration;

		color: constants.colors["inactive"];
	}

	Item {
		id: ratingItem;

		anchors.top: yearText.bottom;
		anchors.topMargin: constants.margin / 2;
		anchors.left: posterDefaultImage.visible ? posterDefaultImage.right : posterImage.right;
		anchors.leftMargin: constants.margin / 2;
		anchors.right: parent.right;

		height: iviRatingText.height;

		SecondaryText {
			id: iviRatingText;

			anchors.left: parent.left;

			text: "ivi: " + catalogPage.iviRating;

			color: constants.colors["inactive"];
		}

		SecondaryText {
			id: kpRatingText;

			anchors.left: iviRatingText.right;
			anchors.leftMargin: constants.margin / 2;

			text: "КиноПоиск: " + catalogPage.kpRating;

			color: constants.colors["inactive"];
		}

		SecondaryText {
			id: imdbRatingText;

			anchors.left: kpRatingText.right;
			anchors.leftMargin: constants.margin / 2;

			text: "IMDb: " + catalogPage.imdbRating;

			color: constants.colors["inactive"];
		}
	}

	Button {
		id: watchButton;

		anchors.top: ratingItem.bottom;
		anchors.topMargin: constants.margin / 2;
		anchors.left: posterDefaultImage.visible ? posterDefaultImage.right : posterImage.right;
		anchors.leftMargin: constants.margin / 2;

		opacity: activeFocus ? 1.0 : constants.inactiveOpacity;

		color: activeFocus ? constants.colors["active"] : constants.colors["inactive"];

		text: "Начать просмотр";

		onSelectPressed: {
			console.log("watch button pressed");
			catalogPage.watch();
		}

		onUpPressed: {
			descriptionText.scrollUp(false);
		}

		onDownPressed: {
			descriptionText.scrollDown(false);
		}
	}

	ScrollingText {
		id: descriptionText;

		anchors.top: watchButton.bottom;
		anchors.topMargin: constants.margin / 2;
		anchors.left: posterDefaultImage.visible ? posterDefaultImage.right : posterImage.right;
		anchors.leftMargin: constants.margin / 2;
		anchors.right: catalogPage.right;
		anchors.bottom: catalogPage.bottom;

		focus: false;

		color: "#FFFFFF";

		font: secondaryFont;
	}

	onVisibleChanged: {
		watchButton.setFocus();
	}

	onBackPressed: {
		closed();
	}
}
