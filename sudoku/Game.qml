
CellDelegate : Rectangle {
	id: cellItem;
	width: Math.floor(parent.width/9);
	height: Math.floor(parent.width/9);
	color: activeFocus ? "#008888" : "#222200";
	borderColor: "#432100";
	borderWidth: 1;
	SmallText {
		id: subText;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.margins: 5;
		anchors.bottom: parent.bottom;
		horizontalAlignment: Text.AlignHCenter;
		color: stationDelegateItem.activeFocus ? "#fff" : "#bbb";
		text: "T";//model.name;

		Behavior on color {
			animation: Animation {
				duration: 300;
			}
		}
	}
}


Game: GridView {
	id: gameView;
	focus: true;
	cellWidth: width/9;
	cellHeight: height/9;

	model: ListModel{
	ListElement {} ListElement {} ListElement {} ListElement {}	ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} 
	ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} 
	ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} 
	ListElement {} ListElement {} ListElement {} ListElement {}	ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} 
	ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} 
	ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} 
	ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} 
	ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} 
	ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} ListElement {} 
	}

	delegate: CellDelegate{} 

}


