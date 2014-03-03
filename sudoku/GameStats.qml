GameStats : Item {
        id: gameStats;
		property int difficulty;
				
        Rectangle {
            id: gameStatsHead;
            height: 100;
            anchors.top: parent.top;
            anchors.left: parent.left;
            anchors.right: parent.right;

            BigText {
                anchors.fill: parent;
                id: text;
                text: "STATS";
            }
        }
        
        ListView {
            id:listView;
            anchors.top: gameStatsHead.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
            width: 200;
            height: 700;
            model: ListModel { }
            delegate: Rectangle {
                width:100;
                height:40;
                
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
            }
        }

        function load(data){
                this.stats = data["stats"];
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
						tmpObj.time = argObj.time;
					}
                    tmpModel.push(tmpObj);
                }
				
                if(!isInList) tmpModel.push(argObj);
                tmpModel.sort(this.statsCompare);

                this.listView.model.reset();
                for(var i=0; i<8;++i){
						this.listView.model.append(tmpModel[i]);
                }
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
		
		function saveStats(){}

}