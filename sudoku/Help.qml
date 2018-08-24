import controls.Edit;
import "HelpStringDelegate.qml";

Item {
	id: gameOverBox;
	height:150;
	width:350;
	focus: true;
	
	Image {
		id: helpTheme;
		anchors.horizontalCenter: parent.anchors.horizontalCenter;
		anchors.verticalCenter: parent.anchors.verticalCenter;
		source: "apps/sudoku/img/ground_help.png";
	}

	Image {
		id: scrollBar;
		x: 347;
		y: -35;
		source: "apps/sudoku/img/scroll.png";
	}

	ListView {
		id:listView;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.top: finalTheme.top;
		anchors.topMargin: 150;
		height: 300;
		width: 200;
		spacing: 10;
		model: ListModel {
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline aextline textline textline textline "}
			   ListElement {text: "textline tsdtline textline textline textline "}
			   ListElement {text: "textline texfline textline textline textline "}
			   ListElement {text: "textline texsline textline textline textline "}
			   ListElement {text: "textline textasde textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textliasdfextline textline textline "}
			   ListElement {text: "textline textlinasdfxtline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textline asdtline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "1111line textline texasdfe textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textline textasdf textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "222tline textline textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "333tline textline textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline texadsfe textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textliasdfextline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "444tline textline textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "555tline textline tasdfine textline textline "}
			   ListElement {text: "textline textline textlasdftextline textline "}
			   ListElement {text: "textline textline textline adsfline textline "}
			   ListElement {text: "textline textline textline textline textline "}
			   ListElement {text: "texadsfe textline textline textline textline "}
			   ListElement {text: "666tlinadsfxtline textline textline textline "}
			   ListElement {text: "textline teadsfne textline textline textline "}
			   ListElement {text: "textline textliasdfasdfsne textline textline "}
			   ListElement {text: "textline textline textlidfasdftline textline "}
			   ListElement {text: "textline textline textline texasdfe textline "}
			   ListElement {text: "textline textline textline textlinasdsdfline "}
			   ListElement {text: "777tline textline textline textline textasdf "}
		}

		delegate: HelpStringDelegate {}
		}
		onDownPressed: {
			if(scrollBar.y<220){
				scrollBar.y+= 15;
				this.currentIndex+=1;
				log("scrollBar y "+scrollBar.y);
			}
		}
		
		onUpPressed: {
			if(scrollBar.y>-35){
				scrollBar.y-= 15;
				this.currentIndex-=1;
				log("scrollBar y "+scrollBar.y);
			}
		}
}
