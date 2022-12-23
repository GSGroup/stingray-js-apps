// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

const RtspLowerLevelProtocol = {
	UDP: 0,
	TCP: 1,
};
this.RtspLowerLevelProtocol = RtspLowerLevelProtocol;

function Player() {
	this.connections = [];
}

Player.prototype = {
	constructor: Player,

	finished: function (finished) { },
	started: function (started) { },

	playMedia: function (mediaData) {
		if (this.session)
			this.stop();

		this.session = mediaData.play();

		this.connections.push(this.session.OnFinished().connect(this._onFinished.bind(this)));
		this.connections.push(this.session.OnStarted().connect(this._onStarted.bind(this)));
	},

	playUrl: function(url) {
		this.playMedia({ play: () => app.MediaPlayer().PlayUrl(url) });
	},

	playRtsp: function(url, protocol, login, password) {
		this.playMedia({ play: () => app.MediaPlayer().PlayRtsp(url, protocol, login, password) });
	},

	pause: function(pause) {
		if (!this.session)
			return;

		this.session.Pause(pause);
	},

	stop: function() {
		if (!this.session)
			return;

		for (var i = 0; i < this.connections.length; ++i) {
			console.log("connection " + this.connections[i]);
			this.connections[i].disconnect();
		}
		
		this.connections = [];

		app.MediaPlayer().Stop(this.session);
		this.session.reset();
		this.session = null;
	},

	seekAbs: function(position) {
		if (!this.session)
			return;

		console.log("seeking to " + position + "ms");
		var pos = position > this.getDuration() ? this.getDuration() : position;
		pos = position < 0 ? 0 : position;
		this.session.Seek(new stingray.TimeDuration(Math.max(0, pos)));
	},

	seek: function(msDelta) {
		if (!this.session)
			return;

		console.log("seeking to " + msDelta + "ms from current pos");
		this.session.Seek(new stingray.TimeDuration(Math.max(0, this.getProgress() + msDelta)));
	},

	getProgress: function() {
		var p = this.session ? this.session.GetProgress(): null;
		if (!p)
			return null;
		return p.GetMilliseconds();
	},

	getDuration: function () {
		var d = this.session ? this.session.GetDuration(): null;
		if (!d)
			return null;
		return d.GetMilliseconds();
	},

	_onStarted: function(started) {
		this.started(started);
	},

	_onFinished: function(finished) {
		this.finished(finished);
	}
}

this.Player = Player; 
