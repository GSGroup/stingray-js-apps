import controls.Text
import "generator.js" as generator

CellDelegate : Rectangle {
	id: cellItemDelegate;
	width: Math.floor(parent.width/9);
	height: Math.floor(parent.width/9);
	color: focused ? "#008888" :(Math.floor((modelIndex%9)/3)+Math.floor(Math.floor(modelIndex/9)/3))%2==0?"#D2B42A":"#D2B46C" ;
	borderColor: "#D3D3D3";
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
		color: model.isBase? "#000000": "#FFFFFF"; //(model.warnColor?"#A52A2A":"#FFFFFF");
		text:  model.shownValue;
	}

}

GameFieldModel: ListModel {
	id: gameFieldModel;
	property int shownValue;
	property int actualValue;
	property bool isBase;
	property bool warnColor;

	onCompleted: {
		var svMatrix = generator.getMatrix();
		var ibMatrix = generator.getHiddenMatrix();
		for(var i = 0; i < 9; ++i){
			for(var j = 0; j < 9; ++j){
//				var tmpBase = (Math.floor(Math.random()*2)==0)?false:true;
//				this.append({'shownValue':(tmpBase?Math.floor(Math.random()*9)+1:""),'isBase' : ibMatrix[i][j],'warnColor' : false});
				var tmpBase = ibMatrix[i][j];	
				this.append({'actualValue' : svMatrix[i][j], 'shownValue': (tmpBase?svMatrix[i][j]:""),'isBase' : tmpBase,'warnColor' : false});

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
	event gameOverEvent(result);
	BigText{
		id:timeIndicator;
		anchors.top: parent.top;
		anchors.left: parent.right;
		property int sec: 0;
		text: Math.floor(sec/60)+":"+sec%60;

		Timer {
			id:timer1;
			repeat: true;
			interval: 1000;
			onTriggered: {
				++timeIndicator.sec ;
		
			}
		}
	}
	
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
			if(!gameItem.timeIndicator.timer1.running) gameItem.timeIndicator.timer1.start();
			this.visible = false;
			gameView.model.setProperty(gameView.currentIndex, 'shownValue', (currentIndex<9)?currentIndex+1 : "");
			var hasErrors = gameItem.fullStateCheck();
			if(gameItem.isFilled()){
				gameItem.timeIndicator.timer1.stop();
				var gameOverText = "YOU ";
				(!hasErrors)?(gameOverText+="WIN!"):(gameOverText+="LOSE");
				gameItem.gameOverEvent(gameOverText);
			}
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



/*
	function stateCheck() {
		//log("STATE CHECK");
		var checkBool = this.checkSquare(gameView.currentIndex) || this.checkRow(gameView.currentIndex) || this.checkColumn(gameView.currentIndex);
		gameView.model.setProperty(gameView.currentIndex,'warnColor',checkBool);
	}

	function isSolved()	{
		for(var i=0;i<gameView.model.count; ++i){
			if(gameView.model.get(i)['shownValue']!=gameView.model.get(i)['actualValue'])
				return false;
		}
		return true;
	}
*/


	function isFilled(){
		var ctr=0;
		for(var i =0;i<9*9; ++i)
			if(gameView.model.get(i)['shownValue']==="") ++ctr;
		return ctr==0;
	}

	function stateCheck() {
		//log("STATE CHECK");
		for(var i=0;i<9;++i){
			this.highlightColumn(this.checkColumn(i),i);
		}
		for(var i=0;i<9;++i){
			this.highlightRow(this.checkRow(i*9),i*9);
		}

		for(var i=0; i<3; ++i){
			for(var j=0;j<3; ++j){
				this.highlightSquare(this.checkSquare(i*3+j*3*9),i*3+j*3*9);
			}
		}
	}

	function fullStateCheck()
	{
		var errors = false;
		var tmpBool = false;
		//log("full state check");
		for(var i=0; i<3; ++i){
			for(var j=0;j<3; ++j){
				tmpBool = this.checkSquare(i*3+j*3*9);
				errors = errors || tmpBool;
				//this.highlightSquare(tmpBool,i*3+j*3*9);
			}
		}

		for(var i=0; i<9; ++i){
			tmpBool = this.checkRow(i*9);
			errors = errors || tmpBool;
			//this.highlightRow(tmpBool,i*9);
			tmpBool = this.checkColumn(i);
			errors = errors || tmpBool;
			//this.highlightColumn(tmpBool,i);
		}

		return errors;
	}

	function checkRow(index) {
		//log("check row")
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
		//log("false "+this.tmpArray);
		return false;
	}
	
	function checkColumn(index) {
		//log("check column")
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
		//log("false "+this.tmpArray);
		return false;
	}

	function checkSquare(index) {
		//log("check square")
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
		//log("false "+this.tmpArray);
		return false;
	}

	function highlightRow(isHL, index) {
		this.row = Math.floor(index/9);
		//log("HIGHLIGHT ROW "+this.row+" "+isHL);
		for(var i =this.row*9; i<this.row*9+9; ++i){
			//log("i = "+i+" isHL = "+isHL);
			gameView.model.get(i)['warnColor'];
			gameView.model.setProperty(i,'warnColor', isHL==true); //|| gameView.model.get(i)['warnColor']);
			//log("i = "+i+" isHL = "+isHL);

		}
	}

	function highlightColumn(isHL, index) {
		this.column = index%9;
		//log("HIGHLIGHT COLUMN "+this.column+" "+isHL);
		for(var i = this.column; i < 9*9; i+=9){
			//log("i = "+i+" isHL = "+isHL);
			gameView.model.get(i)['warnColor'];
			gameView.model.setProperty(i,'warnColor', isHL==true); // || gameView.model.get(i)['warnColor']);
			//log("i = "+i+" isHL = "+isHL);

/*			var row = gameView.model.get(i);
			row.warnColor = isHL;
			gameView.model.set(i,row);*/
		}
	}

	function highlightSquare(isHL,index) {
		this.hSector = Math.floor((index % 9)/3);
		this.vSector = Math.floor(Math.floor(index/9)/3);
		for(var j = this.vSector*3*9; j<this.vSector*3*9+3*9; j+=9){
			for(var i = this.hSector*3; i <this.hSector*3+3 ; ++i){
				//log("i = "+i+" isHL = "+isHL);
				gameView.model.setProperty(i+j,'warnColor',isHL ); 
				//log("i = "+i+" isHL = "+isHL);
			}
		}
	}


}
