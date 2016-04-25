import controls.MainCaptionText;
import controls.SmallText;
import controls.TinyText;
import controls.Button;

Rectangle {
    id: catalogItemPage;

    signal closed;

    property alias title: titleText.text;
    property alias poster: posterImage.source;
    property alias year: yearText.text;
    property alias description: descriptionText.text;

    color: "#F9F9F9";

    Image {
        id: posterImage;

        anchors.left: catalogItemPage.left;
        anchors.top: catalogItemPage.top;
        anchors.bottom: catalogItemPage.bottom;
        anchors.leftMargin: 20;
        anchors.topMargin: 20;
        anchors.bottomMargin: 20;

        fillMode: PreserveAspectFit;
    }

    MainCaptionText {
        id: titleText;

        anchors.left: posterImage.right;
        anchors.leftMargin: 20;
        anchors.top: catalogItemPage.top;
        anchors.topMargin: 10;
        anchors.rightMargin: 20;

        color: "#000000";
    }

    SmallText {
        id: yearText;

        anchors.top: titleText.bottom;
        anchors.left: posterImage.right;
        anchors.leftMargin: 20;
        anchors.rightMargin: 20;

        color: "#000000";
    }

    Button {
        id: watchButton;

        anchors.top: yearText.bottom;
        anchors.margins: 20;
        anchors.left: posterImage.right;

        text: "Начать просмотр";

        onDownPressed: {
            descriptionText.setFocus();
        }
    }

    ScrollingText {
        id: descriptionText;

        anchors.top: watchButton.bottom;
        anchors.margins: 20;
        anchors.left: posterImage.right;
        anchors.right: catalogItemPage.right;
        anchors.bottom: catalogItemPage.bottom;

        font: tinyFont;

        color: "#91949C";

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
