import controls.MainText;

Rectangle {
	id: dialog;
	color: "#000000aa";
	property string title;

	borderColor: "#333";
	borderWidth: 1;
	width: 350;
	height: 250;
	radius: 8;
	visible: false;

	MainText {
		id: titleText;
		anchors.top: parent.top;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.margins: 5;
		anchors.topMargin: 10;
		horizontalAlignment: Text.AlignHCenter;
		text: dialog.title;
	}

	onBackPressed: {
		this.hide();
	}

	function show()	{
		this.visible = true;
		this.setFocus();
	}

	function hide()	{
		this.visible = false;
	}
}
