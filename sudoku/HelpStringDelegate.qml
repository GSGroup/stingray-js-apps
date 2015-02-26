import controls.SmallText

Item {
				  height: 20;
				  width: 400;
				  anchors.horizontalCenter: parent.horizontalCenter;
				  SmallText {
				  anchors.horizontalCenter: parent.horizontalCenter;
				  text: model.text;
				  }
		}
