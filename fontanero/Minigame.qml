// Copyright (c) 2011 - 2019, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "MinigameDelegate.qml";

Item {
	id: minigameItem;

	property int size;
	property int bonus;

	visible: false;
	focus: true;

	Rectangle {
		anchors.fill: mainWindow;
		color: "#000c";
	}

	ListModel {
		id: minigameModel;
	}

	TitleText {
		id: bonusText;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.bottom: minigameView;
		text: "BONUS: $" + minigameItem.bonus;
	}

	GridView {
		id: minigameView;
		cellWidth: 400 / parent.size;
		cellHeight: 400 / parent.size;
		width: cellWidth * parent.size;
		height: cellHeight * parent.size;
		anchors.centerIn: parent;

		focus: true;

		model: minigameModel;
		delegate: MinigameDelegate {}
	}

	function toggle(index) {
		var n = this.size;
		var x = index % n, y = Math.floor(index / n);
		//log("toggle index", index, x, y);
		for(var i = 0; i < n; ++i) {
			var idx = n * y + i;
			var row = minigameModel.get(idx);
			minigameModel.setProperty(idx, 'fixed', !row.fixed);
		}
		for(var i = 0; i < n; ++i) {
			if (i == y)
				continue;
			var idx = n * i + x;
			var row = minigameModel.get(idx);
			minigameModel.setProperty(idx, 'fixed', !row.fixed);
		}
	}

	function won() {
		var n = this.size;
		for(var i = 0; i < n * n; ++i)
			if (!minigameModel.get(i).fixed)
				return false;
		return true;
	}

	Timer {
		id: bonusTimer;
		interval: 200;
		repeat: true;
		onTriggered: {
			var sub = 1 + Math.floor(Math.random() * minigameItem.bonus / 100);
			var r = minigameItem.bonus - sub;
			minigameItem.bonus = r > 1? r: 1;
		}
	}

	start: {
		log("maximum bonus is", this.bonus);
		minigameModel.reset();
		var n = this.size;
		for(var i = 0; i < n; ++i) {
			for(var j = 0; j < n; ++j) {
				minigameModel.append({ fixed: true });
			}
		}
		for(var i = 0; i < 50; ++i) {
			var idx = Math.floor(n * n * Math.random());
			this.toggle(idx);
		}
		if (this.won()) {
			var idx = Math.floor(n * n * Math.random());
			this.toggle(idx);
		}
		minigameView.currentIndex = n * n / 2;
		bonusTimer.running = true;
		this.visible = true;
		minigameView.setFocus();
	}

	onKeyPressed: {
		if (key == "Select") {
			this.toggle(minigameView.currentIndex);
			if (this.won()) {
				bonusTimer.running = false;
				this.visible = false;
			}
			return true;
		} else if (key == "Back") {
			this.bonus = 1;
			this.visible = false;
		}
		return true;
	}
}
