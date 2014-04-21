import controls.Text;
import "engine.js" as engine;

CellDelegate : Rectangle {
	id: rect;
	height: parent.cellHeight;
	width: parent.cellWidth;
	property int value: -1;
	property int added: false;
	Behavior on x { animation: Animation { duration: rect.value < 2 || rect.added ? 0 : 300; } }
	Behavior on y { animation: Animation { duration: rect.value < 2 || rect.added ? 0 : 300; } }
	z: value ? 1 : 0;

	Rectangle {
		id: innerRect;
		radius: 10;
		anchors.fill: parent;
		anchors.margins: 10;
		Behavior on color { animation: Animation { duration: rect.added ? 300 : 0; } }
		Behavior on x { animation: Animation { duration: rect.added ? 150 : 0; } }
		Behavior on y { animation: Animation { duration: rect.added ? 150 : 0; } }
		Behavior on width { animation: Animation { duration: rect.added ? 150 : 0; } }
		Behavior on height { animation: Animation { duration: rect.added ? 150 : 0; } }
		
		Text {
			text: rect.value ? rect.value : "";	
			anchors.centerIn: parent;
			color: rect.value <= 4 ? "#6D654E" : "#ffffff";
			font: ubuntu_mono;
		}
	} 

	Timer {
		id: scaleTimer;
		interval: 150;
		onTriggered: {
			innerRect.anchors.margins = 10;
		}
	}

	function doscale () {
		innerRect.anchors.margins = 0;
		scaleTimer.restart();
	}

	onValueChanged: {
		if (rect.value && rect.added) this.doscale();
		switch (rect.value) {
		case 0: innerRect.color =  "#ccc0b2"; break; 
		case 2: innerRect.color = "#eee4da"; break;
		case 4: innerRect.color = "#ECE0CA"; break;
		case 8: innerRect.color = "#EEB57E"; break;
		case 16: innerRect.color = "#F39562"; break;
		case 32: innerRect.color = "#FD7D60"; break;
		case 64: innerRect.color = "#F55837"; break;
		case 128: innerRect.color = "#F4CA78"; break;
		case 256: innerRect.color = "#EDCA6C"; break;
		case 512: innerRect.color = "#EFCA45"; break;
		case 1024: innerRect.color = "#F0C63C"; break;
		case 2048: innerRect.color = "#F0C129"; break;
		default: innerRect.color = "#000000"; 
		}
	}
	color: "#bcb0a200";
}

MenuDelegate: Rectangle {
	anchors.centerIn: parent;
	width: parent.cellWidth;
	height: parent.cellHeight;
	color: "#00000000";
	Rectangle {
		anchors.centerIn: parent;
		color: parent.activeFocus ? "#835A22FF" : "#734A12AA";
		radius: 10;
		width: parent.width;
		height: parent.height / 2;
		Text {
			anchors.centerIn: parent;
			font: ubuntu_mono;
			color: "#FFFFFF";
			text: model.text;
		}
	}
}

FieldModel : ListModel {
onCompleted: {engine.init();}
}

Game : Rectangle {
	id: game;
	anchors.centerIn: parent;
	height: safeArea.height;
	property int space: 10;
	property int cellSize:  (safeArea.height - space * 4) / 4;
	width: cellSize * 4 + space * 4;
	color: parent.color;
	focus: true;

	Rectangle {
		id: gridRect;
		radius: 10;
		anchors.top: parent.top;
		anchors.bottom: parent.bottom;
		anchors.left: parent.left;
		anchors.margins: game.space;
		color: "#bcb0a2";
		height: parent.height;
		width: parent.width - game.space * 2;

		Item {
			id: fieldView;
			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}
			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}
			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}
			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}

			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}
			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}
			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}
			CellDelegate{} CellDelegate{} CellDelegate{} CellDelegate{}

			anchors.fill: parent;
			anchors.margins: game.space;
			focus: false;
			property int cellHeight:game.cellSize;
			property int cellWidth: game.cellSize;

			Timer {
				id: animTimer;
				interval: 300;
				onTriggered: {
					fieldView.next();
				}
			}

			onCompleted: {
				this.swapList = new Array(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15);
				this.elements = new Array();
				for (var i = 0; i < 16; i ++)
					this.elements.push({val: 0, added: false, joined: false});
				for (var i = 16; i < 32; i ++) {
					this.children[i].value = 0;
					this.children[i].added = false;
					this.children[i].x = (i % 4) * this.cellWidth;
					this.children[i].y = Math.floor(i / 4 - 4) * this.cellHeight;
				}
				engine.add();
				engine.add();
//				engine.set(0,0,2);
				this.draw();
			}

			function draw() {
				log(this.swapList);
				for (var i = 0; i < 16; i ++) {
//					this.children[i].value = this.swapList[i]; //this.elements[i].val;
					if (this.elements[i].joined) {
//						this.children[this.swapList[i]].value = 2048;
						this.children[i + 16].value = this.children[this.swapList[i]].value;
					} else {
						if (!this.elements[i].added)
							this.children[this.swapList[i]].value = this.elements[i].val;
						else 
							this.children[this.swapList[i]].value = 0;
					}
					this.children[this.swapList[i]].added = this.elements[i].added;
					this.children[this.swapList[i]].x = (i % 4) * this.cellWidth;
					this.children[this.swapList[i]].y = Math.floor(i / 4) * this.cellHeight;
//					log (oldx + ',' + oldy + " now at " + this.children[i].x + ',' + this.children[i].y);
				}
				animTimer.restart();
			}

			function next() {
				for (var i = 16; i < 32; i ++) 
					this.children[i].value = 0;
				for (var i = 0; i < 16; i ++) {
					if (this.elements[i].added) {
						this.children[this.swapList[i]].value = this.elements[i].val;
					}
					if (this.elements[i].joined) {
						this.children[this.swapList[i]].added = true;
						this.children[this.swapList[i]].value *= 2;
					}
				}
			}
		}
	}

	direction: "Up";

	Rectangle {
		id: bestRect;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.left: parent.right;
		anchors.bottomMargin: game.cellSize;
		anchors.leftMargin: game.space;
		height: game.cellSize / 1.5;
		radius: 10;
		width: { return Math.min((safeArea.width - parent.width) / 2 - game.space * 2, game.cellSize * 1.5);};
		color: "#CCC0B2";

		Text {
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.top: parent.top;
			anchors.topMargin: game.space;
			text: "BEST";
			color: "#EEE4DA";
			font: ubuntu_mono;
		}

		Text {
			id: bestText;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.bottom: parent.bottom;
			anchors.bottomMargin: game.space;
			property int val: {
				var x;
				if (!(x = load("best2048"))) 
					return 0; 
				else 
					return x;
			}
			text: val;
			font: ubuntu_mono;
			color: "#FFFFFF";
		}			
	}

	Rectangle {
		id: scoreRect;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.left: parent.right;
		anchors.topMargin: game.cellSize;
		anchors.leftMargin: game.space;
		height: game.cellSize / 1.5;
		radius: 10;
		width: { return Math.min((safeArea.width - parent.width) / 2 - game.space * 2, game.cellSize * 1.5);};
		color: "#CCC0B2";

		Text {
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.top: parent.top;
			anchors.topMargin: game.space;
			text: "SCORE";
			color: "#EEE4DA";
			font: ubuntu_mono;
		}

		Text {
			id: scoreText;
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.bottom: parent.bottom;
			anchors.bottomMargin: game.space;
			property int val: 0;
			text: val;
			font: ubuntu_mono;
			color: "#FFFFFF";
		}			
	}

	Rectangle {
		id: restartMenu;
		focus: false;
		visible: false;
		anchors.fill: parent;
		radius: 10;
		color: "#EEE4DAB0";

		Text {
			anchors.centerIn: parent;
			anchors.bottomMargin: game.cellSize / 2;
			font: ubuntu_mono;
			color: "#734A12";
			text: "GAME OVER";
		}

		Rectangle {
			anchors.centerIn: parent;
			anchors.topMargin: game.cellSize / 2;
			color: "#734A12";
			radius: 10;
			width: game.cellSize;
			height: game.cellSize / 2;

			Text {
				anchors.centerIn: parent;
				font: smallFont;
				color: "#FFFFFF";
				text: "Try again";
			}
		}
	}

	ListModel {
		id: menuModel;
		ListElement {text: "Continue"}
		ListElement {text: "New game"}
		ListElement {text: "Exit"}
	}

	Rectangle {
		id: backMenu;
		visible: true;
		focus: true;
//		anchors.fill: parent;
		anchors.centerIn: parent;
		height: parent.height;
		radius: 10;
		color: "#EEE4DAB0";
		width: 0;
		Behavior on width { animation: Animation { duration: 300; } }

		GridView {
			id: backGrid;
			focus: true;
			visible: false;
			cellHeight: game.cellSize;
			cellWidth: game.cellSize * 2;
			anchors.horizontalCenter: parent.horizontalCenter;
			height: game.cellSize * 3;
			width: game.cellSize;
			model: ListModel {
				ListElement {text: "Continue"}
				ListElement {text: "New game"}
//				ListElement {text: "Exit"}
			}
			delegate: MenuDelegate{}
			handleNavigationKeys: false;
		}
	}
	
//	onBackPressed: {
//		backMenu.width = backMenu.width == 0 ? game.width : 0;
//		backGrid.visible = !backGrid.visible;
//		backGrid.currentIndex = 0;
//	}

	onKeyPressed: {
		if (animTimer.running) 
			return true;
		if (backMenu.width != 0) {
			switch (key) {
			case "Down":
				if (backGrid.currentIndex == 2) 
					backGrid.currentIndex = 0;
				else 
					backGrid.currentIndex++;
				break;
			case "Up":
				if (backGrid.currentIndex == 0)
					backGrid.currentIndex = 2;
				else 
					backGrid.currentIndex--;
				break;
			case "Select":
				switch (backGrid.currentIndex) {
				case 0: 
					backMenu.width = 0;
					backGrid.visible = false;
					break;
				case 1:
					engine.clear();
					fieldView.draw();
					scoreText.val = 0;
					backMenu.width = 0;
					backGrid.visible = false;
					break;
				case 2:
					backMenu.width = 0;
					backGrid.visible = false;
				}
			}
			return;
		}

		if (key == "Select") {
			if (restartMenu.visible) {
				engine.clear();
				fieldView.draw();
				scoreText.val = 0;
				restartMenu.visible = false;
				restartMenu.focus = false;
				return;
			}
			backGrid.visible = true;;
			backGrid.currentIndex = 0;
			backMenu.width = game.width;
			backGrid.focus = true;
			log("INDEX " + backGrid.currentIndex)
		}

		engine.tic();
		switch (key) {
		case "Up": case "Down": case "Left": case "Right":
			game.direction = key;
			var res = engine.turn();
			if (res.changed) engine.add();
			scoreText.val += res.sum;
			if (scoreText.val > bestText.val) {
				bestText.val = scoreText.val;
				save("best2048",scoreText.val);
			}
			if (!engine.check()) {
				restartMenu.visible = true;
				restartMenu.focus = true;
			}
			fieldView.draw();
			break;
		}
	}
}
