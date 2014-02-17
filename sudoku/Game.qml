import controls.Text

CellDelegate : Rectangle {
	id: cellItemDelegate;
	width: Math.floor(parent.width/9);
	height: Math.floor(parent.width/9);
	color: focused ? "#008888" : "#222200";
	borderColor: "#432100";
	borderWidth: 1;
	z: focused ? 50 : 0;
	BigText {
		id: subText;
		anchors.left: parent.left;
		anchors.right: parent.right;
		anchors.margins: 5;
		anchors.bottom: parent.bottom;
		horizontalAlignment: Text.AlignHCenter;
		verticalAlignment: Text.AlignVCenter;
		color: (model.isHidden==0) ? "#770000": "#FFFFFF";
		text: (model.isHidden==0) ? model.trueValue : model.userChoosedValue;
	}

}

GameFieldModel: ListModel {
	id: gameFieldModel;
	property int trueValue;
	property string userChoosedValue;
	property int isHidden;
	
	onCompleted: {
		for(var i = 0; i < 9; ++i){
			for(var j = 0; j < 9; ++j){
				this.append({'trueValue': Math.floor(Math.random()*5),  'isHidden' : Math.floor(Math.random()*2), 'userChoosedValue' : ""});
			}
		}
	}
}

DigitChooseModel : ListModel {
	onCompleted: {
		for(var i=1; i<10; ++i)
			this.append({digit : i});
	}
}

Game: Rectangle{

	ListView {
		id: digitChooser;
		visible: false;
		anchors.right: parent.left;
		anchors.top: parent.top;
		width: 50;
		height: 500;
		model: DigitChooseModel {}

		delegate: Rectangle {
			width: 50;
			height: 50;
			color: activeFocus ? "#5C656C" : "#fff" ;

			Text {
				font: bigFont;
				anchors.centerIn: parent;
				text: model.digit;
			}
		}

		onSelectPressed:{
			this.visible = false;
			log("ci = "+gameView.currentIndex);
			gameView.model.setProperty(gameView.currentIndex, 'userChoosedValue', currentIndex + 1);

		}
	}

	GridView {
		id: gameView;
		anchors.fill: parent;
		focus: true;
		cellWidth: width/9;
		cellHeight: height/9;

		model: GameFieldModel {}

		delegate: CellDelegate{} 

		onSelectPressed: {
			digitChooser.visible=true;
			digitChooser.setFocus();
		
		}
	}
}
