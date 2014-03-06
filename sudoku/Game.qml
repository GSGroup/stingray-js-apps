import controls.Text
import "generator.js" as generator

CellDelegate : Rectangle {
	id: cellItemDelegate;
	width: Math.floor(parent.width/9);
	height: Math.floor(parent.width/9);
	color: focused ? "#008888" :"#00000000";

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

    Text {
        id: hint1;
		anchors.horizontalCenter:parent.horizontalCenter;
		anchors.verticalCenter: parent.verticalCenter;

        anchors.leftMargin:5;
        anchors.topMargin:12;
		color: "#393939";
		font: Font {
			  family: "Proxima Nova Condensed";
			  pixelSize:20;
		}
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
		this.append({digit : 'x'});
	}
}

HintDigitChooseModel: ListModel {
	onCompleted: {
		for(var i=1; i<10; ++i)
			this.append({digit : i});
	}
}


Game: Rectangle {
	id: gameItem;
	event gameOverEvent(result);
    property bool isIncomplete: false;
    property string player;
    property string difficulty;
	property int diffInt;

	Image {
		 id: mainGameTheme;
		 anchors.horizontalCenter: safeArea.horizontalCenter;
		 anchors.verticalCenter: safeArea.verticalCenter;
		 source: "apps/sudoku/img/ground_game.png";
	}


    BigText {
            id: difficultyIndicator;
            anchors.top: parent.top;
			anchors.topMargin: 37;
			anchors.horizontalCenter: difficultyHeader.horizontalCenter;
            text: parent.difficulty;
    }

	BigText {
			id:difficultyHeader;
			anchors.bottom: difficultyIndicator.top;
			anchors.bottomMargin: 30;
			anchors.right: parent.right;
			anchors.rightMargin: 95;
			anchors.horizontalCenter: difficultyIndicator.horizontalCenter;
			text:"level:";
	}

	BigText {
		id:timeIndicator;
		anchors.top: difficultyIndicator.bottom;
		anchors.topMargin: 93;
		anchors.horizontalCenter: difficultyIndicator.horizontalCenter;
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
			anchors.bottom: timeIndicator.top;
			anchors.bottomMargin: 30;
			anchors.horizontalCenter: difficultyIndicator.horizontalCenter;
			text:"time:"
	}

	
	ListView {
		id: digitChooser;
		opacity: 0.01;
		anchors.right: gameView.left;
		anchors.top: gameView.top;
		width: 50;
		height: 500;
		model: DigitChooseModel {}

		delegate: Rectangle {
			width: 50;
			height: 50;
			color: activeFocus ? colorTheme.activeBorderColor : colorTheme.backgroundColor;
			borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
			borderWidth: 2;
//			color: activeFocus ? "#5C656C" : "#00000088" ;

			Text {
				font: bigFont;
				color: "#FFFFFF";
				anchors.centerIn: parent;
				text: model.digit;
			}

            Behavior on color {
			    animation: Animation {
				     duration: 300;
			    }
		    }

		}

		onSelectPressed:{
			if (!gameItem.timeIndicator.timer.running) {gameItem.timeIndicator.timer.start();}
            else { log("TIMER IS RUNNING");}
			parent.setShownValue(gameView.currentIndex,(currentIndex<9)?currentIndex+1:0);			 			
			if (gameItem.isFilled()){
				gameItem.timeIndicator.timer.stop();
				var gameOverText = "YOU ";
				(!gameItem.fullStateCheck())?(gameOverText+="WIN!"):(gameOverText+="LOSE");
				gameItem.gameOverEvent(gameOverText);
			}
			this.opacity=0.01;
			hintDigitChooser.opacity=0.01;
			gameView.setFocus();
		}

        onBackPressed: {
            this.opacity = 0.01;
			hintDigitChooser.opacity = 0.01;
            gameView.setFocus();
        }

		onLeftPressed: {
			hintDigitChooser.setFocus();
		}

		Behavior on opacity {
			animation: Animation {
				duration: 300;
			}
		}

	}

	ListView {
		id: hintDigitChooser;
		anchors.right: digitChooser.left;
		anchors.top: digitChooser.top;
		width: 50;
		height: 500;
		opacity: 0.01;

		model: HintDigitChooseModel {}

		delegate: Rectangle {
			width: 50;
			height: 50;
			color: activeFocus ? colorTheme.activeBorderColor : colorTheme.backgroundColor;
			borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
			borderWidth: 2;

//			color: activeFocus ? "#5C656C" : "#00000088" ;

			Text {
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.verticalCenter: parent.verticalCenter;
				font: smallFont;
				color: parent.activeFocus ? colorTheme.activeTextColor : colorTheme.textColor;
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
			digitChooser.opacity =0.01;
            gameView.setFocus(); 
			gameView.model.setProperty(gameView.currentIndex, 'isHint'+(currentIndex+1), !(gameView.model.get(gameView.currentIndex)['isHint'+(currentIndex+1)]));
		}

        onBackPressed: {
            this.opacity = 0.01;
			digitChooser.opacity = 0.01;
            gameView.setFocus();
        }

		onRightPressed:{
			digitChooser.setFocus()
		}

		Behavior on opacity {
			animation: Animation {
				duration: 300;
			}
		}
	}


	GridView {
		id: gameView;
		anchors.horizontalCenter: mainGameTheme.horizontalCenter;
		anchors.verticalCenter: mainGameTheme.verticalCenter;
		focus: true;
		height: mainGameTheme.height-142;
		width: mainGameTheme.height-142;
		cellWidth: width/9;
		cellHeight: height/9;
		model: GameFieldModel {}

		delegate: CellDelegate{} 

		onSelectPressed: {

			if (!gameView.model.get(gameView.currentIndex)['isBase']){
                digitChooser.opacity=0.8;
				hintDigitChooser.opacity=0.8;
				digitChooser.setFocus();
			}
		}

		onKeyPressed: {
			var rgx = new RegExp("^[0-9]$");
			if(rgx.test(key) && !gameView.model.get(gameView.currentIndex).isBase){
				var start = new Date().getTime();
				parent.setShownValue(gameView.currentIndex,parseInt(key));
				var end   = new Date().getTime();
				log("PROFILE TIME: = "+(end - start)+" key = "+key);
				if (!gameItem.timeIndicator.timer.running) gameItem.timeIndicator.timer.start();
            	else { log("TIMER IS RUNNING");}
				if (gameItem.isFilled()){
				   gameItem.timeIndicator.timer.stop();
				   gameItem.gameOverEvent(!gameItem.fullStateCheck());
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

    function gameReset(){
        this.timeIndicator.timer.restart();
        this.timeIndicator.timer.stop();
        this.timeIndicator.sec = 0;
        this.gameView.model.reset();
        this.gameView.fillModel(this.diffInt==1);
		if(this.diffInt==1) this.setHints();
		log("DIFFINT = "+this.diffInt)
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


    function setHints(){
    	 log("SET HINTS");
		 var sctrArray=[[[],[],[]],[[],[],[]],[[],[],[]]];
		 var clmnArray=[[],[],[],[],[],[],[],[],[]];
		 var rwArray=[[],[],[],[],[],[],[],[],[]];
		 var tmpV;
		 for(var vSector=0;vSector<3;++vSector){
	     	 for(var hSector=0;hSector<3;++hSector){
				 for(var j = vSector*3*9; j<vSector*3*9+3*9; j+=9){
		    	 	for(var i = hSector*3; i <hSector*3+3 ; ++i){
						tmpV = this.gameView.model.get(i+j).shownValue;	
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
				this.gameView.model.setProperty(i,'isHint'+num.toString(),allBool);
	    	}
		}
    }

	function reSetHints(index){
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
			
		for(var i = index%9 ; i<9*9;i+=9){		
		   	lColumn  = i % 9;
	    	lRow     = Math.floor(i/9);
	    	lVSector = Math.floor(Math.floor(i/9)/3);
	    	lHSector = Math.floor((i % 9)/3);
		   	var allBool;
		   	for(var num =1; num<10;++num){
				allBool = (sctrArray[lHSector][lVSector].indexOf(num)==-1) &&  (clmnArray[lColumn].indexOf(num)==-1) && (rwArray[lRow].indexOf(num)==-1);
				this.gameView.model.setProperty(i,'isHint'+num.toString(),allBool);
	    	}
		}

		for(var i = Math.floor(index/9)*9 ; i<Math.floor(index/9)*9+9;++i){		
	    	lColumn  = i % 9;
	    	lRow     = Math.floor(i/9);
	    	lVSector = Math.floor(Math.floor(i/9)/3);
	    	lHSector = Math.floor((i % 9)/3);
	    	var allBool;
	    	for(var num =1; num<10;++num){
				allBool = (sctrArray[lHSector][lVSector].indexOf(num)==-1) &&  (clmnArray[lColumn].indexOf(num)==-1) && (rwArray[lRow].indexOf(num)==-1);
				this.gameView.model.setProperty(i,'isHint'+num.toString(),allBool);
	    	}
		}

		for(var j = Math.floor(Math.floor(index/9)/3)*3*9; j<Math.floor(Math.floor(index/9)/3)*3*9+3*9; j+=9){
			for(var i = Math.floor((index % 9)/3)*3; i <Math.floor((index % 9)/3)*3+3 ; ++i){
	    		lColumn  = (i+j) % 9;
	    		lRow     = Math.floor((i+j)/9);
	    		lVSector = Math.floor(Math.floor((i+j)/9)/3);
	    		lHSector = Math.floor(((i+j) % 9)/3);
	    		var allBool;
	    		for(var num =1; num<10;++num){
					allBool = (sctrArray[lHSector][lVSector].indexOf(num)==-1) &&  (clmnArray[lColumn].indexOf(num)==-1) && (rwArray[lRow].indexOf(num)==-1);
					this.gameView.model.setProperty(i+j,'isHint'+num.toString(),allBool);
	    		}
			}
		}
		
	}

	function setShownValue(index, number){
		if(number==0){
			this.gameView.model.setProperty(index,'shownValue',"");
		}
		else{
			this.gameView.model.setProperty(index,'shownValue',number);
		}
		
		if(this.diffInt==1) this.reSetHints(index);
	//	this.setHints();
	}

	function checkRow(index) {
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
		return false;
	}
	
	function checkColumn(index) {
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
		return false;
	}

	function checkSquare(index) {
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
		return false;
	}

}
