import controls.FocusablePanel;

Application {
    id: application;
    name: "ivi.ru";
    displayName: qsTr("ivi.ru");
    focus: true;

    property var videos;

    Rectangle {
        id: header;
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        color: "#EC174F";
        height: 200;

        Image {
            id: iviLogo;
            source: "header.png";
            anchors.top: parent.top;
            anchors.horizontalCenter: parent.horizontalCenter;
        }
    }

    function getPromoVideos() {
        var request = new XMLHttpRequest();
        request.open("GET", "https://api.ivi.ru/mobileapi/videos/v5");

        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE)
                if (request.status && request.status === 200) {
                    application.videos = JSON.parse(request.responseText);
                    //console.log(mainWindow.videos['result'][0]['thumbnails'][0]['path'])
                } else
                    console.log(request.status, request.statusText);
        }

        request.send();
    }

    Rectangle {
        id: body;
        anchors.top: header.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        color: "#F9F9F9";

        Text {
            id: promoTitle;
            text: "Реклама";
            font.pointSize: 20;
            anchors.top: parent.top;
            anchors.topMargin: 40;
            anchors.left: parent.left;
            anchors.leftMargin: 20;
            anchors.right: parent.right;
        }

        ListView {
            id: videosView;
            anchors.top: promoTitle.bottom;
            anchors.topMargin: 20;
            anchors.left: parent.left;
            anchors.leftMargin: 20;
            anchors.right: parent.right;
            anchors.rightMargin: 20;
            anchors.bottom: parent.bottom;
            anchors.bottomMargin: 20;
            orientation: ListView.HorposterRectangleizontal;
            spacing: 20;

            model: videos['result'];

            delegate:
                FocusablePanel {
                    id: videoElement;
                    width: 172;
                    height: 300;
                    color: "#F9F9F9";
                    active: parent.activeFocus;

                    Image {
                        id: posterImage;
                        width: 172;
                        height: 264;

                        source: modelData['thumbnails'][0]['path'];
                    }

                    Text {
                        id: videoTitle;
                        anchors.left: videoElement.left;
                        anchors.right: videoElement.right;
                        anchors.top: posterImage.bottom;
                        anchors.topMargin: 10;
                        anchors.bottom: videoElement.bottom;
                        horizontalAlignment: Text.AlignHCenter;

                        color: "#91949C";
                        wrapMode: Text.WordWrap;
                        font.pointSize: 12;

                        text: modelData['title'];
                    }

                }
            }
        }

    onCompleted: {
        getPromoVideos();
    }
}
