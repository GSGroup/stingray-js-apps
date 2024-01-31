// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
	id: gameObjectProto;

	property int cellX;
	property int cellY;
	property int animationDuration;
	property bool faceLeft;
	property int dx;
	property int dy;
	property int targetOffsetX;
	property int targetOffsetY;

	x: width * cellX - width / 2;
	y: height * cellY - height / 2;

	Behavior on x {
		id: xAnimation;

		animation: Animation { duration: gameObjectProto.animationDuration; }
	}

	Behavior on y {
		id: yAnimation;

		animation: Animation { duration: gameObjectProto.animationDuration; }
	}

	function move() {
		gameObjectProto.cellX += gameObjectProto.dx;
		gameObjectProto.cellY += gameObjectProto.dy;

		if (gameObjectProto.dx != 0)
			gameObjectProto.faceLeft = gameObjectProto.dx < 0;
	}

	function reset(x, y) {
		gameObjectProto.cellX = x;
		xAnimation.complete();

		gameObjectProto.cellY = y;
		yAnimation.complete();

		gameObjectProto.dx = 0;
		gameObjectProto.dy = 0;
	}
}
