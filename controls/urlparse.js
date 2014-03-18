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
	r.path = url.substr(0, query_pos); //fixme: add scheme/host support
	return r;
}

this.parse = parse;
this.parse_qs = parse_qs;
