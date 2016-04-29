import controls.Player;

Player {
    id: iviPlayer;

    focus: true;

    isFullscreen: true;

    function playVideoById(id) {
        var request = new XMLHttpRequest();
        request.open("POST", "https://api.ivi.ru/light/", true);
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    log("response was received");
                    log(request.responseText);
                    iviPlayer.playVideoByUrl(JSON.parse(request.responseText)["result"]["files"][2].url);
                }
            } else {
                log("request error: ", request.readyState, request.responseText);
            }
        }

        var parameters = {params: [ id, { site: "s175"} ],
            method: "da.content.get"};
        request.send(JSON.stringify(parameters));
    }

    function playVideoByUrl(url) {
        log("parsing url", url);
        var request = new XMLHttpRequest();
        request.open("GET", url, true);
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 302) {
                    var location = request.getResponseHeader("Location");
                    log("video url received", location, "content-type", request.getResponseHeader("Content-Type"));
                        iviPlayer.stop();
                        iviPlayer.playUrl(location);
                }
            } else {
                log("request error: ", request.readyState, request.responseText);
            }
        }
        request.send();
    }
}
