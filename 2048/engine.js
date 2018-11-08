var elements = [];
var swapList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
var direction = 'Up';

this.init = function() {
	for (var i = 0; i < 16; i ++)
		elements.push({val: 0, added: false, joined: false});
	add();
	add();
}

this.changeCells = function(cells, width, height) {
	for (var i = 0; i < 16; ++i)
	{
		if (elements[i].joined)
		{
			cells[i + 16].value = cells[swapList[i]].value;
		}
		else
		{
			if (!elements[i].added)
				cells[swapList[i]].value = elements[i].val;
			else
				cells[swapList[i]].value = 0;
		}
		cells[swapList[i]].added = elements[i].added;
		cells[swapList[i]].x = (i % 4) * width;
		cells[swapList[i]].y = Math.floor(i / 4) * height;
	}
}

this.next = function(cells) {
	for (var i = 16; i < 32; ++i)
		cells[i].value = 0;

	for (var i = 0; i < 16; ++i)
	{
		if (elements[i].added)
			cells[swapList[i]].value = elements[i].val;

		if (elements[i].joined)
		{
			cells[swapList[i]].added = true;
			cells[swapList[i]].value *= 2;
		}
	}
}

this.tic = function () {
	for (var i = 0; i < 16; i ++)
		elements[i] = {added: false, val: elements[i].val, joined: false};
}

function rotate(i, j) {
	switch (direction)
	{
		case 'Down':
			return i * 4 + j;
		case 'Up':
			return (3 - i) * 4 + j;
		case 'Right':
			return j * 4 + i;
		case 'Left':
			return j * 4 + 3 - i;
		default:
			log("FATAL ERROR: invalid direction!!!");
			return i * 4 + j;
	}
}

function get(i, j) {
	return elements[rotate(i, j)];
}

function set(i, j, v) {
	elements[rotate(i, j)] = { val: v, added: false, joined: false };
}

function setJoined(i, j, v) {
	elements[rotate(i, j)] =  { val: v, added: false, joined: true };
}

function swap(i1, j1, i2, j2) {
    if (get(i1, j1).val == 0 && get(i2, j2).val == 0)
		return;

	var x = swapList[rotate(i1, j1)];
	swapList[rotate(i1, j1)] = swapList[rotate(i2, j2)];
	swapList[rotate(i2, j2)] = x;
}

function add() {
	var v = [];

	for (var i = 0; i < 16; ++i)
	{
		if (!elements[i].val)
			v.push(i);
	}

	if (!v.length)
		return;

	var index = v[Math.floor(Math.random() * v.length)];
	elements[index] = { val: Math.random() > 0.1 ? 2 : 4, added: true, joined: false };
}

this.add = add;

this.check = function () {
	for (var i = 0; i < 16; ++i)
	{
		if (!elements[i].val)
			return true;
		if (i % 4 < 3 && elements[i].val == elements[i + 1].val)
			return true;
		if (i < 12 && elements[i].val == elements[i + 4].val)
			return true;
	}

	return false;
}

this.clear = function () {
	for (var j = 0; j < 4; ++j)
		for (var i = 0; i < 4; ++i)
			set(i, j, 0);
	add();
	add();
}

this.turn = function(key) {
	var changed = false;
	var sum = 0;
	var win = false;

	direction = key;

	for (var j = 0; j < 4; ++j)
	{
		for (var i = 3; i >= 0; --i)
		{
			var t = true;
			while (get(i, j).val == 0)
			{
				t = false;
				for (var k = i; k > 0; --k)
				{
					if (get(k - 1, j).val != 0)
					{
						t = true;
						changed = true;
					}
					set(k, j, get(k - 1, j).val);
					swap(k - 1, j, k, j);
				}
				set(0, j, 0);
				if (!t)
					break;
			}
			if (!t)
				break;

			if (i != 3)
				++i;
			else
				continue;

			if (get(i, j).val == get(i - 1, j).val && !get(i, j).joined && !get(i - 1, j).joined)
			{
				changed = true;
				setJoined(i, j, get(i, j).val * 2);
				if (get(i, j).val == 2048)
					win = true;
				swap(i - 1, j, i, j);
				sum += get(i, j).val;
				set(i - 1, j, 0);
				++i;
			}
			--i;
		}
	}
	log("CHANGED: " + changed + " win " + win);
	return { 'sum': sum, 'changed': changed, 'win': win };
}
