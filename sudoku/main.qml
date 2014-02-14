import controls.Text
import controls.Button
import controls.FocusablePanel

NineDigitsModel : ListModel {
	onCompleted: {
		for(var i = 0; i < 9; ++i)
			this.append({text: i + 1});
	}
}

SudokuDelegate : Rectangle {
	id: sudokuDelegateItem;
	borderWidth: activeFocus ? 8 : 1;
	borderColor: activeFocus ? "#F00" : "#000";
	color: (modelIndex % 9 < 3 || modelIndex % 9 > 5) ^ (modelIndex < 27 || modelIndex > 53) ? ((modelIndex % 2) ? "#FEC" : "#EB9") : ((modelIndex % 2) ? "#eee" : "#aaa");
	height: 60;
	width: 60;
	property bool opened: model.opened;
	property string userValue;
	z: focused ? 50 : 0;
	
	BigText {
		anchors.centerIn: parent;
		anchors.topMargin: 14;
		text: model.opened ? model.value : sudokuDelegateItem.userValue;
		color: model.opened ? "#000" : "#060";
	}
	
	GridView {
		id: digitPickUp;
		anchors.centerIn: parent;
		width: 150;
		height: 150;
		cellWidth: 50;
		cellHeight: 50;
		keyNavigationWraps: true;
		visible: false;
		z: 500;
		
		model: NineDigitsModel { }
		delegate: Rectangle {
			width: 50;
			height: 50;
			color: focused ? "#ff0": "#fff";
			Text {
				font: bigFont;
				anchors.centerIn: parent;
				anchors.topMargin: 10;
				text: model.text;
			}
		}
		
		onSelectPressed: {
			if (!model.opened) {
				sudokuDelegateItem.userValue = currentIndex + 1;
				digitPickUp.visible = false;
			}
		}
		
		onBackPressed: {
				sudokuDelegateItem.userValue = "";
				digitPickUp.visible = false;
		}
	}
	
	onSelectPressed: {
		if (!model.opened) {
			digitPickUp.visible = true;
			digitPickUp.setFocus();
			digitPickUp.currentIndex = 4;
		}
	}
}

SudokuModel: ListModel {
	id: sudokuModel;
	
	

	onCompleted: {
	
		var game1 = [8, 5, 4, 1, 3, 6, 9, 7, 2,
					 7, 9, 3, 8, 4, 2, 6, 5, 1,
					 6, 2, 1, 5, 9, 7, 8, 4, 3,
					 2, 3, 5, 7, 6, 8, 1, 9, 4,
					 1, 8, 7, 4, 2, 9, 3, 6, 5,
					 9, 4, 6, 3, 1, 5, 2, 8, 7,
					 4, 1, 9, 6, 7, 3, 5, 2, 8,
					 5, 7, 2, 9, 8, 1, 4, 3, 6,
					 3, 6, 8, 2, 5, 4, 7, 1, 9 ];
		var game1open = [1, 0, 1, 0, 1, 1, 1, 1, 1,
						 0, 0, 1, 0, 0, 1, 0, 0, 1,
						 1, 0, 1, 0, 1, 0, 0, 0, 0,
						 0, 1, 0, 1, 1, 0, 0, 0, 0,
						 0, 1, 1, 0, 0, 0, 1, 1, 0,
						 0, 0, 0, 0, 1, 1, 0, 1, 0,
						 0, 0, 0, 0, 1, 0, 1, 0, 1,
						 1, 0, 0, 1, 0, 0, 1, 0, 0,
						 1, 1, 1, 1, 1, 0, 1, 0, 1 ];
		
		for (var i = 0; i < 81; ++i) {
			this.append({value: game1[i], opened: game1open[i]});
		}
	}
}

Application {
	id: sudokuApplication;
	focus: true;
	name: "sudoku";
	displayName: qsTr("Sudoku");

	Rectangle {
		id: playField;
		anchors.top: parent.top;
		anchors.topMargin: 30;
		anchors.horizontalCenter: parent.horizontalCenter;
		width: 540;
		height: 540;

		GridView {
			id: sudokuGrid;
			anchors.fill: parent;
			keyNavigationWraps: true;
			cellWidth: playField.width / 9;
			cellHeight: playField.height / 9;
	
			model: SudokuModel { }
			delegate: SudokuDelegate { }
	
		}
	}
}
