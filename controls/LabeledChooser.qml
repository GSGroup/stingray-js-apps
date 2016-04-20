import Chooser

ActivePanel {
	id: labeledChooserItem;
	property string text;
	property int chooserWidth: 520; 
	width: textItem.width + chooserItem.width + 40;

	SmallText {
		id: textItem;
		text: parent.text;
		anchors.left: parent.left;
		anchors.leftMargin: 20;
		anchors.verticalCenter: parent.verticalCenter;
		color: parent.activeFocus ? colorTheme.focusedTextColor : colorTheme.textColor;

		Behavior on color { animation: Animation { duration: 300; } }
	}
	
	Chooser {
		id: chooserItem;
		anchors.right: parent.right;
		chooserWidth: parent.chooserWidth;
	}
	
	function append(text, icon) { chooserItem.append(text, icon); }
}
