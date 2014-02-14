import "generator.js" as gen
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

		var sudokuMatrix = gen.getMatrix();
		var hiddenMatrix = gen.getHiddenMatrix();

		for (var i = 0; i < 9; ++i) {
			for (var j = 0; j < 9; ++j)
				this.append({value: sudokuMatrix[i][j], opened: hiddenMatrix[i][j]});
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
