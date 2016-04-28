import CatalogPage;
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

        width: 320;

        anchors.left: mainWindow.left;
        anchors.top: mainWindow.top;
        anchors.bottom: mainWindow.bottom;

        Image {
            id: iviImage;

            anchors.top: parent.top;
            anchors.left: parent.left;
            anchors.margins: constants.border;

            source: "apps/ivi/resources/logo.png";

            fillMode: PreserveAspectFit;
        }

        CategoryMenu {
            id: categoryMenu;

            anchors.top: iviImage.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;
            anchors.margins: constants.border;

            spacing: constants.border / 2;

            opacity: activeFocus ? 1.0 : 0.7; //TODO: Constants

            onRightPressed: {
                if (catalogView.visible)
                    catalogView.setFocus();
                else if (catalogPage.visible)
                    catalogPage.setFocus();
            }

            onSelectPressed: {
                catalogView.visible = true;
                catalogPage.visible = false;
                var currentCategory = model.get(categoryMenu.currentIndex);
                catalogView.loadCatalog(currentCategory.url);
                log("category was selected", currentCategory.title);
            }
        }
    }

    CatalogPage {
        id: catalogPage;

        anchors.top: mainWindow.top;
        anchors.topMargin: constants.border;
        anchors.left: menuItem.right;
        anchors.right: mainWindow.right;
        anchors.bottom: mainWindow.bottom;
        anchors.bottomMargin: constants.border;

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
        anchors.left: menuItem.right;
        anchors.right: mainWindow.right;
        anchors.bottom: mainWindow.bottom;
        anchors.margins: constants.border;

        opacity: activeFocus ? 1.0 : 0.7; //TODO: Constants

        keyNavigationWraps: false;

        onSelectPressed: {
            this.visible = false;

            var currentCatalogItem = model.get(catalogView.currentIndex);
            catalogPage.title = currentCatalogItem.title;
            catalogPage.year = currentCatalogItem.year;
            catalogPage.poster = currentCatalogItem.poster;
            catalogPage.description = currentCatalogItem.description;
            catalogPage.visible = true;
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

    onLeftPressed: {
        categoryMenu.setFocus();
    }

    onCompleted: {
        catalogView.loadCatalog(constants.categories[0].url);
    }

    onBackPressed: {
        viewsFinder.closeApp();
    }
}
