GameStats : Item {
        id: gameStats;

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

        function load(data)
        {
                log("LOADING STATS");
                this.stats = data["stats"];
                this.stats.sort(this.statsCompare);
                for (var i =0; i<this.stats.length; ++i){
                        listView.model.append(this.stats[i]);
                }
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

        function addNrestat(obj){
                this.tmpModel = [];

                for(var i=0; i<listView.model.count; ++i)
                {
                    this.tmpModel.push({player: this.listView.model.get(i)['player'], time: this.listView.model.get(i)['time']});
                }

//                this.tmpModel.push({player:"asd1", time: 2});
                this.tmpModel.push(obj);
                this.tmpModel.sort(this.statsCompare);

                this.listView.model.reset();
                for(var i=0; i<5;++i)
                {
                        this.listView.model.append({'player': this.tmpModel[i].player, 'time': this.tmpModel[i].time});
                }

        }

}