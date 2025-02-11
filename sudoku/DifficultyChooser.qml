// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "DifficultyChooserDelegate.qml";

Item {
	id: dChooserItem;
	property bool showArrows: true;
	property bool showAtCenter: true;
	property bool onlyOneItemVisible: true;
	height: 50hph;
	property alias currentIndex: listView.currentIndex;
	property int count: listView.count;

	ListView {
		id: listView;
		anchors.fill: parent;
		anchors.leftMargin: (dChooserItem.showAtCenter ? Math.max((dChooserItem.width - 60hpw - contentWidth) / 2, 0) : 0) + 30hpw;
		anchors.rightMargin: 30hpw;
		orientation: ui.ListView.Orientation.Horizontal;
		wrapNavigation: true;
		clip: true;
		uniformDelegateSize: true;
		delegate: DifficultyChooserDelegate { }
		model: ListModel { }
		spacing: 1hpw;
	}

	function append(obj) {
		console.log("appending to difficulty chooser " );
		this.listView.model.append(obj);
	}

	Behavior on opacity {
		animation: Animation {
			duration: 300;
		}
	}
}
