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
                iviPlayer.playVideoByUrl(iviPlayer.getBestQualityVideoUrl(JSON.parse(request.responseText)["result"]["files"]));
            } else
                log("unhandled status", request.status);
        }

        var parameters = {params: [ id, { site: "s175"} ],
            method: "da.content.get"};
        request.open("POST", "https://api.ivi.ru/light/", true);
        request.send(JSON.stringify(parameters));
    }

    function getBestQualityVideoUrl(files) {
        var result = "";
        var qualities = ["MP4-hi", "MP4-lo", "MP4-mobile", "MP4-low-mobile"];
        qualities.forEach(function(quality) {
            if (result)
                return;

            files.forEach(function(file) {
                if(file["content_format"] === quality) {
                    result = file["url"];
                    return;
                }
            });
        });

        return result;
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
                iviPlayer.setFocus();
            } else {
                log("unhandled status", request.status);
                return;
            }
        }

        request.open("HEAD", url, true);
        request.send();
    }
}
