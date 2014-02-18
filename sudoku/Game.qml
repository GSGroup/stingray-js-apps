import controls.Text
import "generator.js" as generator

CellDelegate : Rectangle {
	id: cellItemDelegate;
	width: Math.floor(parent.width/9);
	height: Math.floor(parent.width/9);
	color: focused ? "#008888" : (model.warnColor?"#555500":"#222200");
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
		color: model.isBase? "#770000": "#FFFFFF";
		text:  model.shownValue;
	}

}

GameFieldModel: ListModel {
	id: gameFieldModel;
	property int shownValue;
	property bool isBase;
	property bool warnColor;

	onCompleted: {
		var svMatrix = generator.getMatrix();
		var ibMatrix = generator.getHiddenMatrix();
		log(svMatrix);
		log("#################################");
		log(ibMatrix)
		for(var i = 0; i < 9; ++i){
			for(var j = 0; j < 9; ++j){
//				var tmpBase = (Math.floor(Math.random()*2)==0)?false:true;
//				this.append({'shownValue':(tmpBase?Math.floor(Math.random()*9)+1:""),'isBase' : ibMatrix[i][j],'warnColor' : false});
				var tmpBase = ibMatrix[i][j];	
				this.append({'shownValue': (tmpBase?svMatrix[i][j]:""),'isBase' : tmpBase,'warnColor' : false});

			}
		}
	}
}

DigitChooseModel : ListModel {
	onCompleted: {
		for(var i=1; i<10; ++i)
			this.append({digit : i});
		this.append({digit : 'x'});
	}
}

Game: Rectangle{
	id: gameItem;

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
			gameView.model.setProperty(gameView.currentIndex, 'shownValue', (currentIndex<9)?currentIndex+1 : "");
			if(currentIndex<9)
				gameItem.stateCheck();
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
			if(!gameView.model.get(gameView.currentIndex)['isBase']){
				digitChooser.visible=true;
				digitChooser.setFocus();
			}
		}
	}

	function stateCheck() {
		log("STATE CHECK");
		log("gridview current index = "+gameView.currentIndex);
		if(this.checkRow(gameView.currentIndex)){
			this.highlightRow(true,gameView.currentIndex);
		}
		if(this.checkColumn(gameView.currentIndex)){
			this.highlightColumn(true,gameView.currentIndex);
		}
		if(this.checkSquare(gameView.currentIndex)){
			this.highlightSquare(true,gameView.currentIndex);
		}
	}

	function fullStateCheck()
	{
		for(var i=0; i<9; ++i){
			this.highlightRow(this.checkRow(i*9),i*9);
			this.highlightColumn(this.checkColumn(i),i);
			this.highlightSquare(this.checkSquare(i),);//not forget!!!
		}
	}

	function checkRow(index) {
		log("check row")
		this.row = Math.floor(index/9);
		this.tmpArray=[];
		for(var i = this.row*9; i<this.row*9+9; ++i){
			this.tmpV = gameView.model.get(i)['shownValue'];
			if(this.tmpArray.indexOf(this.tmpV)==-1){
				this.tmpArray.push(this.tmpV);
			}
			else if (this.tmpV!=""){
				return true;
			}
		}
		log("false "+this.tmpArray);
		return false;
	}
	
	function checkColumn(index) {
		log("check column")
		this.column = index%9;
		this.tmpArray=[];
		for(var i = this.column; i < 9*9; i+=9){
			this.tmpV = gameView.model.get(i)['shownValue'];
			if(this.tmpArray.indexOf(this.tmpV)==-1){
				this.tmpArray.push(this.tmpV);
			}
			else if (this.tmpV!=""){
				return true;
			}
		}
		log("false "+this.tmpArray);
		return false;
	}

	function checkSquare(index) {
		log("check square")
		this.hSector = Math.floor((index % 9)/3);
		this.vSector = Math.floor(Math.floor(index/9)/3);
		this.tmpArray = [];
		for(var j = this.vSector*3*9; j<this.vSector*3*9+3*9; j+=9){
			for(var i = this.hSector*3; i <this.hSector*3+3 ; ++i){
				this.tmpV=gameView.model.get(i+j)['shownValue'];
				if(this.tmpArray.indexOf(this.tmpV)==-1 ){
					this.tmpArray.push(this.tmpV);
				}
				else if (this.tmpV!=""){
					return true;
				}
			}
		}
		log("false "+this.tmpArray);
		return false;
	}

	function highlightRow(isHL, index) {
		this.row = Math.floor(index/9);
		for(var i =this.row*9; i<this.row*9+9; ++i){
			gameView.model.setProperty(i,'warnColor', isHL);
		}
	}

	function highlightColumn(isHL, index) {
		this.column = index%9;
		for(var i = this.column; i < 9*9; i+=9){
			gameView.model.setProperty(i,'warnColor', isHL);
		}
	}

	function highlightSquare(isHL,index) {
		this.hSector = Math.floor((index % 9)/3);
		this.vSector = Math.floor(Math.floor(index/9)/3);
		for(var j = this.vSector*3*9; j<this.vSector*3*9+3*9; j+=9){
			for(var i = this.hSector*3; i <this.hSector*3+3 ; ++i){
				gameView.model.setProperty(i+j,'warnColor',isHL);
			}
		}
	}


}
