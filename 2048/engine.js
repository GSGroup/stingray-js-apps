this.init = function (elements) {
	for (var i = 0; i < 16; i ++)
		elements.push({val: 0, added: false, joined: false});
	add();
	add();
}


this.tic = function () {
	for (var i = 0; i < 16; i ++)
		fieldView.elements[i] = {added: false, val: fieldView.elements[i].val, joined: false};
}

function rotate(i, j) {
	switch (game.direction) {
	case 'Down': return i * 4 + j;
	case 'Up': return (3 - i) * 4 + j;
	case 'Right': return j * 4 + i;
	case 'Left': return j * 4 + 3 - i;
	default: log("FATAL ERROR: invalid direction!!!"); return i * 4 + j;
	}
}

function get(i, j) {
	return fieldView.elements[rotate(i,j)];
}

function set(i, j, v) {
	fieldView.elements[rotate(i,j)] =  {val: v, added: false, joined: false} ;
}

function setNew(i, j, v) {
	fieldView.elements[rotate(i,j)] =  {val: v, added: true, joined: false} ;
}

function setJoined(i, j, v) {
	fieldView.elements[rotate(i,j)] =  {val: v, added: false, joined: true};
}

function swap(i1, j1, i2, j2) {
    if (get(i1,j1).val == 0 && get(i2,j2).val == 0) return;
	var x = fieldView.swapList[rotate(i1,j1)];
	fieldView.swapList[rotate(i1,j1)] = fieldView.swapList[rotate(i2,j2)];
	fieldView.swapList[rotate(i2,j2)] = x;
}


function add() {
	var v = [];
	for (var i = 0; i < 4; i ++) {
		for (var j = 0; j < 4; j ++) {
			if (get(i,j).val == '0')
				v.push({'i': i, 'j': j});
		}
	}
	if (v.length == 0) return false;
	var ind = Math.floor(Math.random() * v.length);
	setNew(v[ind].i, v[ind].j, Math.random() > 0.1 ? 2 : 4);
	return true;
}
this.add = add;

this.check = function () {
	for (var j = 0; j < 4; j ++)
		for (var i = 0; i < 4; i ++) {
			if (get(i,j).val == 0) return true;
			if (i != 3 && get(i,j).val == get(i + 1,j).val) return true;
			if (j != 3 && get(i,j).val == get(i,j + 1).val) return true;
		}
	return false;
}

this.clear = function () {
	for (var j = 0; j < 4; j ++)
		for (var i = 0; i < 4; i ++) 
			set(i,j,0);
	add();
	add();
}

this.turn = function () {
	var changed = false;
	var sum = 0;
	for (var j = 0; j < 4; j ++) {
		for (var i = 3; i >= 0; i --) {
			var t = true;
			while (get(i,j).val == 0) {
				t = false;
				for (var k = i; k > 0; k --) {
					if (get(k - 1,j).val != 0) {
						t = true;
						changed = true;
					}
					set(k,j,get(k - 1,j).val);
					swap(k - 1, j, k, j);
				}
				set(0,j,0);
				if (!t) break;
			}
			if (!t) break;
			if (i != 3) i ++; else continue;
			if (get(i,j).val == get(i - 1,j).val && !get(i,j).joined && !get(i - 1,j).joined) {
				changed = true;
				setJoined(i,j,get(i,j).val * 2);
				swap(i - 1,j,i,j);
				sum += get(i,j).val;
				set(i - 1,j,0);
				i ++;
			}
			i --;
		}
	}
	log("CHANGED: ", changed);
	return {'sum': sum, 'changed': changed};
}
