// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "SimpleChooserDelegate.qml";

Item {
	id: chooserItem;

	height: 50hph;

	property bool showArrows: true;
	property bool showAtCenter: true;
	property bool onlyOneItemVisible: true;

	property int spacing: 5hpw;

	property alias currentIndex: listView.currentIndex;
	property alias count: listView.count;

	Behavior on opacity { animation: Animation { duration: 300; } }
	
	Image {
		anchors.left: parent.left;
		anchors.rightMargin: 8hpw;
		anchors.verticalCenter: listView.verticalCenter;

		sourceWidth: 32hpw;

		source: colorTheme.pathToStyleFolder + "/left.svg";
		fillMode: PreserveAspectFit;

		visible: chooserItem.showArrows;
		opacity: parent.activeFocus ? 1 : 0.3;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}
	
	ListView {
		id: listView;

		anchors.leftMargin: (chooserItem.showAtCenter ? Math.max((chooserItem.width - 60hpw - contentWidth) / 2, 0) : 0) + 30hpw;
		anchors.rightMargin: 30hpw;
		anchors.fill: parent;

		orientation: Horizontal;
		wrapNavigation: true;
		clip: true;
		spacing: chooserItem.spacing;

		model: ListModel { }
		delegate: SimpleChooserDelegate { }
	}
	
	Image {
		anchors.right: parent.right;
		anchors.rightMargin: 8hpw;
		anchors.verticalCenter: listView.verticalCenter;

		sourceWidth: 32hpw;

		source: colorTheme.pathToStyleFolder + "/right.svg";

		fillMode: PreserveAspectFit;

		visible: chooserItem.showArrows;
		opacity: parent.activeFocus ? 1 : 0.3;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}

	function append(text) {
		console.log("appending to chooser " + text);
		this.listView.model.append({"text": text});
	}
}
