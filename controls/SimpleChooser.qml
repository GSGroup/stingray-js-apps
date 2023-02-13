// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "SimpleChooserDelegate.qml";

Item {
	id: chooserItem;
	property bool showArrows: true;
	property bool showAtCenter: true;
	property bool onlyOneItemVisible: true;
	height: 50hph;
	property alias currentIndex: listView.currentIndex;
	property alias count: listView.count;
	property int spacing: 5hpw;
	
	Image {
		anchors.left: parent.left;
		anchors.verticalCenter: listView.verticalCenter;
		anchors.rightMargin: 8hpw;
		source: colorTheme.pathToStyleFolder + "/left.svg";
		visible: chooserItem.showArrows;
		opacity: parent.activeFocus ? 1 : 0.3;
		width: 32hpw;
		
		Behavior on opacity {
			animation: Animation {
				duration: 300;
			}
		}
	}
	
	ListView {
		id: listView;
		anchors.fill: parent;
		anchors.leftMargin: (chooserItem.showAtCenter ? Math.max((chooserItem.width - 60hpw - contentWidth) / 2, 0) : 0) + 30hpw;
		anchors.rightMargin: 30hpw;
		orientation: Horizontal;
		wrapNavigation: true;
		clip: true;
		delegate: SimpleChooserDelegate { }
		model: ListModel { }
		spacing: chooserItem.spacing;
	}
	
	Image {
		anchors.right: parent.right;
		anchors.verticalCenter: listView.verticalCenter;
		anchors.rightMargin: 8hpw;
		source: colorTheme.pathToStyleFolder + "/right.svg";
		visible: chooserItem.showArrows;
		opacity: parent.activeFocus ? 1 : 0.3;
		width: 32hpw;
		
		Behavior on opacity {
			animation: Animation {
				duration: 300;
			}
		}
	}

	function append(text) {
		console.log("appending to chooser " + text);
		this.listView.model.append({"text": text});
	}
	
	Behavior on opacity {
		animation: Animation {
			duration: 300;
		}
	}
}
