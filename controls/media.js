function Player() {
	this.connections = [];
}

Player.prototype = {
	constructor: Player,

	finished: function () { },
	started: function () { },

	playUrl: function(url, stream) {
		if (this.session)
			this.stop();

		if (stream)
			this.session = app.MediaPlayer().PlayMedia(url, stream.programPid, stream.pmtPid, stream.pcrPid, stream.pmt);
		else
			this.session = app.MediaPlayer().PlayMedia(url);

		this.connections.push(this.session.OnFinished().connect(this._onFinished.bind(this)));
		this.connections.push(this.session.OnStarted().connect(this._onStarted.bind(this)));
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

		for (var i = 0; i < this.connections.length; ++i) {
			log("connection " + this.connections[i]);
			this.connections[i].disconnect();
		}
		
		this.connections = [];
		this.session.reset();
		this.session = null;
	},

	seekAbs: function(position) {
		if (!this.session)
			return;

		log("seeking to " + position + "ms");
		var pos = position > this.getDuration() ? this.getDuration() : position;
		pos = position < 0 ? 0 : position;
		this.session.Seek(new stingray.TimeDuration(Math.max(0, pos)));
	},

	seek: function(msDelta) {
		if (!this.session)
			return;

		log("seeking to " + msDelta + "ms from current pos");
		this.session.Seek(new stingray.TimeDuration(Math.max(0, this.session.GetProgress() + msDelta)));
	},

	getProgress: function() {
		if (this.session)
			return this.session.GetProgress();

		return 0;
	},

	getDuration: function () {
		var mi = this.session ? this.session.GetMediaInfo(): null;
		if (!mi)
			return null;
		return mi.GetDuration().GetMilliseconds();
	},

	_onStarted: function() {
		this.started();
	},

	_onFinished: function() {
		this.finished();
	}
}

this.Player = Player; 
