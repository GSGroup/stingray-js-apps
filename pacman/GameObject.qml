// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
	id: gameObjectProto;

	property int cellX;
	property int cellY;
	property int speed;
	property bool faceLeft;
	property int dx;
	property int dy;

	x: width * cellX - width / 2;
	y: height * cellY - height / 2;

	Behavior on x { animation: Animation { duration: gameObjectProto.speed; } }
	Behavior on y { animation: Animation { duration: gameObjectProto.speed; } }

	function move() {
		gameObjectProto.cellX += gameObjectProto.dx;
		gameObjectProto.cellY += gameObjectProto.dy;

		if (gameObjectProto.dx != 0)
			gameObjectProto.faceLeft = gameObjectProto.dx < 0;
	}
}
