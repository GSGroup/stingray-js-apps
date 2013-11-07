var playUrl = function(url) {
	log("playUrl: playing url " + url);
	//var reqtype = new stingray.HttpRequestType("GET");
	//var req = new stingray.HttpRequest(reqtype, url);
	//var md = new stingray.HttpMp3MediaData(req);
	return app.MediaPlayer().PlayMedia(url);
}


this.playUrl = playUrl
