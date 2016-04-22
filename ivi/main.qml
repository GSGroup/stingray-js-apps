import CatalogItemDelegate;

import controls.Spinner;

Application {
    id: ivi;

    color: "#F9F9F9";

    Rectangle {
        id: headerRect;

        height: 188; // logo image height

        anchors.top: mainWindow.top;
        anchors.left: mainWindow.left;
        anchors.right: mainWindow.right;

        color: "#EC174F";

        Image {
            id: logo;

            anchors.top: headerRect.top;
            anchors.horizontalCenter: headerRect.horizontalCenter;

            source: "apps/ivi/logo.png";
        }
    }

    ListView {
        id: promoCatalogView;

        property bool isCatalogReady : false;

        focus: true;

        anchors.top: headerRect.bottom;
        anchors.left: mainWindow.left;
        anchors.right: mainWindow.right;
        anchors.topMargin: 20;
        anchors.leftMargin: 20;
        anchors.rightMargin: 20;

        orientation: Horizontal;
        positionMode: Center;

        delegate: CatalogItemDelegate {}
        model: ListModel { id: catalogModel;}

        onCompleted: {
            var request = new XMLHttpRequest();
            request.open("GET", "https://api.ivi.ru/mobileapi/videos/v5");
            request.send();
            request.onreadystatechange = function() {
                if (request.readyState === XMLHttpRequest.DONE) {
                    if (request.status && request.status === 200) {
                        var catalog = JSON.parse(request.responseText);
                        catalog["result"].forEach(function (catalogItem) {
                            catalogModel.append( { id: catalogItem["id"], poster: catalogItem["thumbnails"][0]["path"] });
                        });
                        promoCatalogView.isCatalogReady = true;
                    }
                } else
                    log(request.readyState);
            }
        }
    }

    Spinner {
        id: loadingPromoCatalogSpinner;

        anchors.centerIn: mainWindow;

        visible: !promoCatalogView.isCatalogReady;
    }
}
