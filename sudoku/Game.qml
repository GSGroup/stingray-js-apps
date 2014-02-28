import controls.Text
import "generator.js" as generator

CellDelegate : Rectangle {
	id: cellItemDelegate;
	width: Math.floor(parent.width/9);
	height: Math.floor(parent.width/9);
	color: focused ? "#008888" :(Math.floor((modelIndex%9)/3)+Math.floor(Math.floor(modelIndex/9)/3))%2==0?"#5E5E5E":"#AEAEAE" ;
	borderColor: "#D3D3D3";
	borderWidth: 1;


	BigText {
		id: subText;
    	anchors.horizontalCenter: parent.horizontalCenter;
    	anchors.verticalCenter: parent.verticalCenter;
		anchors.margins: 5;
		horizontalAlignment: Text.AlignHCenter;
		verticalAlignment: Text.AlignVCenter;
		color: model.isBase? "#000000": "#FFFFFF"; 
		text:  model.shownValue;
	}

    SmallText {
        id: hint1;
        anchors.top: parent.top;
        anchors.left: parent.left;
        width: parent.width/15;
        height: parent.height/15;
        anchors.leftMargin:5;
        anchors.topMargin:2;
		color: "#393939";
        text:  model.isBase?"":(model.shownValue===""?(model.isHint1?"1":"  " ):"")+"   "+
			  (model.isBase?"":(model.shownValue===""?(model.isHint2?"2":"   "):""))+"  "+
			  (model.isBase?"":(model.shownValue===""?(model.isHint3?"3":"   "):""))+"\n"+
			  (model.isBase?"":(model.shownValue===""?(model.isHint4?"4":"   "):""))+"  "+
			  (model.isBase?"":(model.shownValue===""?(model.isHint5?"5":"   "):""))+"  "+
			  (model.isBase?"":(model.shownValue===""?(model.isHint6?"6":"   "):""))+"\n"+
			  (model.isBase?"":(model.shownValue===""?(model.isHint7?"7":"   "):""))+"  "+
			  (model.isBase?"":(model.shownValue===""?(model.isHint8?"8":"   "):""))+"  "+
			  (model.isBase?"":(model.shownValue===""?(model.isHint9?"9":"   "):""));
    }

	Behavior on color {
	    animation: Animation {
		    duration: 300;
		}
	}

}

GameFieldModel: ListModel {
	id: gameFieldModel;
	property int shownValue;
	property int actualValue;
	property bool isBase;
    property bool isHint1;
    property bool isHint2;
    property bool isHint3;
    property bool isHint4;
    property bool isHint5;
    property bool isHint6;
    property bool isHint7;
    property bool isHint8;
    property bool isHint9;
}

DigitChooseModel: ListModel {
	onCompleted: {
		for(var i=1; i<10; ++i)
			this.append({digit : i});
//		this.append({digit : 'x'});
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
		anchors.right: parent.left;
		anchors.top: parent.top;
        width: 51*3;
        height: 51*4;
		cellWidth: 51;
		cellHeight: 51;
        opacity: 0.01;
		model: DigitChooseModel {}

		delegate: Rectangle {
			width: 50;
			height: 50;
			color: activeFocus ? "#5C656C" : "#fff" ;

			Text {
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.verticalCenter: parent.verticalCenter;
				font: smallFont;
				text: model.digit;
			}
            
            Behavior on color {
			    animation: Animation {
				     duration: 300;
			    }
		    }
		}

		onSelectPressed:{
			this.opacity = 0.01;
            gameView.setFocus(); 
			gameView.model.setProperty(gameView.currentIndex, 'isHint'+(currentIndex+1), !(gameView.model.get(gameView.currentIndex)['isHint'+(currentIndex+1)]));
		}

        onBackPressed: {
            this.opacity = 0.01;
            gameView.setFocus();
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
                digitChooser.opacity=1;
				digitChooser.setFocus();
			}
		}

		onKeyPressed: {
			var rgx = new RegExp("^[0-9]$");
			if(rgx.test(key)){
				parent.setShownValue(gameView.currentIndex,parseInt(key));
//				gameView.model.setProperty(gameView.currentIndex, 'shownValue', key);
				if (!gameItem.timeIndicator.timer.running) {gameItem.timeIndicator.timer.start();}
            	else { log("TIMER IS RUNNING");}
/*				parent.hintRow(gameView.currentIndex);
				parent.hintColumn(gameView.currentIndex); 			
				parent.hintSquare(gameView.currentIndex);*/
//		    		parent.reSetHints();
				if (gameItem.isFilled()){
				   gameItem.timeIndicator.timer.stop();
				   var gameOverText = "YOU ";
				   (!gameItem.fullStateCheck())?(gameOverText+="WIN!"):(gameOverText+="LOSE");
				   gameItem.gameOverEvent(gameOverText);
				}
			}
			
		}

		function fillModel(hintsBool){
			var svMatrix = generator.getMatrix();
			var ibMatrix = generator.getHiddenMatrix();
			for(var i = 0; i < 9; ++i){
				for(var j = 0; j < 9; ++j){
					var tmpBase = ibMatrix[i][j];	
					this.model.append({'actualValue' : svMatrix[i][j], 
                            'shownValue': (tmpBase?svMatrix[i][j]:""),
                            'isBase' : tmpBase,
                            'isHint1' : hintsBool,
                            'isHint2' : hintsBool,
                            'isHint3' : hintsBool,
                            'isHint4' : hintsBool,
                            'isHint5' : hintsBool,
                            'isHint6' : hintsBool,
                            'isHint7' : hintsBool,
                            'isHint8' : hintsBool,
                            'isHint9' : hintsBool
                    });
				}
			}		
		}
	}

    function gameReset(difficulty){
        this.timeIndicator.timer.restart();
        this.timeIndicator.timer.stop();
        this.timeIndicator.sec = 0;
        this.gameView.model.reset();
        this.gameView.fillModel(difficulty=="easy");
		if(difficulty=="easy") this.setHints();
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
/*
	function setHints(){
		var count =0;
		for(var i=0;i<3;++i){
			for(var j=0;j<3; ++j){
				this.hintSquare(i*3+j*3*9);
				this.hintRow(count);
				this.hintColumn(count);
				count+=10; //diagonal
			}
		}

//		this.reSetHints();
	}
*/
    function hintRow(index){

		var row = Math.floor(index/9);
		var tmpV = 0;

		
/*
		var tmpSVArray = [];
		
		for(var i = row*9; i<row*9+9; ++i){
			tmpV = gameView.model.get(i).shownValue;
			if(tmpV!=""){
				tmpSVArray.push(tmpV.toString());
			}
		}

		log("HINT ROW "+tmpSVArray);		
		for(var i = row*9;i<row*9+9; ++i){
				for(var num = 1; num<10;++num){
					log("num = "+num.toString()+" "+(tmpSVArray.indexOf(num.toString())==-1));
					gameView.model.setProperty(i,'isHint'+num.toString(), tmpSVArray.indexOf(num.toString())==-1);
			}			
		}*/


		/*last
		for(var i = row*9; i<row*9+9;++i){
			tmpV = gameView.model.get(i)['shownValue'];
			if(tmpV!=""){
				for( var j = row*9; j<row*9+9; ++j){
					 log(" set prprt isHint"+tmpV.toString()+" to "+j.toString()+" false");
					 gameView.model.setProperty(j,'isHint'+tmpV.toString(), false);
				}
			}
		}*/
    }


	function hintColumn(index){
		var column = index%9;
		var tmpV = 0;
/*
		var tmpSVArray = [];
		
		for(var i = column; i<9*9; i+=9){
			tmpV = gameView.model.get(i).shownValue;
			if(tmpV!=""){
				tmpSVArray.push(tmpV.toString());
			}
		}

		log("HINT ROW "+tmpSVArray);		
		for(var i = columnt;i<9*9; i+=9){
				for(var num = 1; num<10;++num){
					log("num = "+num.toString()+" "+(tmpSVArray.indexOf(num.toString())==-1));
					gameView.model.setProperty(i,'isHint'+num.toString(), tmpSVArray.indexOf(num.toString())==-1);
			}			
		}
*/

		
		for(var i = column; i < 9*9; i+=9){
			tmpV = gameView.model.get(i)['shownValue'];
			if(tmpV!=""){
				for(var j = column; j<9*9; j+=9){
					gameView.model.setProperty(j,'isHint'+tmpV.toString(), false);						
				}
			}
		}
	}

	function hintSquare(index){
		var hSector = Math.floor((index % 9)/3);
		var vSector = Math.floor(Math.floor(index/9)/3);
		var tmpV =0;
		for(var j = vSector*3*9; j<vSector*3*9+3*9; j+=9){
			for(var i = hSector*3; i <hSector*3+3 ; ++i){
				tmpV = gameView.model.get(i+j)['shownValue'];	
				if(tmpV!=""){
					for(var m = vSector*3*9; m<vSector*3*9+3*9; m+=9){
						for(var n = hSector*3; n <hSector*3+3 ; ++n){
							gameView.model.setProperty(m+n,'isHint'+tmpV.toString(),false);
						}
					}
				}
			}
		}
	}


    function setHints(){
    	 log("RESET HINTS");
		 var sctrArray=[[[],[],[]],[[],[],[]],[[],[],[]]];
		 var clmnArray=[[],[],[],[],[],[],[],[],[]];
		 var rwArray=[[],[],[],[],[],[],[],[],[]];
		 var tmpV;
		 for(var vSector=0;vSector<3;++vSector){
	     	 for(var hSector=0;hSector<3;++hSector){
				 for(var j = vSector*3*9; j<vSector*3*9+3*9; j+=9){
		    	 	for(var i = hSector*3; i <hSector*3+3 ; ++i){
						tmpV = this.gameView.model.get(i+j).shownValue;	
						log("tmpV = "+tmpV+" row = " +hSector+" column "+vSector);
						if(tmpV!=""){
								sctrArray[hSector][vSector].push(tmpV);
						}
		    		}
				}
	    	}
		}

		for (var i = 0;i < 9; ++i){
	    	for(var c = i; c<9*9; c+=9){
				tmpV = this.gameView.model.get(c).shownValue;
				if(tmpV!=""){
					clmnArray[i].push(tmpV);
				}
	    	}
		
		
			for(var r = i*9; r<i*9+9;++r){
				tmpV = this.gameView.model.get(r).shownValue;
				if(tmpV!=""){
					rwArray[i].push(tmpV);
				}
	    	}
		}
		var lColumn, lRow, lVSector, lHSector;
	
		for(var i = 0 ; i<81;++i){		
	    	lColumn  = i % 9;
	    	lRow     = Math.floor(i/9);
	    	lVSector = Math.floor(Math.floor(i/9)/3);
	    	lHSector = Math.floor((i % 9)/3);
	    	var allBool;
	    	for(var num =1; num<10;++num){
				allBool = (sctrArray[lHSector][lVSector].indexOf(num)==-1) &&  (clmnArray[lColumn].indexOf(num)==-1) && (rwArray[lRow].indexOf(num)==-1);
				log("i = "+i.toString()+" num = "+num.toString()+" allBool = "+allBool);
				this.gameView.model.setProperty(i,'isHint'+num.toString(),allBool);
	    	}
		}
    }

	function setShownValue(index, number){
		log("UPDATE HINTS")
		var column  = index % 9;
		var row     = Math.floor(index/9);
		var vSector = Math.floor(Math.floor(index/9)/3);
		var hSector = Math.floor((index%9)/3);
		var previousValue = this.gameView.model.get(index).shownValue;
		if(number==0){
			this.gameView.model.setProperty(index,'shownValue',"");
			for(var i=row*9;i<row*9+9;++i){
					this.gameView.model.setProperty(i,'isHint'+previousValue.toString(),true);					
			}

			for(var i=column; i<9*9; i+=9){
					this.gameView.model.setProperty(i,'isHint'+previousValue.toString(),true);
			}
			
			for(var j = vSector*3*9; j<vSector*3*9+3*9; j+=9){
		     	for(var i = hSector*3; i <hSector*3+3 ; ++i){
					this.gameView.model.setProperty(i+j,'isHint'+previousValue.toString(),true);
		    	}
			}
		}
		else{
			this.gameView.model.setProperty(index,'shownValue',number);
			for(var i=row*9;i<row*9+9;++i){
					this.gameView.model.setProperty(i,'isHint'+number.toString(),false);					
			}

			for(var i=column; i<9*9; i+=9){
					this.gameView.model.setProperty(i,'isHint'+number.toString(),false);
			}
			
			for(var j = vSector*3*9; j<vSector*3*9+3*9; j+=9){
		     	for(var i = hSector*3; i <hSector*3+3 ; ++i){
					this.gameView.model.setProperty(i+j,'isHint'+number.toString(),false);
		    	}
			}
			
		}
				
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

	
/*
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

//			var row = gameView.model.get(i);
//			row.warnColor = isHL;
//			gameView.model.set(i,row);
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
	}*/
}
