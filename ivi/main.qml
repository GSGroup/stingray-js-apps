import CatalogItemPage;
import CatalogView;
import CategoryMenu;

import controls.Player;
import controls.Spinner;

import "js/constants.js" as constants;

//TODO: Replace anchors from mainWindow to application

Application {
    id: ivi;

    color: "#000000";

    Item {
        id: menuItem;

        anchors.left: mainWindow.left;
        anchors.top: mainWindow.top;
        anchors.bottom: mainWindow.bottom;

        width: 360;

        Image {
            id: iviImage;

            anchors.top: parent.top;
            anchors.topMargin: 80;
            anchors.left: parent.left;
            anchors.leftMargin: 80;

            source: "apps/ivi/resources/logo.png";

            fillMode: PreserveAspectFit;
        }

        CategoryMenu {
            id: categoryMenu;

            anchors.top: iviImage.bottom;
            anchors.topMargin: 80;
            anchors.left: parent.left;
            anchors.leftMargin: 80;
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;

            spacing: 40;

            onRightPressed: {
                if (catalogView.visible)
                    catalogView.setFocus();
                else if (catalogItemPage.visible)
                    catalogItemPage.setFocus();
            }

            onSelectPressed: {
                catalogView.visible = true;
                catalogItemPage.visible = false;
                var currentCategory = model.get(categoryMenu.currentIndex);
                catalogView.loadCatalog(currentCategory.url);
                log("category was selected", currentCategory.title);
            }
        }
    }

    CatalogItemPage {
        id: catalogItemPage;

        anchors.top: mainWindow.top;
        anchors.topMargin: 80;
        anchors.left: menuItem.right;
        anchors.leftMargin: 40;
        anchors.right: mainWindow.right;
        anchors.rightMargin: 40; //TODO: Constants
        anchors.bottom: mainWindow.bottom;
        anchors.bottomMargin: 40;

        visible: false;

        onClosed: {
            this.visible = false;
            catalogView.visible = true;
            catalogView.setFocus();
        }

        onLeftPressed: {
            categoryMenu.setFocus();
        }
    }

    CatalogView {
        id: catalogView;

        anchors.top: mainWindow.top;
        anchors.topMargin: 80;
        anchors.left: menuItem.right;
        anchors.leftMargin: 40;
        anchors.right: mainWindow.right;
        anchors.rightMargin: 40; //TODO: Constants
        anchors.bottom: mainWindow.bottom;
        anchors.bottomMargin: 40;

        onSelectPressed: {
            this.visible = false;

            var currentCatalogItem = model.get(catalogView.currentIndex);
            catalogItemPage.title = currentCatalogItem.title;
            catalogItemPage.year = currentCatalogItem.year;
            catalogItemPage.poster = currentCatalogItem.poster;
            catalogItemPage.description = currentCatalogItem.description;
            catalogItemPage.visible = true;
        }

        onKeyPressed: {
            if (key === "Red")
                categoryMenu.setFocus();
        }
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

    onBackPressed: {
        viewsFinder.closeApp();
    }
}
