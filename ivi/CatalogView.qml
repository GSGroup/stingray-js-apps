import CatalogDelegate;

import "js/constants.js" as constants;

GridView {
    id: catalogView;

    property string url;
    property bool loading: false;

    cellWidth: constants.poster["width"] + (constants.margin / 3);
    cellHeight: constants.poster["height"] + (constants.margin / 3);

    visible: !loading;

    focus: true;
    clip: true;

    delegate: CatalogDelegate {}
    model: ListModel { id: catalogModel; }

    function loadCatalog(url) {
        catalogView.loading = true;
        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if (request.readyState !== XMLHttpRequest.DONE)
                return;

            if (request.status && request.status === 200) {
                log("response was received");
                //log(request.responseText);
                catalogView.url = url;
                catalogModel.reset();

                var catalog = JSON.parse(request.responseText);
                catalog["result"].forEach(function (catalogItem) {
                    catalogModel.append( {  id: catalogItem["id"],
                                            title: catalogItem["title"],
                                            year: catalogItem["year"] ? catalogItem["year"] : "-",
                                            iviRating: catalogItem["ivi_rating_10"] ? catalogItem["ivi_rating_10"] : "-",
                                            kpRating: catalogItem["kp_rating"] ? catalogItem["kp_rating"] : "-",
                                            imdbRating: catalogItem["imdb_rating"] ? catalogItem["imdb_rating"] : "-",
                                                                                                                                                                                                duration: catalogItem["duration"] ? catalogItem["duration"] : "",
                                                                                                                                                                                                                                    background: catalogView.extractBackgroundImage(catalogItem),
                                                                                                                                                                                                                                    restrict: catalogItem["restrict"] ? catalogItem["restrict"] : "",
                                                                                                                                                                                                                                                                        description: catalogItem["description"],
                                                                                                                                                                                                                                                                        poster: catalogItem["poster_originals"][0]["path"] } );
                });
                catalogView.loading = false;
                catalogView.setFocus();
                log("catalog was updated");
            } else
                log("unhandled status", request.status);
        }

        request.open("GET", url, true);
        request.send();
        log("request was sended");
    }

    function extractBackgroundImage(catalogItem) {
        var result = "";
        if (catalogItem.hasOwnProperty("background"))
            if (catalogItem["background"] && catalogItem["background"].hasOwnProperty("path"))
                result = catalogItem["background"]["path"];
        return result;
    }
}
