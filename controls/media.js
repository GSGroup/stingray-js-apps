function Player() {
	this.connections = [];
}

Player.prototype = {
	constructor: Player,

	finished: function () { },

	playUrl: function(url) {
		if (this.session)
			this.stop();

		this.session = app.MediaPlayer().PlayMedia(url);
		this.connections.push(this.session.OnFinished.connect(this._onFinished.bind(this)));
	},

	pause: function(pause) {
		if (!this.session)
			return;

		if (pause)
			this.session.Pause();
		else
			this.session.Play();
	},

	stop: function() {
		if (!this.session)
			return;

		for (var i = 0; i < this.connections.length; ++i)
			this.connections[i].disconnect();

		this.connections = [];
		this.session.reset();
	},

	seek: function(msDelta) {
		if (!this.session)
			return;

		log("seeking to " + msDelta + "ms from current pos");
		this.session.Seek(Math.max(0, this.session.GetProgress() + msDelta));
	},

	getProgress: function() {
		if (this.session)
			return this.session.GetProgress();

		return 0;
	},

	getSeekableRange: function() {
		if (this.session)
			return [this.session.GetSeekableRange().GetStart(), this.session.GetSeekableRange().GetEnd()];
		else
			return [0, 0];
	},

	getSeekableRangeStart: function() {
		return this.getSeekableRange()[0];
	},

	getSeekableRangeEnd: function() {
		return this.getSeekableRange()[1];
	},

	getMediaInfo: function() {
		return this.session? this.session.GetMediaInfo(): null;
	},

	getDuration: function () {
		var mi = this.session ? this.session.GetMediaInfo(): null;
		if (!mi)
			return null;
		return mi.GetDuration().GetMilliseconds();
	},

	_onFinished: function() {
		this.finished();
	}
}

this.Player = Player; 
