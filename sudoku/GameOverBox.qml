Item {
	id: gameOverBox;

	signal continueEvent();
	signal menuCallEvent();


	anchors.verticalCenter: parent.anchors.verticalCenter;
	anchors.horizontalCenter: parent.anchors.horizontalCenter;
	height:150;
	width:350;

	focus: true;
	
	Image {
		id: finalTheme;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.verticalCenter: parent.verticalCenter;
		source: "apps/sudoku/img/ground_final.png";
	}
 
	TitleText {
		id: resText;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.bottom: finalTheme.bottom;	
		anchors.bottomMargin:180;
		
		text:"";
	}


	TitleText {
		id: difficulty;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.top: finalTheme.top;	
		anchors.topMargin:60;
		
		text:"";
	}

	TitleText {
		id: player;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.top: finalTheme.top;	
		anchors.topMargin:100;
		
		text:"";
	}
	
	TitleText {
		id: time;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.bottom: finalTheme.bottom;	
		anchors.bottomMargin:120;
		
		text:"";
	}

	FocusablePanel {
		id: continueButton;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.bottom: finalTheme.bottom;
		anchors.bottomMargin: 70;
		width: 250;
		height: 50;

		color: "#00000000";

		Image {
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.verticalCenter: parent.verticalCenter;
			source: "apps/sudoku/img/btn_main_"+(parent.activeFocus? "focus":"regular")+".png";
		}

		SmallText {
			id: txt;
			anchors.verticalCenter: parent.verticalCenter;
			anchors.horizontalCenter: parent.horizontalCenter;
			color: parent.activeFocus ? colorTheme.activeTextColor : colorTheme.textColor;
			text:"continue";
		}

			
		onUpPressed: {
		}

		onDownPressed: {
			menuCallButton.setFocus();
		}
			
		onSelectPressed: {
			log("CONTINUE PRESSED!");
			parent.continueEvent();
		}
	}


	FocusablePanel {
		id: menuCallButton;
		anchors.top: continueButton.bottom;
		anchors.horizontalCenter: parent.horizontalCenter;
		width: 250;
		height: 50;
		anchors.topMargin: 5;


		color: "#00000000";

		Image {
			anchors.horizontalCenter: parent.horizontalCenter;
			anchors.verticalCenter: parent.verticalCenter;
 			source: "apps/sudoku/img/btn_main_"+(parent.activeFocus? "focus":"regular")+".png";
		}

		SmallText {
			id: txt;
			anchors.verticalCenter: parent.verticalCenter;
			anchors.horizontalCenter: parent.horizontalCenter;
			color: parent.activeFocus ? colorTheme.activeTextColor : colorTheme.textColor;
			text:"to main menu";
		}
			
		onUpPressed: {
			continueButton.setFocus();
		}

		onDownPressed: {
		}
			
		onSelectPressed: {
			log("helpButton PRESSED!");
			parent.menuCallEvent();
		}
	}	

	onBackPressed: {
		pageStack.currentIndex = 0;
		gameMenu.setFocus();
		gameStats.opacity=1;
	}

			
}
