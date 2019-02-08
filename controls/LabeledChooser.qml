import Chooser;

ActivePanel {
	id: labeledChooserItem;
	property alias currentIndex: chooserItem.listView.currentIndex;
	property alias count: chooserItem.listView.count;
	property alias contentWidth: chooserItem.listView.contentWidth;
	property alias model: chooserItem.listView.model;
	property bool keyNavigationWraps: true;
	property string text;
	property int chooserWidth: 520; 
	width: textItem.width + chooserItem.width + 40;

	BodyText {
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
		anchors.rightMargin: 10;
		backgroundVisible: false;
		keyNavigationWraps: parent.keyNavigationWraps;
		chooserWidth: parent.chooserWidth;
	}
}
