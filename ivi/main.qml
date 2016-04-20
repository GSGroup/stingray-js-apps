import VideoDelegate;

import "ivi.js" as api;

Application {
    id: ivi;

    color: "#F9F9F9";

    Rectangle {
        id: header;

        height: 188; // logo image height

        anchors.top: mainWindow.top;
        anchors.left: mainWindow.left;
        anchors.right: mainWindow.right;

        color: "#EC174F";

        Image {
            id: logo;

            anchors.top: header.top;
            anchors.horizontalCenter: header.horizontalCenter;

            source: "apps/ivi/logo.png";
        }
    }

    ListView {
        id: videosView;
        focus: true;

        anchors.top: header.bottom;
        anchors.left: mainWindow.left;
        anchors.right: mainWindow.right;
        anchors.topMargin: 20;
        anchors.leftMargin: 20;
        anchors.rightMargin: 20;

        orientation: Horizontal;

        delegate: VideoDelegate {}
        model: ListModel {}

        onCompleted: {
            fillWithPromoVideos();
        }

        function fillWithPromoVideos() {
            var videos = api.getPromoVideos();
            videos["result"].forEach(function (video) {
                this.model.append( { poster: video["thumbnails"][0]["path"] } );
            });
        }
    }
}
