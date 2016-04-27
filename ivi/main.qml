import CatalogItemPage;
import CatalogView;
import Header;

import controls.Player;
import controls.Spinner;
import controls.TinyText;

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
            instructionsText.visible = true; //TODO: Refactoring
            catalogView.setFocus();
        }
    }

    CatalogView {
        id: catalogView;

        anchors.top: header.bottom;
        anchors.topMargin: 20;
        anchors.left: mainWindow.left;
        anchors.leftMargin: 80; //TODO: Replace with normal margins and set view on screen horizontal center
        anchors.right: mainWindow.right;
        anchors.rightMargin: 20;
        anchors.bottom: instructionsText.top;
        anchors.bottomMargin: 20;
        //anchors.margins: 20;

        onSelectPressed: {
            this.visible = false;
            instructionsText.visible = false;

            var currentCatalogItem = model.get(catalogView.currentIndex);
            catalogItemPage.title = currentCatalogItem.title;
            catalogItemPage.year = currentCatalogItem.year;
            catalogItemPage.poster = currentCatalogItem.poster;
            catalogItemPage.description = currentCatalogItem.description;
            catalogItemPage.visible = true;
        }

        onDownPressed: {
            log("down pressed");
            header.title = "Советский кинематограф";
            this.loadCatalog("https://api.ivi.ru/mobileapi/compilations/v5/"); //TODO: Catalog/url dict
        }

        onUpPressed: {
            log("up pressed");
            header.title = "Промо-видео";
            this.loadCatalog("https://api.ivi.ru/mobileapi/videos/v5");
        }
    }

    TinyText {
        id: instructionsText;

        anchors.horizontalCenter: mainWindow.horizontalCenter;
        anchors.bottom: mainWindow.bottom;
        anchors.bottomMargin: 20;
        anchors.horizontalCenter: mainWindow.horizontalCenter;

        color: "#91949C";

        text: "Нажмите красную кнопку для обновления текущей выбранной категории.";
    }

    Spinner {
        id: loadingCatalogSpinner;

        anchors.centerIn: mainWindow;

        visible: catalogView.loading;
    }

    Player {
        id: videoPlayer;

        anchors.fill: mainWindow;

        visible: false;
    }

    onCompleted: {
        catalogView.loadCatalog("https://api.ivi.ru/mobileapi/compilations/v5/");
    }

    onKeyPressed: {
        if (key === "Red")
            catalogView.loadCatalog(catalogView.url);
    }

    onBackPressed: {
        viewsFinder.closeApp();
    }
}
