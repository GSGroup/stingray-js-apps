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
            request.onreadystatechange = function() {
                if (request.readyState === XMLHttpRequest.DONE) {
                    if (request.status && request.status === 200) {
                        log("response was received");
                        catalogModel.reset();

                        var catalog = JSON.parse(request.responseText);
                        catalog["result"].forEach(function (catalogItem) {
                            catalogModel.append( { id: catalogItem["id"], poster: catalogItem["thumbnails"][0]["path"] });
                         });
                        log("promo catalog was updated");
                    }
                } else
                    log("request error: ", request.readyState);
            }

            request.send();
            log("request was sended");
        }

        onSelectPressed: {
            log(promoCatalogView.model.get(promoCatalogView.currentIndex).id);
            log(promoCatalogView.model.get(promoCatalogView.currentIndex).poster);
        }
    }

    Spinner {
        id: loadingPromoCatalogSpinner;

        anchors.centerIn: mainWindow;

        visible: promoCatalogView.model.count === 0;
    }
}
