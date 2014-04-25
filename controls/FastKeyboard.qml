import controls.Text;
import controls.SelectionGradient;

KeyDelegate : Rectangle {
	id: keyDelegate;
	width: parent.cellWidth;
	height: width;
	color: "#00000000";

	MainText {
//		anchors.margins: 5;
		anchors.centerIn: parent;
		text: model.letter;
	}
}

SquareDelegate : Item {
	id: squareRect;
	width: parent.cellWidth;
	height: width;

	property int letterUp: model.letterUp;
	property int letterDown: model.letterDown;
	property int upCase: model.upCase;

	Rectangle {
		id: borderRect;
		anchors.centerIn: parent;
		width: parent.width - 10;
		height: parent.height - 10;
		borderWidth: 1;
		borderColor: colorTheme.activeBorderColor;

		SelectionGradient {
			id: squareGrad;
			anchors.fill: parent;
			opacity: squareRect.activeFocus ? 1 : 0;
		}

		BigText {
			id: bigLetter;
			anchors.centerIn: parent;
		}

		GridView {
			id: squareView;
			focus: false;
			anchors.fill: parent; //parent.activeFocus ? squareRect : parent;
			cellWidth: parent.width / 3; //parent.activeFocus ? squareRect.width / 3 : parent.width / 3;
			cellHeight: cellWidth;
			model: ListModel{}
			delegate: KeyDelegate{}
			handleNavigationKeys: false;

			onCompleted: {squareView.fillKey();}

			function fillKey() {
				for (var i = 0; i < 9; i ++) {
					squareView.model.append({letter: squareRect.parent.upCase ? squareRect.model.arrayUp[i] : squareRect.model.arrayDown[i]});
				}
			}
		}
	}

	onLetterUpChanged :  {this.change();}
	onLetterDownChanged :  {this.change();}
	onUpCaseChanged :  {this.change();}
	
	function change() {
		if (model.letterUp) {
			bigLetter.text = model.upCase ? model.letterUp : model.letterDown;
			bigLetter.visible = true;
			squareView.visible = false;
//			squareGrad.visible = false;
			return;
		}
		bigLetter.visible = false;
		squareView.visible = true;
//		squareGrad.visible = true;
	}

}

SpecialDelegate : Item {
	id: specialItem;
	width: parent.width / 3;
	height: parent.height;
	
	property string text: model.text;
	property string color: model.color;
	property string borderColor: model.borderColor;

	Rectangle {
		id: specialRect;
		anchors.centerIn: parent;
		width: parent.width - 10;
		height: parent.height - 10;
		borderWidth: 1;

		SelectionGradient {
			id: squareGrad;
			anchors.fill: parent;
			opacity: specialItem.activeFocus ? 1 : 0;
		}

		SmallText {
			id: specialText;
			anchors.centerIn: parent;
		}
	}

	onTextChanged: {
		specialText.text = this.text;
	}

	onColorChanged: {
		specialText.color = this.color;
	}

	onBorderColorChanged: {
		specialRect.borderColor = this.borderColor;
	}
}

FastKeyboard: Rectangle {
	id: fastKeyboard;

	width: 40 * 3 * 3;
	height: 70 + 40 * 3 * 3 + 60;
	color: "#0D1C22";
	borderWidth: 1;
	borderColor: colorTheme.activeBorderColor;

	property string editString: "";
	property string rightString: "";
	property string result;
		
	signal keyboardCancelled();
	signal keyboardEntered(result);

	
	onRightStringChanged: {
		this.checkLength();
	}

	onEditStringChanged: {
		this.checkLength();
	}

	onVisibleChanged: {
		mainView.setFocus();
		mainView.mode = 0;
		mainView.fillSquare();
		fastKeyboard.editString = "";
		fastKeyboard.rightString = "";
	}

	function checkLength() {
		editText.text = this.editString;
		var t = false;
		while (editRectangle.width < editText.paintedWidth + 15) {
				t = true;
				editText.text = this.editString.substr(this.editString.length - editText.text.length + 1, this.editString.length - 1);
		}
		if (t) {
			rightText.text = "";
			return;
		}
		rightText.text = this.rightString;
		while (rightText.text.length != 0 && editRectangle.width < editText.paintedWidth + rightText.paintedWidth + 15) {
				rightText.text = rightText.text.slice(0, rightText.text.length - 1);
		}
	}

	Rectangle {
		id: editRectangle;
		anchors.top: parent.top;
		anchors.topMargin: 5;
		anchors.horizontalCenter: parent.horizontalCenter;
		height: 50;
		focus: true;
		width: parent.width - 10;
		borderWidth: this.activeFocus ? 5 : 1;
		borderColor: colorTheme.activeBorderColor;

		MainText {
			id: editText;
			anchors.verticalCenter: parent.verticalCenter;
			anchors.left: parent.left;
			anchors.leftMargin: 3;
		}

		Rectangle {
			id: cursorText;
			anchors.verticalCenter: parent.verticalCenter;
			anchors.left: editText.right;
			anchors.leftMargin: 2;
			color: colorTheme.activeBorderColor;
			width: 3;
			height: parent.height - 20;
			Timer {
				interval: 500;
				onTriggered: {
					cursorText.visible = !cursorText.visible;
					this.restart();
				}
				onCompleted: {
					this.restart();
				}
			}
		}

		MainText {
			id: rightText;
			anchors.verticalCenter: parent.verticalCenter;
			anchors.left: cursorText.right;
			anchors.leftMargin: 1;
		}

		onRightPressed: {
			if (fastKeyboard.rightString.length == 0) return;
			fastKeyboard.editString = fastKeyboard.editString.concat(fastKeyboard.rightString[0]);
			fastKeyboard.rightString = fastKeyboard.rightString.slice(1,fastKeyboard.rightString.length);
		}

		onLeftPressed: {
			if (fastKeyboard.editString.length == 0) return;
			var s = fastKeyboard.editString[fastKeyboard.editString.length - 1];
			fastKeyboard.editString = fastKeyboard.editString.slice(0,fastKeyboard.editString.length - 1);
			fastKeyboard.rightString = s.concat(fastKeyboard.rightString);
		}

		onDownPressed: {
			mainView.setFocus();
		}

		function move(from, to) {
		}
	}

	GridView {
		id: mainView;
		
		anchors.top: editRectangle.bottom;
		anchors.topMargin: 10;
		anchors.horizontalCenter: fastKeyboard.horizontalCenter;
		width: 40 * 3 * 3;
		height: width;
		model: ListModel{}
		delegate: SquareDelegate{}
		cellWidth: width / 3;
		cellHeight: cellWidth;
		focus: true;
		handleNavigationKeys: false;
		

		property bool upCase: false;
		property int mode: 0;
		property bool digit: false;

		onCompleted: {
			mainView.initSquare();
		}

		onUpPressed: {
			switch (mainView.currentIndex) {
			case 0: case 1: case 2: 
				editRectangle.setFocus();
				break;
			case 3: case 4: case 5: 
			case 6:	case 7: case 8: 
				mainView.currentIndex -= 3;
			}
		}

		onDownPressed: {
			switch (mainView.currentIndex) { 
			case 0: case 1: case 2: 
			case 3: case 4: case 5: 
				if (mainView.model.get(mainView.currentIndex + 3).letterUp != ' ') 
					mainView.currentIndex += 3;
				else {
					specialView.setFocus();
					specialView.currentIndex = mainView.currentIndex - 3;
				}
				break;
			case 6:	case 7: case 8: 
				specialView.setFocus();
				specialView.currentIndex = mainView.currentIndex - 6;
			}
		}

		onLeftPressed: {
			switch (mainView.currentIndex) {
			case 0: case 3: case 6: 
				break;
			case 1: case 4: case 7:
			case 2: case 5: case 8:
				if (mainView.model.get(mainView.currentIndex - 1).letterUp != ' ') 
					mainView.currentIndex --;
			}
		}

		onRightPressed: {
			switch (mainView.currentIndex) {
			case 0: case 3: case 6: 
			case 1: case 4: case 7:
				if (mainView.model.get(mainView.currentIndex + 1).letterUp != ' ') 
					mainView.currentIndex ++;
			case 2: case 5: case 8:
				break;
			}
		}

		onSelectPressed: {
			this.accept();
		}

		function shift () {
			if (mainView.mode == 1 && !mainView.digit) {
				mainView.upCase = !mainView.upCase;
				mainView.mode = 0;
				mainView.accept();
				return true;
			}
		}

		function accept() {
			if (mainView.mode == 1) {
				mainView.digit = false;
				if (mainView.currentIndex >= 0) 
					fastKeyboard.editString += (mainView.upCase ? 
						mainView.model.get(mainView.currentIndex).letterUp : mainView.model.get(mainView.currentIndex).letterDown);
				if (mainView.currentIndex == -2) 
					fastKeyboard.editString += ("0");
				mainView.mode = 0;
				mainView.fillSquare();
				mainView.upCase = false;
				specialView.setSpecial();
				return;
			}
			var arr = mainView.model.get(mainView.currentIndex);
			if (mainView.currentIndex == 7) {
				mainView.digit = true;
				specialView.model.set(1,{text: "0", color: "#ffffff", borderColor: colorTheme.activeBorderColor});
			} else 
				specialView.model.set(1,{text: "Shift", color: "#e0a000", borderColor: "#e0a000"});
			specialView.model.set(0,{text: "Back", color: "#e00000", borderColor: "#e00000"});
			for (var i = 0; i < 9; i ++) {
				mainView.model.set(i,{letterUp: arr.arrayUp ? arr.arrayUp[i] : mainView.model.get(i).letterUp, 
							 letterDown: arr.arrayDown ? arr.arrayDown[i] : mainView.model.get(i).letterDown, 
							 upCase: mainView.upCase});
			}
			mainView.mode = 1;
			mainView.currentIndex = 4;	
		}

		function initSquare() {
			for (var i = 0; i < 9; i ++)
				mainView.model.append({});
			mainView.fillSquare();
		}

		function fillSquare() {
			mainView.model.set(0,{arrayDown: "abcdefghi", arrayUp: "ABCDEFGHI"});
			mainView.model.set(1,{arrayDown: "jklmnopqr", arrayUp: "JKLMNOPQR"});
			mainView.model.set(2,{arrayDown: "stuvwxyz ", arrayUp: "STUVWXYZ "});

			mainView.model.set(3,{arrayDown: "абвгдеёжз", arrayUp: "АБВГДЕЁЖЗ"});
			mainView.model.set(4,{arrayDown: "ийклмнопр", arrayUp: "ИЙКЛМНОПР"});
			mainView.model.set(5,{arrayDown: "стуфхцчшщ", arrayUp: "СТУФХЦЧШЩ"});

			mainView.model.set(6,{arrayDown: ";?'(.)=-*", arrayUp: ":!\"<,>+_#"});
			mainView.model.set(7,{arrayDown: "123456789", arrayUp: "123456789"});
			mainView.model.set(8,{arrayDown: "ъыьэюя   ", arrayUp: "ЪЫЬЭЮЯ   "});

			mainView.currentIndex = 4;	
		}
	}

	ListView {
		id: specialView;
		anchors.top: mainView.bottom;
		anchors.horizontalCenter: fastKeyboard.horizontalCenter;
		width: fastKeyboard.width;
		height: 60;
		model: ListModel{}
		delegate: SpecialDelegate{}
		orientation: ListView.Horizontal;

		onCompleted: {
			this.initSpecial();
		}

		onUpPressed: {
			mainView.currentIndex = 6 + this.currentIndex;	
			if (mainView.model.get(mainView.currentIndex).letterUp == ' ')
				mainView.currentIndex -= 3;
			mainView.setFocus();
		}

		onDownPressed: {}

		onSelectPressed: {
			this.acceptSpecial(specialView.currentIndex);
		}

		function acceptSpecial (i) {
			switch (specialView.model.get(i).text) {
			case "Backspace": 
				if (fastKeyboard.editString.length == 0) return;
				log ("BACKSPACE");
				fastKeyboard.editString = fastKeyboard.editString.slice(0,fastKeyboard.editString.length - 1) 
				break;
			case "Space": 
				fastKeyboard.editString += " ";
				break;
			case "Shift":
				mainView.shift();
				break;
			case "Back":
				mainView.mode = 1;
				mainView.currentIndex = -1;
				mainView.accept();
				break;
			case "0":
				mainView.currentIndex = -2;
				mainView.mode = 1;
				mainView.accept();
				break;
			case "Enter":
				fastKeyboard.result = fastKeyboard.editString + fastKeyboard.rightString;
				fastKeyboard.keyboardEntered(fastKeyboard.editString + fastKeyboard.rightString);
				break;
			}
		}
		
		function initSpecial() {
			for (var i = 0; i < 3; i ++)
				this.model.append({});
			this.setSpecial();
		}

		function setSpecial() {
			this.model.set(0,{text: "Backspace", color: "#e00000", borderColor: "#e00000"});
			this.model.set(1,{text: "Space", color: "#e0a000", borderColor: "#e0a000"});
			this.model.set(2,{text: "Enter", color: "#00e0a0", borderColor: "#00e0a0"});
		}
	}
	
	onBackPressed: {
		if (mainView.mode == 1) {
			specialView.acceptSpecial(0);
			return;
		}
		this.keyboardCancelled();
	}

	onKeyPressed: {
		switch (key) {
		case "Chat": case "*": case "Red":
			log("RED!");
			specialView.acceptSpecial(0);
			break
		case "Mail": case "#": case "Green":
			specialView.acceptSpecial(2);
			break;
		case "0": case "Yellow":
			specialView.acceptSpecial(1);
			return true;
		case "1": case "2": case "3": case "4": case "5":
		case "6": case "7": case "8": case "9":
			mainView.currentIndex = key - 1;
			mainView.accept();
			return true;	
		default: return false;
		}
		return true;
	}

}
