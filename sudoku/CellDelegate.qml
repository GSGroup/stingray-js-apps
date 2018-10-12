Item {
	id: cellItemDelegate;

	width: Math.floor(parent.width/9);
	height: Math.floor(parent.width/9);

	Rectangle {
		anchors.fill:parent;

		color: (cellItemDelegate.focused && !cellItemDelegate.activeFocus)? "#00000088" : "#00000000";
	}

	Gradient {
		anchors.fill: parent;

		opacity: cellItemDelegate.activeFocus? 1 : 0;	
	
		GradientStop {
			position: 0;
			color: "#0096F0";
		}
		
		GradientStop {
			position: 1;
			color: "#004B7E";
		}
		
		Behavior on opacity { Animation { duration: 300; }}
	}

	Text {
		id: subText;

		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.margins: 5;

		horizontalAlignment: Text.AlignHCenter;
		verticalAlignment: Text.AlignVCenter;

		color: model.isBase? "#581B18":( cellItemDelegate.focused?"#FFFFFF":"#447F12");
 		font: Font {
			  family: "Proxima Nova Condensed";
			  pixelSize: 70;

		}

		style: Shadow;
		text:  model.shownValue;

		Behavior on color { Animation { duration: 300; }}
	}

	Text {
		id: hint1;

		anchors.horizontalCenter:parent.horizontalCenter;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.leftMargin:5;
		anchors.topMargin:12;

		color: cellItemDelegate.focused ? "#FFFFFF" : "#375900";

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

		Behavior on color { Animation { duration: 300; }}
	}
}

