import controls.MainCaptionText;
import controls.SmallText;
import controls.TinyText;
import controls.Button;

import "js/constants.js" as constants;

Rectangle {
    id: catalogItemPage;

    signal closed;

    property alias title: titleText.text;
    property alias poster: posterImage.source;
    property alias year: yearText.text;
    property alias description: descriptionText.text;

    Image {
        id: posterImage;

        anchors.top: catalogItemPage.top;
        anchors.left: catalogItemPage.left;

        fillMode: PreserveAspectFit;
    }

    MainCaptionText {
        id: titleText;

        anchors.left: posterImage.right;
        anchors.leftMargin: constants.border;
        anchors.top: catalogItemPage.top;

        color: "#FFFFFF";
    }

    SmallText {
        id: yearText;

        anchors.top: titleText.bottom;
        anchors.left: posterImage.right;
        anchors.leftMargin: constants.border;
        anchors.rightMargin: constants.border;

        color: "#FFFFFF";
    }

    Button {
        id: watchButton;

        anchors.top: yearText.bottom;
        anchors.margins: constants.border;
        anchors.left: posterImage.right;

        text: "Начать просмотр";

        onDownPressed: {
            descriptionText.setFocus();
        }
    }

    ScrollingText {
        id: descriptionText;

        anchors.top: watchButton.bottom;
        anchors.margins: constants.border;
        anchors.left: posterImage.right;
        anchors.right: catalogItemPage.right;
        anchors.bottom: catalogItemPage.bottom;

        font: tinyFont;

        color: "#FFFFFF";

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
