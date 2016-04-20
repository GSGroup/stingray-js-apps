import VideoDelegate;
import VideoModel;

import controls.HighlightListView;
import controls.MainCaptionText;

Application {
    id: application;
    name: "ivi.ru";
    displayName: "ivi.ru";
    color: "#F9F9F9";

    Rectangle {
        id: header;
        anchors.top: mainWindow.top;
        anchors.left: mainWindow.left;
        anchors.right: mainWindow.right;
        color: "#EC174F";
        height: 188; // logo image height

        Image {
            id: logo;
            source: "apps/ivi/logo.png";
            anchors.top: header.top;
            anchors.horizontalCenter: header.horizontalCenter;
        }
    }

    Rectangle {
        id: body;
        anchors.top: header.bottom;
        anchors.left: mainWindow.left;
        anchors.right: mainWindow.right;
        anchors.bottom: mainWindow.bottom;
        color: "#F9F9F9";

        MainCaptionText {
            id: promoBlockText;
            text: "Реклама";
            anchors.top: body.top;
            anchros.left: body.left;
            anchors.topMargin: 40;
            anchors.leftMargin: 20;
            color: "black";
        }

        HighlightListView {
            id: videosView;
            spacing: 20;
            anchors.top: promoBlockText.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.topMargin: 20;
            anchors.leftMargin: 20;
            anchors.rightMargin: 20;
            highlightColor: "#EC174F";
            orientation: Horizontal;
            focus: true;

            model: VideoModel {}
            delegate: VideoDelegate {}
        }
    }

    onCompleted: { videosView.model.getPromoVideos(); }
}
