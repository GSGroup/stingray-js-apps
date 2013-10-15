TinyText: Text {
	color: colorTheme.activeTextColor;
	font: tinyFont;
}

SmallText: Text {
	color: colorTheme.activeTextColor;
	font: smallFont;
}

MainText: Text {
	color: colorTheme.activeTextColor;
	font: mainFont;
}

BigText: Text {
	color: colorTheme.activeTextColor;
	font: bigFont;
}

ShadowText : Text {
	color: colorTheme.activeTextColor;
	font: mainFont;

	style: Style.Shadow;
	styleColor: "#333";
}

Legend : Text {
	color: colorTheme.activeTextColor;
	style: Style.Sunken;
	font: mainFont;

	Rectangle {
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.bottom: parent.bottom;
		anchors.bottomMargin: -2;
		height: 1;
		color: "#999";
	}
}
