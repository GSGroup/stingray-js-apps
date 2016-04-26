import CatalogDelegate;

ListView {
    id: catalogView;

    property string url;

    focus: true;

    orientation: Horizontal;
    positionMode: Center;

    delegate: CatalogDelegate {}
    model: ListModel { id: catalogModel; }

    onCompleted: {
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
                        catalogModel.append( {
                                                id: catalogItem["id"],
                                                title: catalogItem["title"],
                                                year: catalogItem["year"] ? catalogItem["year"] : "",
                                                description: catalogItem["description"],
                                                poster: catalogItem["thumbnails"][0]["path"] } );
                    });
                    catalogModel.sync();
                    log("promo catalog was updated");
                }
            } else {
                log("request error: ", request.readyState, request.responseText);
            }
        }

        request.send();
        log("request was sended");
    }
}
