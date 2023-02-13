// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
	id: cardProto;

	signal xDone;

	property string resPath: "apps/guesser/res/";
	property string shirt: resPath + "shirt4.png";
	property string cardNumber;
	property int number;
	property bool show: false;
	property int minWidth: 80hpw;

	width: minWidth;
	height: 120hph;

	Rectangle {
		width: image.width;
		height: parent.height;

		anchors.top: image.top;
		anchors.left: image.left;
		anchors.margins: 5hpw;

		radius: 15hpw;
		color: "#0003";
	}

	Image {
		id: image;

		property bool show: false;

		width: cardProto.minWidth;
		height: parent.height;

		anchors.horizontalCenter: parent.horizontalCenter;

		source: show ? cardProto.resPath + cardProto.cardNumber + ".png" : cardProto.shirt;
		fillMode: Stretch;

		onShowChanged: { this.width = 80; }

		Behavior on width {
			animation: Animation {
				duration: 300;

				onRunningChanged: {
					if (!this.running)
						image.show = cardProto.show;
				}
			}
		}
	}

	onShowChanged: { image.width = 0; }

	Behavior on y { animation: Animation { duration: 700; } }

	Behavior on x {
		animation: Animation {
			duration: 700;

			onRunningChanged: {
				if (!this.running)
					cardProto.xDone();
			}
		}
	}
}
