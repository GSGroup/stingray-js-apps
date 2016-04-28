import CatalogDelegate;

import "js/constants.js" as constants;

GridView {
    id: catalogView;

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
        request.open("GET", url);
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    log("response was received");
                    //log(request.responseText);
                    catalogModel.reset();

                    var catalog = JSON.parse(request.responseText);
                    catalog["result"].forEach(function (catalogItem) {
                        catalogModel.append( {  id: catalogItem["id"],
                                                title: catalogItem["title"],
                                                year: catalogItem["year"] ? catalogItem["year"] : "",
                                                description: catalogItem["description"],
                                                poster: catalogItem["poster_originals"][0]["path"] } );
                    });
                    catalogView.loading = false;
                    catalogView.setFocus();
                    log("catalog was updated");
                }
            } else {
                log("request error: ", request.readyState, request.responseText);
            }
        }

        request.send();
        log("request was sended");
    }
}
