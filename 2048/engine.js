// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

var elements = [];
var swapList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

this.init = function() {
	for (var i = 0; i < 16; ++i)
		elements.push({ val: 0, added: false, joined: false });

	add();
	add();
}

this.changeCells = function(cells, width, height) {
	for (var i = 0; i < 16; ++i)
	{
		cells[i + 16].value = 0;

		if (elements[i].joined)
		{
			cells[i + 16].value = cells[swapList[i]].value;
		}
		else
		{
			cells[swapList[i]].value = elements[i].added ? 0 : elements[i].val;
			cells[swapList[i]].addedValue = elements[i].added ? elements[i].val : 0;
		}

		cells[swapList[i]].added = elements[i].added;
		cells[swapList[i]].joined = elements[i].joined;
		cells[swapList[i]].x = (i % 4) * width;
		cells[swapList[i]].y = Math.floor(i / 4) * height;
	}
}

function resetElements() {
	for (var i = 0; i < 16; ++i)
		elements[i] = { added: false, val: elements[i].val, joined: false };
}

function swap(i1, i2) {
	if (!elements[i1].val && !elements[i2].val)
		return;

	var x = swapList[i1];
	swapList[i1] = swapList[i2];
	swapList[i2] = x;
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
	for (var i = 0; i < 16; ++i)
	{
		elements[i] = { val: 0, added: false, joined: false };
		swapList[i] = i;
	}

	add();
	add();
}

this.move = function (direction) {
	var changed = false;
	var sum = 0;

	resetElements();

	var rotations = direction == "Left" ? 1 :
					direction == "Down" ? 2 :
					direction == "Right" ? 3 : 0;

	// rotate clockwise then move tiles up then rotate up to 360 degrees
	rotate(rotations, elements);
	rotate(rotations, swapList);

	for (var i = 0; i < 16; ++i)
	{

		if (!elements[i].val)  // nothing to move
			continue;

		if (i - 4 < 0)  // end of field
			continue;

		for (var nextPosition = i - 4; nextPosition >= 0; nextPosition -= 4)
		{
			if (!elements[nextPosition].val)  // empty space - move further
			{
				continue;
			}
			else if (elements[nextPosition].val != elements[i].val || elements[nextPosition].joined)  // no space to move - return
			{
				nextPosition += 4;
				break;
			}
			else  // join
			{
				elements[i].val *= 2;
				elements[nextPosition].joined = true;
				sum += elements[i].val;
				break;
			}
		}

		if (nextPosition < 0)
			nextPosition += 4;

		if (nextPosition != i)
		{
			changed = true;
			elements[nextPosition].val = elements[i].val;
			elements[i].val = 0;
			swap(i, nextPosition);
		}
	}

	if (rotations)
	{
		rotate(4 - rotations, elements);
		rotate(4 - rotations, swapList);
	}

	if (changed)
		add();

	return sum;
}

function rotate(count, array) {
	if (!count)
		return;

	var rotationMatrix = [12, 8, 4, 0, 13, 9, 5, 1, 14, 10, 6, 2, 15, 11, 7, 3];

	while (count--)
	{
		var temp = new Array(16);

		for (var i = 0; i < 16; ++i)
			temp[i] = array[rotationMatrix[i]];
		for (var i = 0; i < 16; ++i)
			array[i] = temp[i];
	}
}

