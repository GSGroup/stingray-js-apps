Cell : Rectangle {
	id: cellItem;
	width: Math.floor(parent.width/9);
	height: Math.floor(parent.width/9);
	color: "#008888";
	borderColor: "#432100";
	borderWidth: 1;


}

Game :  Grid {
	id: board;
	columns: 9;
	rows: 9;
	focus: true;
	cursorX: 0;
	cursorY: 0;

	Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{}
	Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{}
	Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{}
	Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{}
	Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{}
	Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{}
	Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{}
	Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{}
	Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{} Cell{}

	Rectangle {
		id:cursor;
		color: "#008888";
		borderWidth: 5;
		borderColor: "#fff";
		radius: 5;

		width: Math.floor(parent.width/9);
		height: Math.floor(parent.width/9);
		x: 0;
		y: 0;

		onXChanged: {
			log("x changed");
		}

		onYChanged: {
			log("y changed");
		}

		Behavior on x { animation: Animation { duration: 100; } }
		Behavior on y { animation: Animation { duration: 100; } }
	
	}
	onDownPressed: {
		log("gridDownPressed");
		if (this.cursor.y < this.cursor.height  * 8){ 
			this.cursor.y+=this.cursor.height;
		}
		log("coords = "+this.cursor.x.toString()+" "+this.cursor.y.toString())
	}

	onUpPressed: {
		log("gridUpPressed");
		if (this.cursor.y > 0){ 
			this.cursor.y-=this.cursor.height;
		}
		log("coords = "+this.cursor.x.toString()+" "+this.cursor.y.toString())
	}

	onLeftPressed: {
		log("gridLeftPressed");
		if (this.cursor.x > 0){ 
			this.cursor.x-=this.cursor.width;
		}
		log("coords = "+this.cursor.x.toString()+" "+this.cursor.y.toString())

	}

	onRightPressed: {
		log("gridRightPressed"); 
		if (this.cursor.x < this.cursor.width * 8){ 
			this.cursor.x+=this.cursor.width;
		}
		log("coords = "+this.cursor.x.toString()+" "+this.cursor.y.toString())
		
	}
	
}



