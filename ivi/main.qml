// Copyright (c) 2011 - 2019, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "CatalogPage.qml";
import "CatalogView.qml";
import "CategoryMenu.qml";
import "IviPlayer.qml";

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
                    catalogPage.visible = false;
                    catalogView.visible = true;
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
            iviPlayer.title = catalogView.model.get(catalogView.currentIndex).title;
            log("start watching", catalogView.model.get(catalogView.currentIndex).id);
            iviPlayer.playVideoById(catalogView.model.get(catalogView.currentIndex).id);
        }

        onLeftPressed: {
            categoryMenu.setFocus();
        }

        onClosed: {
            this.visible = false;
            backgroundImage.source = null;
            iviPlayer.abort();
            catalogView.visible = true;
            catalogView.setFocus();
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

        onLeftPressed: {
            if (!this.moveCurrentIndexLeft())
                categoryMenu.setFocus();
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
            log("player abort");
            iviPlayer.abort();
            this.visible = false;
            log("show catalog page");
            menuItem.visible = true;
            catalogPage.visible = true;
            catalogPage.setFocus();
        }

        onFinished: {
            if (finished)
                ivi.hidePlayer();
        }
    }

    onBackPressed: {
		appManager.closeCurrentApp();
    }

    onCompleted: {
        catalogView.loadCatalog(constants.categories[0].url);
    }

    onVisibleChanged: {
        appManager.ignoreScreenSaverForApp("ivi", this.visible);
        iviPlayer.abort();

        if(iviPlayer.visible) {
            ivi.hidePlayer();
        }
    }

    function hidePlayer() {
        iviPlayer.visible = false;
        menuItem.visible = true;
        catalogPage.visible = true;
        catalogPage.setFocus();
    }
}
