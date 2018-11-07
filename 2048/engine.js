this.init = function (elements) {
	for (var i = 0; i < 16; i ++)
		fieldView.elements.push({val: 0, added: false, joined: false});
	this.add();
	this.add();
}


this.tic = function () {
	for (var i = 0; i < 16; i ++)
		fieldView.elements[i] = {added: false, val: fieldView.elements[i].val, joined: false};
}

this.rotate = function (i, j) {
	switch (game.direction) {
	case 'Down': return i * 4 + j;
	case 'Up': return (3 - i) * 4 + j;
	case 'Right': return j * 4 + i;
	case 'Left': return j * 4 + 3 - i;
	default: log("FATAL ERROR: invalid direction!!!"); return i * 4 + j;
	}
}

this.get = function (i, j) {
	return fieldView.elements[this.rotate(i,j)];
}

this.set = function (i, j, v) {
	fieldView.elements[this.rotate(i,j)] =  {val: v, added: false, joined: false} ;
}

this.setnew = function (i, j, v) {
	fieldView.elements[this.rotate(i,j)] =  {val: v, added: true, joined: false} ;
}

this.setjoined = function (i, j, v) {
	fieldView.elements[this.rotate(i,j)] =  {val: v, added: false, joined: true};
}

this.swap = function (i1, j1, i2, j2) {
    if (this.get(i1,j1).val == 0 && this.get(i2,j2).val == 0) return;
//	log(i1 + ' ' + j1 + " : " + i2 + ' ' + j2 + "   : " + this.get(i1,j1).val + " : " + this.get(i2,j2).val);
//	log(this.rotate(i1,j1) + " : " + this.rotate(i2,j2));
	var x = fieldView.swapList[this.rotate(i1,j1)];
	fieldView.swapList[this.rotate(i1,j1)] = fieldView.swapList[this.rotate(i2,j2)];
	fieldView.swapList[this.rotate(i2,j2)] = x; 
//	log(fieldView.swapList);
}


this.add = function () {
	var v = [];
	for (var i = 0; i < 4; i ++) {
		for (var j = 0; j < 4; j ++) {
			if (this.get(i,j).val == '0') 
				v.push({'i': i, 'j': j});
		}
	}
	if (v.length == 0) return false;
	var ind = Math.floor(Math.random() * v.length);
	this.setnew(v[ind].i, v[ind].j, Math.random() > 0.1 ? 2 : 4);
	return true;
}

this.check = function () {
	for (var j = 0; j < 4; j ++)
		for (var i = 0; i < 4; i ++) {
			if (this.get(i,j).val == 0) return true;
			if (i != 3 && this.get(i,j).val == this.get(i + 1,j).val) return true;
			if (j != 3 && this.get(i,j).val == this.get(i,j + 1).val) return true;
		}
	return false;
}

this.clear = function () {
	for (var j = 0; j < 4; j ++)
		for (var i = 0; i < 4; i ++) 
			this.set(i,j,0);
	this.add();
	this.add();
}

this.turn = function () {
	var changed = false;
	var sum = 0;
	for (var j = 0; j < 4; j ++) {
		for (var i = 3; i >= 0; i --) {
			var t = true;
			while (this.get(i,j).val == 0) {
				t = false;
				for (var k = i; k > 0; k --) {
					if (this.get(k - 1,j).val != 0) {
						t = true;
						changed = true;
					}
					this.set(k,j,this.get(k - 1,j).val);
					this.swap(k - 1, j, k, j);
				}
				this.set(0,j,0);
//				this.swap(0,j,1,j);
				if (!t) break;
			}
			if (!t) break;
			if (i != 3) i ++; else continue;
			if (this.get(i,j).val == this.get(i - 1,j).val && !this.get(i,j).joined && !this.get(i - 1,j).joined) {
				changed = true;
				this.setjoined(i,j,this.get(i,j).val * 2);
				this.swap(i - 1,j,i,j);
				sum += this.get(i,j).val;
				this.set(i - 1,j,0);
				i ++;
			}
			i --;
		}
	}
	log("CHANGED: ", changed);
	return {'sum': sum, 'changed': changed};
}
