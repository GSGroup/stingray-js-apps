/*Panel : Rectangle {
	color: colorTheme.backgroundColor;
	borderColor: colorTheme.borderColor;
	borderWidth: 2;
	radius: colorTheme.rounded ? 12 : 0;
	focus: false;
}*/

Panel : Rectangle {
//	borderColor: "#255264";
//	borderWidth: 1;
	focus: false;
	
	Gradient {
		anchors.fill: parent;
		anchors.margins: 1;

		orientation: Vertical;
		GradientStop {position: 0; color: "#2d3640"; }
		GradientStop {position: 1; color: "#212930"; }

		Behavior on opacity { animation: Animation { duration: 300; } }
	}
}
