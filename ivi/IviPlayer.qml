import controls.Player;

Player {
    id: iviPlayer;

    focus: true;

    isFullscreen: true;

    function playVideoById(id) {
        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if (request.readyState !== XMLHttpRequest.DONE)
                return;

            if (request.status && request.status === 200) {
                log("response was received");
                log(request.responseText);
                iviPlayer.playVideoByUrl(JSON.parse(request.responseText)["result"]["files"][2].url);
            } else
                log("unhandled status", request.status);
        }

        var parameters = {params: [ id, { site: "s175"} ],
            method: "da.content.get"};
        request.open("POST", "https://api.ivi.ru/light/", true);
        request.send(JSON.stringify(parameters));
    }

    function playVideoByUrl(url) {
        log("parsing url", url);
        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if (request.readyState !== XMLHttpRequest.DONE)
                return;

            if (request.status && request.status === 302) {
                var location = request.getResponseHeader("Location");
                log("video url received", location);
                iviPlayer.stop();
                iviPlayer.playUrl(location);
            } else
                log("unhandled status", request.status);
        }

        request.open("GET", url, true);
        request.send();
    }
}
