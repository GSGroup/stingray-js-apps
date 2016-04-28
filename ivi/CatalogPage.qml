import controls.MainCaptionText;
import controls.SmallText;
import controls.TinyText;
import controls.Button;

import "js/constants.js" as constants;

Item {
    id: catalogPage;

    signal closed;

    property alias title: titleText.text;
    property alias poster: posterImage.source;
    property alias year: yearText.text;
    property alias description: descriptionText.text;

    Image {
        id: posterImage;

        anchors.top: catalogPage.top;
        anchors.left: catalogPage.left;

        fillMode: PreserveAspectFit;
    }

    MainCaptionText {
        id: titleText;

        anchors.left: posterImage.right;
        anchors.leftMargin: constants.margin / 2;
        anchors.top: catalogPage.top;

        color: "#FFFFFF";
    }

    SmallText {
        id: yearText;

        anchors.top: titleText.bottom;
        anchors.left: posterImage.right;
        anchors.leftMargin: constants.margin / 2;

        color: "#FFFFFF";
    }

    Button {
        id: watchButton;

        anchors.top: yearText.bottom;
        anchors.topMargin: constants.margin / 2;
        anchors.left: posterImage.right;
        anchors.leftMargin: constants.margin / 2;

        opacity: activeFocus ? 1.0 : constants.inactiveOpacity;

        color: activeFocus ? constants.colors["active"] : constants.colors["inactive"];

        text: "Начать просмотр";

        onDownPressed: {
            descriptionText.setFocus();
        }
    }

    ScrollingText {
        id: descriptionText;

        anchors.top: watchButton.bottom;
        anchors.topMargin: constants.margin;
        anchors.left: posterImage.right;
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
