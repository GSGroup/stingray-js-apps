var getVideoUrl = function (id) {
    var request = new XMLHttpRequest();
    request.open("POST", url);
    request.onreadystatechange = function() {
        if (request.readyState === XMLHttpRequest.DONE) {
            if (request.status && request.status === 200) {
                log("response was received");
                log(request.responseText);
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
}
