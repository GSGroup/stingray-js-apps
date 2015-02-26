import controls.BigText;
import controls.SelectionGradient;

Item {
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

