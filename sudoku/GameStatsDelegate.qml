Item {
                width:200;
                height:40;

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
					anchors.left: progress.right;
					anchors.leftMargin: 10;

                    text: model.player;
                }

                SmallText {
                    id:time;
                    anchors.top: parent.top;
                    anchors.right: parent.right;
                    text: Math.floor(model.time/60)+":"+model.time%60;
                }
            }

