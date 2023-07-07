// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.Player;

import "js/constants.js" as constants;

Player {
    id: iviPlayer;

    focus: true;

    function playVideoById(id) {
        var request = new XMLHttpRequest();
        request.open("POST", "https://api.ivi.ru/light/", true);

        request.onreadystatechange = function() {
            if (request.readyState !== XMLHttpRequest.DONE)
                return;

            if (request.status === 200) {
                console.log("response was received");
                iviPlayer.abort();
                iviPlayer.playUrl(iviPlayer.getBestQualityVideoUrl(JSON.parse(request.responseText)["result"]["files"]));
                iviPlayer.setFocus();
            } else
                console.log("unhandled status", request.status);
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
