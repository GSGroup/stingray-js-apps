import CatalogDelegate;

GridView {
    id: catalogView;

    cellWidth: 186;
    cellHeight: 278;

    property string url: "https://api.ivi.ru/mobileapi/videos/v5";
    property bool loading: false;

    visible: !loading;

    focus: true;
    clip: true;

//    orientation: Horizontal;
//    positionMode: Center;

    delegate: CatalogDelegate {}
    model: ListModel { id: catalogModel; }

    function loadCatalog(url) {
        catalogView.url = url;
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
