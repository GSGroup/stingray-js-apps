function  Get(y,x) { 
		idx = y * 8 + x; 
		return gameView.model.at(idx); 
}
/*	
	function Reset(){
			for(var i = 0; i < 8; ++i) {
				for(var j = 0; j < 8; ++j) {
					cell = this.Get(i, j);
					if ((i == 3 && j == 3) || (i == 4 && j == 4))
						cell.disc = "White";
				    else 
					if ((i == 3 && j == 4) || (i == 4 && j == 3))
						cell.disc = "Black";
				    else
						cell.disc = "Empty";
			}
			gameOver = false;
			blackCounter = 2;
			whiteCounter = 2;
		}
	}
	function MakeMove(yp, xp, white, simulate)	{
		sum = 0;
		if (this.Get(yp, xp).disc != "Empty")
			return -1;

		var color = white ? "White" : "Black";
		var op_color = white? "Black": "White";

		for(var r = 0; r < 8; ++r)
		{
			var dx_r = [-1, 0, 1, 1, 1, 0, -1, -1];
			var dy_r = [-1, -1, -1, 0, 1, 1, 1, 0];
			var dx = dx_r[r], dy = dy_r[r];
			var value = 0;
			for(var s = 1; s < 8; ++s)
			{
				var y = yp + s * dy, x = xp + s * dx;
				if (x < 0 || x >= 8 || y < 0 || y >= 8)
					break;
				var cell = this.Get(y, x);
				if (cell.disc == "Empty")
					break;
				else if (cell.disc == op_color)
					++value;
				else //my color
				{
					if (value > 0)
					{
						if (!simulate)
						{
							while(--s)
							{
								var y = yp + s * dy, x = xp + s * dx;
								this.Get(y, x).disc = color;
							}
						}
						sum += value;
					}
					break;
				}
			}
		}
		if (!simulate && sum > 0) {
			switch (color) {
			case "White":
				this.whiteCounter ++;
				break;
			case "Black":
				this.blackCounter ++;
				break;
			}
			this.Get(yp, xp).disc = color;
		return sum;
	}
	
	function Save(state)
	{
		for(var y = 0; y < 8; ++y)
			for(var x = 0; x < 8; ++x)
			{
				cell = this.Get(y, x);
				state[y][x] = cell.disc;
			}
	}
	function Restore(state)
	{
		for(var y = 0; y < 8; ++y)
			for(var x = 0; x < 8; ++x)
			{
				cell = this.Get(y, x);
				cell.disc = state[y][x];
			}
	}

	function GetPositionalBonus(y,x,white)
	{
		var bonus =
		[
			[ 8, -4,  6,  4, ],
			[-4, -8,  0,  0, ],
			[ 6,  0,  2,  2, ],
			[ 4,  0,  2,  2, ],
		];
		var lX = x < 4 ? x : 7 - x;
		var lY = y < 4 ? y : 7 - y;
		var value = bonus[lY][lX];

		if (value < 0) //negative bonus should not work when corner is mine
		{
			var corner_x = x < 4? 0: 7;
			var corner_y = y < 4? 0: 7;

			var corner_cell = this.Get(corner_y, corner_x);
			if (corner_cell.disc != "Empty")
			{
				var my_corner = corner_cell.disc == (white ? "White": "Black");
				if (my_corner)
					value = -value;
			}
			else
			{
				//empty corner
				var state;
				this.Save(state);
				this.MakeMove(y, x, white, false);
				if (this.MakeMove(corner_y, corner_x, !white, true) <= 0) {
					if(lY == 0 || lX == 0)
						value = -value;
					else
						value = -2;
				}
				this.Restore(state);
			}
		}

		if(this.difficultyLevel > 0 && ((lX == 0 && lY != 0) || (lX != 0 && lY == 0)))
		{
			var cell1, cell2;

			if (lX == 0) {
				cell1 = this.Get(y - 1 , x);
				cell2 = y < 2 ? NULL : Get(y - 2 , x);
			} else {
				cell1 = this.Get(y, x - 1);
				cell2 = x < 2 ? NULL : Get(y, x - 2);
			}

			if (cell1.disc == "Empty") {
				if (cell2 && cell2.disc == (white ? "White" : "Black"))
					value = Math.min(value, -2);
			}

			if (cell1.disc == (white ? "Black": "White")) {
				var state;
				this.Save(state);
				this.MakeMove(y, x, white, false);
				if (cell1.disc == (white ? "White" : "Black"))
					value = value < 0 ? value : 6;
				else
					value = min(value, -6);
				this.Restore(state);
			}

			if (lX == 0) {
				cell1 = this.Get(y + 1 , x);
				cell2 = y > 5 ? NULL : this.Get(y + 2 , x);
			} else {
				cell1 = this.Get(y, x + 1);
				cell2 = x > 5 ? NULL : this.Get(y, x + 2);
			}

			if (cell1.disc == "Empty") {
				if (cell2 && cell2.disc == (white ? "White" : "Black"))
					value = Math.min(value, -2);
			}

			if (cell1.disc == (white ? "Black":"White")) {
				var state;
				this.Save(state);
				this.MakeMove(y, x, white, false);
				if (cell1.disc == (white ? "White" : "Black"))
					value = value < 0 ? value : 6;
				else
					value = min(value, -6);
				this.Restore(state);
			}

		}
		return value;
	}

	function insertPriority (v, y, x, p) {
		for (var i = 0; i < v.size - 1; i ++) {
			if (v[i].p <= p && v[i + 1].p >= p) {
				for (var j = v.size - 1; j > i; j --)
					v[j + 1] = v[j];
				v[i + 1].y = y;
				v[i + 1].x = x;
				v[i + 1].p = p;
				v.size ++;
				return;
			}
		}
		v[v.size].y = y;
		v[v.size].x = x;
		v[v.size].p = p;
		v[v.size].size ++;
	}

	function NextMove (white,simulate)
	{
		var moves; moves.size = 0;
		for(var y = 0; y < 8; ++y)
			for(var x = 0; x < 8; ++x)
			{
				cell = this.Get(y, x);
				if (cell.disc != "Empty")
					continue;
				var sum = MakeMove(y, x, white, true);
				if (sum > 0)
				{
					var bonus = this.GetPositionalBonus(y, x, white);
					insertPriority(v,y, x, sum + bonus);
					if (simulate)
						return true;
					log("possible move: " + y + ", " + x + ", discs: " + sum + ", bonus: " + bonus);
				}
			}

		if (moves.size == 0)
			return false;

		var equal_moves; equal_moves.size = 0;
		var w = moves[0].p;
		while(moves.size != 0)
		{
			equal_moves[equal_moves.size ++](moves[0]);
			for (var i = 0; i < moves.size; i ++)
				moves[i] = moves[i + 1];
			moves.size --;
		}

		move = equal_moves[Math.random() * equal_moves.size];
		log("move: " + move.y + ", " + move.x + ", weight: " + move.weight);
		MakeMove(move.y, move.x, white, false);
		return true;
	}

	function tic ()  {
			board.NextMove(!board.playerWhite, false); //my move
			
			if (!board.NextMove(board.playerWhite, true)) //no next move for player
			{
				if (!board.NextMove(!board.playerWhite, true)) //no next move for ai also, game over
				{
					var whiteIsWinner = this.whiteCounter > this.blackCounter;					
					if(whiteIsWinner)
						gameOver.text = board.playerWhite ? "You won!" : "Game Over"
					else gameOver.text = !board.playerWhite ? "You won!" : "Game Over";
					game.gameOver = true;
				}
				else
					this.Restart(); //one more time
			}
		}
	}
	
}*/
