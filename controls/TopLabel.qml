import controls.BigText;

Item {
	property string text;
	anchors.top: safeArea.top;
	anchors.left: safeArea.left;
	anchors.right: safeArea.right;
	height: innerText.height;

	Gradient {
		height: 150;
		anchors.top: mainWindow.top;
		anchors.bottomMargin: -30;
		anchors.left: mainWindow.left;
		anchors.right: mainWindow.right;

		GradientStop {
			position: 0;
			color: "#000";
		}

		GradientStop {
			position: 1;
			color: "#0000";
		}
	}

	BigText {
		id: innerText;
		anchors.top: parent.top;
		anchors.horizontalCenter: parent.horizontalCenter;
		horizontalAlignment: HorizontalAlignment.AlignHCenter;
		text: parent.TopLabel.text;
		color: "#fff";
	}
}
