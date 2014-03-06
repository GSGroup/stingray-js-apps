GameStats : Item {
        id: gameStats;
		property int difficulty;
		
		Item {
			id: headerItem;		
			height: 100;
			width: 	150;

			anchors.bottom: parent.top;
			anchors.left: parent.left;
		//	anchors.right: parent.right;
			anchors.leftMargin:0;
//			anchors.horizontalCenter: parent.horizontalCenter;

			Item {

				id:firstPlace;
				anchors.top: parent.top;
				anchors.topMargin: 5;
				anchors.horizontalCenter: parent.horizontalCenter;

				SmallText {
					id: player;
					text: listView.model.get(0).player;
					anchors.horizontalCenter: parent.horizontalCenter;
				}

				SmallText {
					id: time;
					anchors.bottom: parent.top;
					anchors.bottomMargin: 100;
					anchors.horizontalCenter: parent.horizontalCenter;
					text: Math.floor(listView.model.get(0).time/60)+":"+listView.model.get(0).time%60;
				}
			}

			Item {

				id:secondPlace;
				anchors.top: parent.top;
				anchors.topMargin: 65;
				anchors.left: parent.left;

				SmallText {
					id: player;
					text: listView.model.get(1).player;
					anchors.left: parent.left;
				}
				SmallText {
					id: time;
					anchors.bottom: parent.top;
					anchors.bottomMargin: 90;
					anchors.horizontalCenter: parent.horizontalCenter;
					text: Math.floor(listView.model.get(1).time/60)+":"+listView.model.get(1).time%60;
				}
			}

			Item {

				id:thirdPlace;
				anchors.top: parent.top;
				anchors.topMargin: 65;
				anchors.right: parent.right;

				SmallText {
					id: player;
					anchors.horizontalCenter: parent.horizontalCenter;
					text: listView.model.get(2).player;
				}

				SmallText {
					id: time;
					anchors.bottom: parent.top;
					anchors.bottomMargin: 90;
					anchors.horizontalCenter: parent.horizontalCenter;
					text: Math.floor(listView.model.get(2).time/60)+":"+listView.model.get(2).time%60;
				}
			}
			
			function reSetHeader(){

			    this.headerItem.firstPlace.player.text = this.listView.model.get(0).player;
			    this.headerItem.firstPlace.time.text =  Math.floor(this.listView.model.get(0).time/60)+":"+
												   this.listView.model.get(0).time%60;
			    this.headerItem.secondPlace.player.text = this.listView.model.get(1).player;
			    this.headerItem.secondPlace.time.text = Math.floor(this.listView.model.get(1).time/60)+":"+
												    this.listView.model.get(1).time%60;
			    this.headerItem.thirdPlace.player.text = this.listView.model.get(2).player;
			    this.headerItem.thirdPlace.time.text = Math.floor(this.listView.model.get(2).time/60)+":"+
												    this.listView.model.get(2).time%60;
				
			}
		}

				
        ListView {
            id:listView;
            anchors.top: gameStats.headerItem.bottom;
//            anchors.left: parent.left;
//            anchors.right: parent.right;
			anchors.horizontalCenter: headerItem.horizontalCenter;
            width: 200;
            height: 700;
            model: ListModel { }
            delegate: Item {
                width:150;
                height:modelIndex>2?40:0;
                visible: modelIndex>2;
				anchors.horizontalCenter: parent.horizontalCenter;

                SmallText {
                    id: player;
                    anchors.top: parent.top;
                    anchors.left: parent.left;
                    text: model.player;
                }

                SmallText {
                    id:time;
                    anchors.top: parent.top;
                    anchors.right: parent.right;
                    text: Math.floor(model.time/60)+":"+model.time%60;   
                }

				Image {
					 id:progress;
					 anchors.verticalCenter: time.verticalCenter;
					 anchors.left: time.right;
					 source: "apps/sudoku/img/ico_level_"+(model.isBetter?"up":"down")+".png";
				}
            }
        }

        function load(data){
//                this.stats = data["stats"];
				this.stats=[];
				var statistic = load("sudokuStats");
				
				for(var i = 0; i<statistic.length; ++i){
					this.stats.push({player: statistic[i].player,
									 time:   parseInt(statistic[i].time,10),
									 difficulty: parseInt(statistic[i].difficulty, 10),
									 isBetter: statistic[i].isBetter=="true"
					});
				}
				if(this.stats.length==0) this.stats = data["stats"];
                this.stats.sort(this.statsCompare);
				this.filterByDifficulty(this.difficulty);
        }

        function statsCompare(a,b){
                if (a.time < b.time){
                        return -1;
                }
                else if (a.time > b.time){
                        return 1;
                }
                else {
                        return 0;
                }
        }

		function filterByDifficulty(difficulty){
			log("FILTERING BY DIFFICULTY "+difficulty);
			this.listView.model.reset();
			for(var i =0; i<this.stats.length; ++i){
				if(this.stats[i].difficulty==difficulty){
						this.listView.model.append(this.stats[i]);
				}
			}

			this.headerItem.reSetHeader()
			
		}

        function addNrestat(argObj){
			 log("ADDNRESTAT");
                var tmpModel = [];
				var tmpObj ={};
				var isInList = false;
                for(var i=0; i<this.listView.model.count; ++i){
					tmpObj = this.listView.model.get(i);
					if(tmpObj.player==argObj.player && tmpObj.difficulty==argObj.difficulty){
						isInList = true;
						tmpObj.isBetter=(tmpObj.time>=argObj.time);
						tmpObj.time = argObj.time;
												
					}
                    tmpModel.push(tmpObj);
                }
                if(!isInList){ 
					argObj.isBetter=true;
					tmpModel.push(argObj);
				}
                tmpModel.sort(this.statsCompare);
                this.listView.model.reset();
                for(var i=0; i<Math.min(8,tmpModel.length);++i){
						this.listView.model.append(tmpModel[i]);
                }

				this.headerItem.reSetHeader();

				this.modelToStats();
				this.saveStats();
        }

		function modelToStats(){
				 var difficulty = this.listView.model.get(0).difficulty;

				 for(var i=0; i<this.stats.length; ++i){
				 		 if(this.stats[i].difficulty==difficulty){
								this.stats.splice(i,1);
								--i; //temporary (filthy splice side effect!!)
						 }
				 }

				 for(var i =0;i<this.listView.model.count;++i){
				 		 this.stats.push(this.listView.model.get(i));
				 }

				 this.stats.sort(this.statsCompare);
		}
		
		function saveStats(){
		    var statistic = [];
			var tmpObj;
			for(var i =0 ; i<this.stats.length; ++i){

				tmpObj = this.stats[i];
				statistic.push({player: tmpObj.player, 
								time:   tmpObj.time.toString(),
								difficulty: tmpObj.difficulty.toString(),
								isBetter: tmpObj.isBetter?"true":"false"});
			}
			log("statistic "+statistic);		
			save("sudokuStats",statistic);
		}

}