import CatalogItemDelegate;

import "ivi.js" as api;

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
        model: ListModel {}

        onCompleted: {
            fill();
        }

        function fill() {
            var catalog = api.getPromoCatalog();
            catalog["result"].forEach(function (catalogItem) {
                this.model.append( { poster: catalogItem["thumbnails"][0]["path"] } );
            });
        }
    }
}
