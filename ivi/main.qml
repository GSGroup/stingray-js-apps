import VideoDelegate;
import VideoModel;

import controls.HighlightListView;
import controls.MainCaptionText;

import "ivi.js" as api;

Application {
    id: ivi;
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
            anchors.left: body.left;
            anchors.topMargin: 40;
            anchors.leftMargin: 20;
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

            model: ListModel {}
            delegate: VideoDelegate {}
            
            onCompleted: {
				getPromoVideos();
            }
            
            function getPromoVideos() {
				var videos = api.getPromoVideos1();
				videos["result"].forEach(function (video) {
					this.model.append( { title: video["title"], poster: video["thumbnails"][0]["path"] } );
				});
			}
        }
    }
}
