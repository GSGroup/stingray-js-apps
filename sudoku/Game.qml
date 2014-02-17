
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
		text: parent.activeFocus?model.trueValue:"";
	}
}

ListModel {
	id: gameFieldModel;
	property int trueValue: 0;
	property int choosedValue: 0;
	property bool isResolved: false;
	
}


Game: GridView {
	id: gameView;
	focus: true;
	cellWidth: width/9;
	cellHeight: height/9;
	model: gameFieldModel;

	delegate: CellDelegate{} 

	function generate(){
		for(var i = 0; i < 9*9; ++i){
			gameView.model.append({'trueValue': Math.floor(Math.random()*5)});
		}
	
	}


}


