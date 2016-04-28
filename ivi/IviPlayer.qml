import controls.Player;

Player {
    id: iviPlayer;

    focus: true;

    isFullscreen: true;

    function playVideoById(id) {
        var request = new XMLHttpRequest();
        request.open("POST", "https://api.ivi.ru/light/");
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    log("response was received");
                    log(request.responseText);
                    iviPlayer.stop();
                    iviPlayer.playUrl(JSON.parse(request.responseText)["result"]["files"][1].url);
                }
            } else {
                log("request error: ", request.readyState, request.responseText);
            }
        }

        var parameters = {params: [ id, { site: "s175"} ],
                          method: "da.content.get"};
        request.send(JSON.stringify(parameters));
    }
}