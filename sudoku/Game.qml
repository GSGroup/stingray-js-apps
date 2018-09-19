import "generator.js" as generator;
import "CellDelegate.qml";
import "DigitChooserDelegate.qml";
import "DigitChooseModel.qml";
import "FixedStringTimer.qml";
import "GameFieldModel.qml";
import "HintDigitChooserDelegate.qml";
import "HintDigitChooseModel.qml";

Rectangle {
	id: gameItem;
	signal gameOverEvent(result);
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
			anchors.topMargin: 68;
			anchors.horizontalCenter: difficultyHeader.horizontalCenter;
			color:"#813722";
            text: parent.difficulty;
    }

	BigText {
			id:difficultyHeader;
			anchors.bottom: difficultyIndicator.top;
			anchors.bottomMargin: 18;
			anchors.right: parent.right;
			anchors.rightMargin: 105;
			anchors.horizontalCenter: difficultyIndicator.horizontalCenter;
			color: "#813722";
			text:"level:";
	}

	FixedStringTimer {
			id: timeIndicator;
			anchors.top: difficultyIndicator.bottom;
			anchors.topMargin: 78;
			anchors.horizontalCenter: difficultyIndicator.horizontalCenter;

			Timer {
				id:timer;
				repeat: true;
				interval: 1000;
				onTriggered: {
					++timeIndicator.seconds;
				}
			}
	}
//1
	BigText {
			anchors.bottom: timeIndicator.top;
			anchors.bottomMargin: 15;
			anchors.horizontalCenter: difficultyIndicator.horizontalCenter;
			color: "#813722";
			text:"time:"
	}

	
	ListView {
		id: digitChooser;

		anchors.right: gameView.left;
		anchors.top: gameView.top;
		width: gameView.cellWidth;
		height: gameView.cellHeight*9;

		visible: false;
		opacity: visible ? 1.0 : 0.01;

		model: DigitChooseModel {}
		delegate: DigitChooserDelegate {}

		onSelectPressed:{
			if (!gameItem.timeIndicator.timer.running) {gameItem.timeIndicator.timer.start();}
            else { log("TIMER IS RUNNING");}
			parent.setShownValue(gameView.currentIndex,currentIndex+1);			 			
			if (gameItem.isFilled()){
				gameItem.timeIndicator.timer.stop();
				var gameOverText = "YOU ";
				(!gameItem.fullStateCheck())?(gameOverText+="WIN!"):(gameOverText+="LOSE");
				gameItem.gameOverEvent(gameOverText);
			}
			digitChooser.visible = false;
			hintDigitChooser.visible = false;
			eraser.visible = false;
			showHintButton.visible = false;
			gameView.wall.color = "#00000000"
			gameView.setFocus();
		}

        onBackPressed: {
            digitChooser.visible = false;
			hintDigitChooser.visible = false;
			eraser.visible = false;
			showHintButton.visible = false;
			gameView.wall.color = "#00000000"
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
		width: gameView.cellWidth;
		height: gameView.cellHeight*9;

		visible: false;
		opacity: visible ? 1.0 : 0.01;

		model: HintDigitChooseModel {}

		delegate: HintDigitChooserDelegate {}

		onSelectPressed:{
			this.opacity = 0;
			digitChooser.visible = false;
			eraser.visible = false;
			hintDigitChooser.visible = false;
            gameView.setFocus(); 
			gameView.wall.color = "#00000000"
			gameView.model.setProperty(gameView.currentIndex, 'isHint'+(currentIndex+1), !(gameView.model.get(gameView.currentIndex)['isHint'+(currentIndex+1)]));
		}

        onBackPressed: {
			digitChooser.visible = false;
            hintDigitChooser.visible = false;
			eraser.visible = false;
			gameView.wall.color = "#00000000"
            gameView.setFocus();
        }

		onRightPressed:{
			digitChooser.setFocus()
		}
		
		onLeftPressed: {
			eraser.setFocus();
		}

		onUpPressed: {
//			showHintButton.setFocus(); stab
		}

		Behavior on opacity {
			animation: Animation {
				duration: 300;
			}
		}

	}

	FocusablePanel {
		id: eraser;
		anchors.top: gameView.top;
		anchors.right: hintDigitChooser.left;
		width: gameView.cellWidth;
		height: width;
		radius: 0;

		color: eraser.activeFocus ? colorTheme.activeBorderColor : "#000000"; //colorTheme.backgroundColor;

		visible: false;
		opacity: visible ? 1.0 : 0.01;

		Image {
			anchors.fill: parent;
			source: "apps/sudoku/img/ico_clear.png";
		}

		onSelectPressed: {
			parent.setShownValue(gameView.currentIndex,0);
			eraser.visible = false;
			digitChooser.visible = false;
			hintDigitChooser.visible = false;
			showHintButton.visible = false;
			gameView.wall.color = "#00000000"
			gameView.setFocus();
		}

		onRightPressed: {
			hintDigitChooser.setFocus();
		}

		onBackPressed: {
            digitChooser.visible = false;
			hintDigitChooser.visible = false;
			eraser.visible = false;
			showHintButton.visible = false;
			gameView.wall.color = "#00000000"
            gameView.setFocus();
        }

		Behavior on opacity {
			Animation {
				duration: 300;
			}
		}
	}

	FocusablePanel {
		id: showHintButton;
		anchors.right: hintDigitChooser.right;
		anchors.bottom: hintDigitChooser.top;
		width: hintDigitChooser.width;
		height: width;
		radius: 0;
		color: showHintButton.activeFocus ? colorTheme.activeBorderColor : "#000000"; //colorTheme.backgroundColor;

		visible: false;
		opacity: visible ? 1.0 : 0.01;

		Image {
			  anchors.fill: parent;
			  source: "apps/sudoku/img/ico_clear.png";
		}

		onSelectPressed: {}
		onDownPressed: {
			hintDigitChooser.setFocus();
		}

		Behavior on opacity {
			Animation {
				duration: 300;
			}
		}
	}

	GridView {
		id: gameView;
		anchors.horizontalCenter: mainGameTheme.horizontalCenter;
		anchors.bottom: mainGameTheme.bottom;
		anchors.bottomMargin: 21;
		focus: true;
		height: mainGameTheme.height-142;
		width: mainGameTheme.height-142;
		cellWidth: width/9;
		cellHeight: height/9;
		model: GameFieldModel {}

		delegate: CellDelegate{} 

		Rectangle {
			id: wall;
			anchors.fill: parent;
			color: "#00000000";
		}


		onSelectPressed: {

			if (!gameView.model.get(gameView.currentIndex)['isBase']){
				log("Show digit chooser");
                digitChooser.visible = true;
				hintDigitChooser.visible = true;
				eraser.visible = true;
				digitChooser.setFocus();
				wall.color = "#00000055";
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

	function gameHide() {
		log("Game hide");
		this.digitChooser.visible = false;
		this.eraser.visible = false;
		this.hintDigitChooser.visible = false;
		this.showHintButton.visible = false;
	}

    function gameReset(){
        this.timeIndicator.timer.restart();
        this.timeIndicator.timer.stop();
        this.timeIndicator.seconds = 0;
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
