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
