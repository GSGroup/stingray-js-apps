import controls.SmallText;
import controls.SelectionGradient;

Item {
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
