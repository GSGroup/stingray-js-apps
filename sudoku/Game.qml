import controls.Text
import "generator.js" as generator

CellDelegate : Rectangle {
	id: cellItemDelegate;
	width: Math.floor(parent.width/9);
	height: Math.floor(parent.width/9);
	color: focused ? "#008888" :(Math.floor((modelIndex%9)/3)+Math.floor(Math.floor(modelIndex/9)/3))%2==0?"#5E5E5E":"#AEAEAE" ;
	borderColor: "#D3D3D3";
	borderWidth: 1;
    /*Gradient {
            anchors.right: parent.right;
            anchors.left: parent.left;
            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            
            GradientStop {
                    position: 0;
                    color: (Math.floor((cellItemDelegate.modelIndex%9)/3)+Math.floor(Math.floor(cellItemDelegate.modelIndex/9)/3))%2==0?"#AFAFAF":"#EFEFEF";
            }
            
            GradientStop {
                    position: 1;
                    color: (Math.floor((cellItemDelegate.modelIndex%9)/3)+Math.floor(Math.floor(cellItemDelegate.modelIndex/9)/3))%2==0?"#5E5E5E":"#AEAEAE";
            }
    }*/


	BigText {
		id: subText;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.verticalCenter: parent.verticalCenter;
		anchors.margins: 5;
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

}

DigitChooseModel: ListModel {
	onCompleted: {
		for(var i=1; i<10; ++i)
			this.append({digit : i});
		this.append({digit : 'x'});
	}
}

Game: Rectangle {
	id: gameItem;
	event gameOverEvent(result);
    property bool isIncomplete: false;
    property string player;
    property string difficulty;

	BigText {
		id:timeIndicator;
		anchors.top: parent.top;
		anchors.left: parent.right;
		anchors.leftMargin: 20;
		property int sec: 0;
		text: Math.floor(sec/60)+":"+sec%60;

		Timer {
			id:timer;
			repeat: true;
			interval: 1000;
			onTriggered: {
				++timeIndicator.sec ;
		
			}
		}
	}

    BigText {
            id: difficultyIndicator;
            anchors.top: timeIndicator.bottom;
            anchors.left: parent.right;
            anchors.leftMargin: 20;
            text: parent.difficulty;
    }
	
/*	ListView {
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
			if (!gameItem.timeIndicator.timer.running) {gameItem.timeIndicator.timer.start();}
            else { log("TIMER IS RUNNING");}
			this.visible = false;
			gameView.model.setProperty(gameView.currentIndex, 'shownValue', (currentIndex<9)?currentIndex+1 : "");
			 			
			if (gameItem.isFilled()){
				gameItem.timeIndicator.timer.stop();
				var gameOverText = "YOU ";
				(!gameItem.fullStateCheck())?(gameOverText+="WIN!"):(gameOverText+="LOSE");
				gameItem.gameOverEvent(gameOverText);
			}
		}
	}*/

	GridView {
		id: digitChooser;
		visible: false;
		anchors.right: parent.left;
		anchors.top: parent.top;
        width: 51*3;
        height: 51*4;
		cellWidth: 51;
		cellHeight: 51;
//        opacity: 0.01;
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
			if (!gameItem.timeIndicator.timer.running) {gameItem.timeIndicator.timer.start();}
            else { log("TIMER IS RUNNING");}
//			this.opacity = 0.01;
            this.visible=false;
			gameView.model.setProperty(gameView.currentIndex, 'shownValue', (currentIndex<9)?currentIndex+1 : "");
			 			
			if (gameItem.isFilled()){
				gameItem.timeIndicator.timer.stop();
				var gameOverText = "YOU ";
				(!gameItem.fullStateCheck())?(gameOverText+="WIN!"):(gameOverText+="LOSE");
				gameItem.gameOverEvent(gameOverText);
			}
		}

		Behavior on opacity {
			animation: Animation {
				duration: 300;
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

			if (!gameView.model.get(gameView.currentIndex)['isBase']){
				digitChooser.visible=true;
//                digitChooser.opacity=1;
				digitChooser.setFocus();
			}
		}

		function fillModel(){
			var svMatrix = generator.getMatrix();
			var ibMatrix = generator.getHiddenMatrix();
			for(var i = 0; i < 9; ++i){
				for(var j = 0; j < 9; ++j){
					var tmpBase = ibMatrix[i][j];	
					this.model.append({'actualValue' : svMatrix[i][j], 'shownValue': (tmpBase?svMatrix[i][j]:""),'isBase' : tmpBase,'warnColor' : false});

				}
			}		
		}
	}

    function gameReset(){
        this.timeIndicator.timer.restart();
        this.timeIndicator.timer.stop();
        this.timeIndicator.sec = 0;
        this.gameView.model.reset();
        this.gameView.fillModel();
    }

	function isFilled(){
		var ctr=0;
		for(var i =0;i<9*9; ++i)
			if (gameView.model.get(i)['shownValue']==="") ++ctr;
		return ctr==0;
	}

	function fullStateCheck(){
		var errors = false;
		var tmpBool = false;
		//log("full state check");
		for(var i=0; i<3; ++i){
			for(var j=0;j<3; ++j){
				tmpBool = this.checkSquare(i*3+j*3*9);
				errors = errors || tmpBool;
			}
		}

		for(var i=0; i<9; ++i){
			tmpBool = this.checkRow(i*9);
			errors = errors || tmpBool;
			tmpBool = this.checkColumn(i);
			errors = errors || tmpBool;
		}

		return errors;
	}

	function checkRow(index) {
		//log("check row")
		this.row = Math.floor(index/9);
		this.tmpArray=[];
		for(var i = this.row*9; i<this.row*9+9; ++i){
			this.tmpV = gameView.model.get(i)['shownValue'];
			if (this.tmpArray.indexOf(this.tmpV)==-1){
				this.tmpArray.push(this.tmpV);
			}
			else if  (this.tmpV!=""){
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
			if (this.tmpArray.indexOf(this.tmpV)==-1){
				this.tmpArray.push(this.tmpV);
			}
			else if  (this.tmpV!=""){
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
				if (this.tmpArray.indexOf(this.tmpV)==-1 ){
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
			gameView.model.setProperty(i,'warnColor', isHL==true); // 
			//log("i = "+i+" isHL = "+isHL);

		}
	}

	function highlightColumn(isHL, index) {
		this.column = index%9;
		//log("HIGHLIGHT COLUMN "+this.column+" "+isHL);
		for(var i = this.column; i < 9*9; i+=9){
			//log("i = "+i+" isHL = "+isHL);
			gameView.model.get(i)['warnColor'];
			gameView.model.setProperty(i,'warnColor', isHL==true); //
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
