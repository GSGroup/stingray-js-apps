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
	this.instance = new VkApi("9e6de9d3e742a061453f432d0d8bcad7", "3ac2c3dcd33c54f991756f5c5fc41d61");
