import CatalogItemPage;
import CatalogView;
import Header;

import controls.Spinner;
import controls.Player;

//TODO: Replace mainWindow with Application id

Application {
    id: ivi;

    color: "#F9F9F9";

    Header {
        id: header;

        anchors.top: mainWindow.top;
        anchors.left: mainWindow.left;
        anchors.right: mainWindow.right;

        title: "Промо-видео";
    }

    CatalogItemPage {
        id: catalogItemPage;

        anchors.top: header.bottom;
        anchors.left: mainWindow.left;
        anchors.right: mainWindow.right;
        anchors.bottom: mainWindow.bottom;

        visible: false;

        onClosed: {
            this.visible = false;
            catalogView.visible = true;
            catalogView.setFocus();
        }
    }

    CatalogView {
        id: catalogView;

        url: "https://api.ivi.ru/mobileapi/videos/v5";

        anchors.top: header.bottom;
        anchors.left: mainWindow.left;
        anchors.right: mainWindow.right;
        anchors.topMargin: 20;
        anchors.leftMargin: 20;
        anchors.rightMargin: 20;

        onSelectPressed: {
            this.visible = false;

            var currentCatalogItem = model.get(catalogView.currentIndex);
            catalogItemPage.title = currentCatalogItem.title;
            catalogItemPage.year = currentCatalogItem.year;
            catalogItemPage.poster = currentCatalogItem.poster;
            catalogItemPage.description = currentCatalogItem.description;
            catalogItemPage.visible = true;
        }
    }

    Spinner {
        id: loadingCatalogSpinner;

        anchors.centerIn: mainWindow;

        visible: catalogView.model.count === 0;
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
