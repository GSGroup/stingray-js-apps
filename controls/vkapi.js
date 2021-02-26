// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

function VkApi(accessToken) {
	this.accessToken = accessToken;
}

VkApi.prototype = {
	constructor: VkApi,

	makeRequest: function(method, params, cb) {
		log("making request");
		var request = "";

		for (var key in params)
			request += key + "=" + params[key] + "&";

		var url = "https://api.vk.com/method/" + method + "?" + request + "access_token=" + this.accessToken;
		log(url);
		var req = new XMLHttpRequest();
		req.onreadystatechange = function() {
			if (req.status == 200 && req.readyState == XMLHttpRequest.DONE) {
				log(req.responseText);
				cb(JSON.parse(req.responseText));
			}
		}
		req.open('GET', url, true);
		req.send();
	}
}

this.VkApi = VkApi;

if (this.instance == undefined)
	this.instance = new VkApi("8e9867ad31e5abfa0f5a0bb458e18f651cf84c68b56fca664f7995bc6cf6ce3e534e3c4c9a871c8b2beef");
