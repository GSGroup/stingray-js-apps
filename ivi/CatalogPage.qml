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

        visible: posterImage.status !== Image.Ready;

        source: constants.defaultPoster;

        fillMode: PreserveAspectFit;
    }

    Image {
        id: posterImage;

        anchors.top: catalogPage.top;
        anchors.left: catalogPage.left;

        fillMode: PreserveAspectFit;
    }

    MainCaptionText {
        id: titleText;

        anchors.top: catalogPage.top;
        anchors.left: posterDefaultImage.visible ? posterDefaultImage.right : posterImage.right;
        anchors.leftMargin: constants.margin / 2;
        anchors.right: parent.right;

        color: "#FFFFFF";

        wrapMode: Text.Wrap;
    }

    SmallText {
        id: yearText;

        anchors.top: titleText.bottom;
        anchors.left: posterDefaultImage.visible ? posterDefaultImage.right : posterImage.right;
        anchors.leftMargin: constants.margin / 2;

        color: "#FFFFFF";
    }

    SmallText {
        id: restrictText;

        anchors.top: titleText.bottom;
        anchors.left: yearText.right;
        anchors.leftMargin: constants.margin / 4;

        text: catalogPage.restrict + "+";

        color: constants.colors["inactive"];
    }

    SmallText {
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

        TinyText {
            id: iviRatingText;

            anchors.left: parent.left;

            text: "ivi: " + catalogPage.iviRating;

            color: constants.colors["inactive"];
        }

        TinyText {
            id: kpRatingText;

            anchors.left: iviRatingText.right;
            anchors.leftMargin: constants.margin / 2;

            text: "КиноПоиск: " + catalogPage.kpRating;

            color: constants.colors["inactive"];
        }

        TinyText {
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

        onDownPressed: {
            descriptionText.setFocus();
        }

        onSelectPressed: {
            log("watch button pressed");
            catalogPage.watch();
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

        opacity: activeFocus ? 1.0 : constants.inactiveOpacity;

        color: "#FFFFFF";

        font: tinyFont;

        onUpPressed: {
            watchButton.setFocus();
        }
    }

    onVisibleChanged: {
        watchButton.setFocus();
    }

    onBackPressed: {
        closed();
    }
}
