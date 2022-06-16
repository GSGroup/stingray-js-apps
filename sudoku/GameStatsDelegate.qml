// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Delegate {
                width:200;
                height:40;

				anchors.horizontalCenter: parent.horizontalCenter;

				Image {
					 id:progress;
					 anchors.verticalCenter: time.verticalCenter;
					 anchors.left: parent.left;
					 anchors.rightMargin:1;
					 source: "apps/sudoku/img/ico_level_"+(model.isBetter?"up":"down")+".png";
				}

                BodyText {
                    id: player;
                    anchors.top: parent.top;
					anchors.left: progress.right;
					anchors.leftMargin: 10;

                    text: model.player;
                }

                BodyText {
                    id:time;
                    anchors.top: parent.top;
                    anchors.right: parent.right;
                    text: Math.floor(model.time/60)+":"+model.time%60;
                }
            }

