import controls.Player;

import "js/constants.js" as constants;

Player {
    id: iviPlayer;

    focus: true;

    isFullscreen: true;

    function playVideoById(id) {
        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if (request.readyState !== XMLHttpRequest.DONE)
                return;

            if (request.status === 200) {
                log("response was received");
                log("video response", request.responseText);
                var files = JSON.parse(request.responseText)["result"]["files"];
                iviPlayer.playVideoByUrl(files[files.length - 1].url);
            } else
                log("unhandled status", request.status);
        }

        var parameters = {params: [ id, { site: "s175"} ],
            method: "da.content.get"};
        request.open("POST", "https://api.ivi.ru/light/", true);
        request.send(JSON.stringify(parameters));
    }

    function playVideoByUrl(url) {
        log("play video by url", url);
        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if (request.readyState !== XMLHttpRequest.DONE)
                return;

            log("header was received");
            //log(request.responseText);
            if(request.status === 302) {
                var location = request.getResponseHeader("Location");
                log("redirect url", location);
                iviPlayer.playVideoByUrl(location);
            } else if (request.status === 200) {
                iviPlayer.abort();
                iviPlayer.playUrl(url);
            } else {
                log("unhandled status", request.status);
                return;
            }
        }

        request.open("HEAD", url, true);
        request.send();
    }
}
