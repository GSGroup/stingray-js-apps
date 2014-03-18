var parse_qs = function(qs) {
	var r = {}
	var pairs = qs.split('&');
	pairs.forEach(function(pair) {
		pair = pair.split("=")
		r[pair[0]] = pair[1]
	})
	return r;
}

var parse = function(url) {
	var r = {};
	var path_pos;
	var scheme_pos = url.indexOf("://");
	if (scheme_pos >= 0) {
		r.scheme = url.slice(0, scheme_pos);
		path_pos = url.indexOf("/", scheme_pos + 3);
		if (path_pos < 0)
			path_pos = url.length;

		r.host = url.slice(scheme_pos + 3, path_pos);
	}
	else {
		r.scheme = "";
		r.host = "";
		path_pos = 0;
	}

	var query_pos = url.indexOf('?');
	var anchor_pos = url.indexOf('#');
	if (anchor_pos < 0)
		anchor_pos = url.length;

	if (query_pos != -1) {
		r.query = url.slice(query_pos + 1, anchor_pos);
	} else {
		r.query = "";
		query_pos = url.length;
	}

	r.anchor = url.substr(anchor_pos);
	r.path = url.slice(path_pos, query_pos); //fixme: add scheme/host support
	return r;
}

this.parse = parse;
this.parse_qs = parse_qs;
