// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

var decode = function(str) {
	return decodeURIComponent(str.replace(/\+/g, ' '));
}

var parse_qs = function(qs) {
	var r = {}
	var pairs = qs.split('&');
	pairs.forEach(function(pair) {
		pair = pair.split("=")
		if (pair.length > 1)
			r[decode(pair[0])] = decode(pair[1])
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
	var fragment_pos = url.indexOf('#');
	if (fragment_pos != -1)
	{
		r.fragment = url.substr(fragment_pos + 1);
	}
	else
	{
		r.fragment = "";
		fragment_pos = url.length;
	}

	if (query_pos != -1) {
		r.query = url.slice(query_pos + 1, fragment_pos);
	} else {
		r.query = "";
		query_pos = url.length;
	}

	var path_end = fragment_pos < query_pos? fragment_pos: query_pos;

	r.path = url.slice(path_pos, path_end); //fixme: add scheme/host support
	return r;
}

this.parse = parse;
this.parse_qs = parse_qs;
