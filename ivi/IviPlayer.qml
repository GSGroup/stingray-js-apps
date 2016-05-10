import controls.Player;

import "js/constants.js" as constants;

Player {
    id: iviPlayer;

    focus: true;

    isFullscreen: true;

    function playVideoById(id) {
        var request = new XMLHttpRequest();
        request.open("POST", "https://api.ivi.ru/light/", true);

        request.onreadystatechange = function() {
            if (request.readyState !== XMLHttpRequest.DONE)
                return;

            if (request.status === 200) {
                log("response was received");
                iviPlayer.abort();
                iviPlayer.playUrl(iviPlayer.getBestQualityVideoUrl(JSON.parse(request.responseText)["result"]["files"]));
                iviPlayer.setFocus();
            } else
                log("unhandled status", request.status);
        }

        var parameters = {params: [ id, { site: "s175"} ],
            method: "da.content.get"};
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
}
