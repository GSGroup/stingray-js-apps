import CatalogItemDelegate;
import CatalogItemPage;

import controls.Spinner;
import controls.Player;

//TODO: Replace mainWindow with Application id

Application {
    id: ivi;

    color: "#F9F9F9";

    Rectangle {
        id: headerRect;

        height: 131; // logo image height

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

    CatalogItemPage {
        id: catalogItemPage;

        anchors.top: headerRect.bottom;
        anchors.left: mainWindow.left;
        anchors.right: mainWindow.right;
        anchors.bottom: mainWindow.bottom;

        visible: false;

        onClosed: {
            catalogItemPage.visible = false;
            promoCatalogView.visible = true;
            promoCatalogView.setFocus();
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
        model: ListModel { id: catalogModel; }

        onCompleted: {
            var request = new XMLHttpRequest();
            request.open("GET", "https://api.ivi.ru/mobileapi/videos/v5");
            request.onreadystatechange = function() {
                if (request.readyState === XMLHttpRequest.DONE) {
                    if (request.status && request.status === 200) {
                        log("response was received");
                        //log(request.responseText);
                        catalogModel.reset();

                        var catalog = JSON.parse(request.responseText);
                        catalog["result"].forEach(function (catalogItem) {
                            catalogModel.append( {
                                                    id: catalogItem["id"],
                                                    title: catalogItem["title"],
                                                    year: catalogItem["year"] ? catalogItem["year"] : "",
                                                    description: catalogItem["description"],
                                                    poster: catalogItem["thumbnails"][0]["path"] } );
                        });
                        catalogModel.sync();
                        log("promo catalog was updated");
                    }
                } else {
                    log("request error: ", request.readyState, request.responseText);
                }
            }

            request.send();
            log("request was sended");
        }

        onSelectPressed: {
            promoCatalogView.visible = false;

            var currentCatalogItem = model.get(promoCatalogView.currentIndex);
            catalogItemPage.title = currentCatalogItem.title;
            catalogItemPage.year = currentCatalogItem.year;
            catalogItemPage.poster = currentCatalogItem.poster;
            catalogItemPage.description = currentCatalogItem.description;
            catalogItemPage.visible = true;
        }
    }

    Spinner {
        id: loadingPromoCatalogSpinner;

        anchors.centerIn: mainWindow;

        visible: promoCatalogView.model.count === 0;
    }

    Player {
        id: videoPlayer;

        anchors.fill: mainWindow;

        visible: false;
    }

    onBackPressed: {
        viewsFinder.closeApp();
    }
}
