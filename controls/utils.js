// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

var Color = function(color) {
	if (!((color.length == 4 || color.length == 7 || color.length == 9) && color[0] == "#"))
		throw new Error("Invalid color presentation");
	
	if (color.length == 4) {
		var newColor = "#";

		for (var i = 1; i < color.length; ++i)
			newColor += color[i] + color[i];

		color = newColor;
	}
	
	this.r = parseInt(color.substr(1, 2), 16);
	this.g = parseInt(color.substr(3, 2), 16);
	this.b = parseInt(color.substr(5, 2), 16);
	this.a = color.length == 9 ? parseInt(color.substr(7, 2), 16) : 255;
};

Color.prototype.toString = function() {
	var toHex = function (a) {
		return ("0" + a.toString(16)).slice(-2);
	}
	return "#" + toHex(this.r) + toHex(this.g) + toHex(this.b) + toHex(this.a);
};

this.lighter = function (color, coeff) {
	var c = new Color(color);

	for (var i in c) {
		if (i != 'a' && i != 'toString')
			c[i] = Math.min(Math.floor(c[i] * coeff), 255);
	}

	return c.toString();
}

this.setAlpha = function (color, alpha) { // 0..255
	var c = new Color(color);
	c.a = alpha;
	return c.toString();
}
