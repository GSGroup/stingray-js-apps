import controls.MainCaptionText;
import controls.TinyText;
import controls.Button;

Rectangle {
    id: catalogItemPage;

    property alias title: titleText.text;
    property alias poster: posterImage.source;
    property alias year: yearText.text;
    property alias description: descriptionText.text;

    color: "#F9F9F9";
    focus: true;

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
        anchors.topMargin: 20;

        color: "#000000";
    }

    SmallText {
        id: yearText;

        anchors.top: titleText.bottom;
        anchors.left: posterImage.right;
        anchors.leftMargin: 20;

        color: "#000000";
    }

    TinyText {
        id: descriptionText;

        anchors.top: yearText.bottom;
        anchors.topMargin: 40;
        anchors.left: posterImage.right;
        anchors.leftMargin: 20;
        anchors.right: catalogItemPage.right;

        wrapMode: Text.Wrap;

        color: "#91949C";
    }

    Button {
        id: watchButton;

        anchors.top: descriptionText.bottom;
        anchors.topMargin: 40;
        anchors.left: posterImage.right;
        anchors.leftMargin: 20;

        text: "Начать просмотр";
    }
}
