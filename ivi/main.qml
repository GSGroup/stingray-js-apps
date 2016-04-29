import CatalogPage;
import CatalogView;
import CategoryMenu;
import IviPlayer;

import controls.Spinner;

import "js/constants.js" as constants;

//TODO: Replace anchors from mainWindow to application (advice by Ivan Leonov)

Application {
    id: ivi;

    color: "#000000";

    property alias background: backgroundImage.source;

    Image {
        id: backgroundImage;

        anchors.fill: mainWindow;
    }

    Item {
        id: menuItem;

        width: constants.menuWidth;

        anchors.left: mainWindow.left;
        anchors.top: mainWindow.top;
        anchors.bottom: mainWindow.bottom;

        Image {
            id: iviImage;

            anchors.top: parent.top;
            anchors.left: parent.left;
            anchors.margins: constants.margin;

            source: "apps/ivi/resources/menu.png";

            fillMode: PreserveAspectFit;
        }

        CategoryMenu {
            id: categoryMenu;

            anchors.top: iviImage.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;
            anchors.margins: constants.margin;

            spacing: constants.margin / 2;

            opacity: activeFocus ? 1.0 : constants.inactiveOpacity;

            onKeyPressed: {
                if (key === "Select" || key === "Right") {
                    catalogView.visible = true;
                    catalogPage.visible = false;
                    var currentCategory = model.get(categoryMenu.currentIndex);
                    catalogView.loadCatalog(currentCategory.url);
                    log("category was selected", currentCategory.title);
                }
            }
        }
    }

    CatalogPage {
        id: catalogPage;

        anchors.top: mainWindow.top;
        anchors.left: menuItem.right;
        anchors.right: mainWindow.right;
        anchors.bottom: mainWindow.bottom;
        anchors.margins: constants.margin;

        opacity: activeFocus ? 1.0 : constants.inactiveOpacity;

        visible: false;

        onWatch: {
            this.visible = false;
            menuItem.visible = false;
            iviPlayer.visible = true;
            log("start watching", catalogView.model.get(catalogView.currentIndex).id);
            iviPlayer.playVideoById(catalogView.model.get(catalogView.currentIndex).id);
        }

        onClosed: {
            this.visible = false;
            backgroundImage.visible = false; //TODO: more glitches if change visible to false
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
        anchors.margins: constants.margin;

        opacity: activeFocus ? 1.0 : constants.inactiveOpacity;

        keyNavigationWraps: false;

        onSelectPressed: {
            this.visible = false;

            var currentCatalogItem = model.get(catalogView.currentIndex);
            catalogPage.title = currentCatalogItem.title;
            catalogPage.year = currentCatalogItem.year;
            catalogPage.iviRating = currentCatalogItem.iviRating;
            catalogPage.kpRating = currentCatalogItem.kpRating;
            catalogPage.imdbRating = currentCatalogItem.imdbRating;
            catalogPage.poster = currentCatalogItem.poster;
            catalogPage.duration = currentCatalogItem.duration;
            ivi.background = currentCatalogItem.background;
            catalogPage.restrict = currentCatalogItem.restrict;
            catalogPage.description = currentCatalogItem.description;
            backgroundImage.visible = true;
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

    IviPlayer {
        id: iviPlayer;

        anchors.fill: mainWindow;

        visible: false;

        onBackPressed: {
            log("player stop");
            iviPlayer.stop();
            this.visible = false;
            log("show catalog page");
            menuItem.visible = true;
            catalogPage.visible = true;
            catalogPage.setFocus();
        }
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
