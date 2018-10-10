this.Get = function(y,x) { 
	var idx = y * 8 + x;
	return gameView.model.get(idx);
}

this.Init = function () {
	for (var x = 0; x < 64; ++x)
		gameView.model.append({disc: "Empty"});
	Set(3, 3, "White");
	Set(4, 4, "White");
	Set(3, 4, "Black");
	Set(4, 3, "Black");
}

this.Reset = function () {
	for (var x = 0; x < 8; ++x)
		for (var y = 0; y < 8; ++y)
			Set(x, y, "Empty");
	Set(3, 3, "White");
	Set(4, 4, "White");
	Set(3, 4, "Black");
	Set(4, 3, "Black");
}

function Set (y, x, color) {
	var idx = y * 8 + x;
	gameView.model.set(idx, {disc: color});
}

this.MakeMove = function (yp, xp, white, simulate)	{
	var sum = 0;
	if (this.Get(yp, xp).disc != "Empty")
		return -1;

	var color = white ? "White" : "Black";
	var op_color = white ? "Black" : "White";

	for (var r = 0; r < 8; ++r)
	{
		var dx_r = [-1, 0, 1, 1, 1, 0, -1, -1];
		var dy_r = [-1, -1, -1, 0, 1, 1, 1, 0];
		var dx = dx_r[r], dy = dy_r[r];
		var value = 0;
		for (var s = 1; s < 8; ++s)
		{
			var y = yp + s * dy, x = xp + s * dx;

			if (x < 0 || x >= 8 || y < 0 || y >= 8)
				break;

			var cell = this.Get(y, x);

			if (cell.disc == "Empty")
			{
				break;
			}
			else if (cell.disc == op_color)
			{
				++value;
			}
			else //my color
			{
				if (value > 0)
				{
					if (!simulate)
					{
						while(--s)
						{
							var y = yp + s * dy, x = xp + s * dx;
							Set(y, x, color);
						}
					}
					sum += value;
				}
				break;
			}
		}
	}

	if (!simulate && sum > 0)
		Set(yp, xp, color);

	return sum;
}
	
this.Save = function()	{
	var state = [];
	for (var y = 0; y < 8; ++y)
	{
		state.push([]);
		for (var x = 0; x < 8; ++x)
		{
			var cell = this.Get(y, x);
			state[y].push(cell.disc);
		}
	}
	return state;
}

this.Restore = function(state) {
	for (var y = 0; y < 8; ++y)
	{
		for (var x = 0; x < 8; ++x)
			Set(y, x, state[y][x]);
	}
}

this.GetPositionalBonus = function(y,x,white)
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
			var corner_x = x < 4 ? 0 : 7;
			var corner_y = y < 4 ? 0 : 7;

			var corner_cell = this.Get(corner_y, corner_x);
			if (corner_cell.disc != "Empty")
			{
				var my_corner = corner_cell.disc == (white ? "White" : "Black");
				if (my_corner)
					value = -value;
			}
			else
			{
				//empty corner
				var state;
				state = this.Save();
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

		if(game.difficultyLevel > 0 && ((lX == 0 && lY != 0) || (lX != 0 && lY == 0)))
		{
			var cell1, cell2;

			if (lX == 0)
			{
				cell1 = this.Get(y - 1, x);
				cell2 = y < 2 ? false : this.Get(y - 2, x);
			}
			else
			{
				cell1 = this.Get(y, x - 1);
				cell2 = x < 2 ? false : this.Get(y, x - 2);
			}

			if (cell1.disc == "Empty")
			{
				if (cell2 && cell2.disc == (white ? "White" : "Black"))
					value = Math.min(value, -2);
			}

			if (cell1.disc == (white ? "Black" : "White"))
			{
				var state = this.Save();
				this.MakeMove(y, x, white, false);
				if (cell1.disc == (white ? "White" : "Black"))
					value = value < 0 ? value : 6;
				else
					value = Math.min(value, -6);
				this.Restore(state);
			}

			if (lX == 0)
			{
				cell1 = this.Get(y + 1 , x);
				cell2 = y > 5 ? false : this.Get(y + 2 , x);
			}
			else
			{
				cell1 = this.Get(y, x + 1);
				cell2 = x > 5 ? false : this.Get(y, x + 2);
			}

			if (cell1.disc == "Empty")
			{
				if (cell2 && cell2.disc == (white ? "White" : "Black"))
					value = Math.min(value, -2);
			}

			if (cell1.disc == (white ? "Black" : "White"))
			{
				var state = this.Save();
				this.MakeMove(y, x, white, false);
				if (cell1.disc == (white ? "White" : "Black"))
					value = value < 0 ? value : 6;
				else
					value = Math.min(value, -6);
				this.Restore(state);
			}
		}
		return value;
}

function insertPriority (v, elem) {
		for (var i = 0; i < v.length - 1; i++)
		{
			if (v[i].p <= elem.p && v[i + 1].p >= elem.p)
			{
				v.splice(i, 0, elem);
				return;
			}
		}
		v.push(elem);
}

this.NextMove = function (white, simulate) {
		var moves = []; 
		for (var y = 0; y < 8; ++y)
		{
			for (var x = 0; x < 8; ++x)
			{
				var cell = this.Get(y, x);
				if (cell.disc != "Empty")
					continue;
				var sum = this.MakeMove(y, x, white, true);
				if (sum > 0)
				{
					var bonus = this.GetPositionalBonus(y, x, white);
					var elem = {y: y, x:  x, p: sum + bonus};
					insertPriority(moves, elem);
					if (simulate)
						return true;

					log("possible move: " + y + ", " + x + ", discs: " + sum + ", bonus: " + bonus);
				}
			}
		}

		if (moves.length == 0)
			return false;

		var i;
		for (i = 0; i < moves.length && moves[i].p == moves[0].p; i++);
		var move = moves[Math.floor(Math.random() * i)];
		log("move: " + move.y + ", " + move.x + ", weight: " + move.p);
		this.MakeMove(move.y, move.x, white, false);

		return true;
}
