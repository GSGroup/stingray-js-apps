Item {
                width:150;
                height:modelIndex>2?40:0;
                visible: modelIndex>2;
				anchors.horizontalCenter: parent.horizontalCenter;

				Image {
					 id:progress;
					 anchors.verticalCenter: time.verticalCenter;
					 anchors.left: parent.left;
					 anchors.rightMargin:1;
					 source: "apps/sudoku/img/ico_level_"+(model.isBetter?"up":"down")+".png";
				}

                SmallText {
                    id: player;
                    anchors.top: parent.top;
					anchors.horizontalCenter: parent.horizontalCenter;
                    text: model.player;
                }

                SmallText {
                    id:time;
                    anchors.top: parent.top;
                    anchors.right: parent.right;
					anchors.leftMargin: 15;
                    text: Math.floor(model.time/60)+":"+model.time%60;
                }
            }

