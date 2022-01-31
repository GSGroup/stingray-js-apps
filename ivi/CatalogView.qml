// Copyright (c) 2011 - 2019, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "CatalogDelegate.qml";

import "js/constants.js" as constants;

GridView {
    id: catalogView;

    property bool loading: false;

    cellWidth: constants.poster["width"] + (constants.margin / 3);
    cellHeight: constants.poster["height"] + (constants.margin / 3);

    visible: !loading;

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
                catalogModel.reset();

                var catalog = JSON.parse(request.responseText);
                catalog["result"].forEach(function (catalogItem) {
                    catalogModel.append( {  id: catalogItem["id"],
                                            title: catalogItem["title"],
                                            background: catalogView.extractBackgroundImage(catalogItem),
                                            year: catalogItem["year"] ? catalogItem["year"] : "-",
                                            restrict: catalogItem["restrict"] ? catalogItem["restrict"] : "0+",
                                            duration: catalogItem["duration"] ? catalogItem["duration"] : "",
                                            iviRating: catalogItem["ivi_rating_10"] ? catalogItem["ivi_rating_10"] : "-",
                                            kpRating: catalogItem["kp_rating"] ? catalogItem["kp_rating"] : "-",
                                            imdbRating: catalogItem["imdb_rating"] ? catalogItem["imdb_rating"] : "-",
                                            description: catalogItem["description"] ? catalogItem["description"] : "",
                                            poster: catalogItem["poster_originals"][0]["path"] ? catalogItem["poster_originals"][0]["path"] : constants.defaultPoster } );
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
