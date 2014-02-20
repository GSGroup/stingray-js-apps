var sudokuMatrix = [
		[1, 2, 3, 4, 5, 6, 7, 8, 9],
		[4, 5, 6, 7, 8, 9, 1, 2, 3],
		[7, 8, 9, 1, 2, 3, 4, 5, 6],
		[2, 3, 4, 5, 6, 7, 8, 9, 1],
		[5, 6, 7, 8, 9, 1, 2, 3, 4],
		[8, 9, 1, 2, 3, 4, 5, 6, 7],
		[3, 4, 5, 6, 7, 8, 9, 1, 2],
		[6, 7, 8, 9, 1, 2, 3, 4, 5],
		[9, 1, 2, 3, 4, 5, 6, 7, 8]
];

var hiddenMatrix = [
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true]
];

this.getMatrix = function () {
	return transposition(sudokuMatrix);
}

this.getHiddenMatrix = function () {
	var filterMatrix = [
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true],
	[true, true, true, true, true, true, true, true, true]
];

	for (var i = 0; i < 40; ++i) {
		filterMatrix[Math.floor(Math.random() * 9)][Math.floor(Math.random() * 9)] = false;
	}
	log("filterMatrix = "+filterMatrix);
	return filterMatrix;
}

function swapRow(matrix, row1, row2) {
	var rowVar = matrix[row1];
	matrix[row1] = matrix[row2];
	matrix[row2] = rowVar;
	return matrix;
}

function randomize(matrix) {
	for (var i = 0; i < 20; ++i) {
		var x = Math.random () * 3;
		if (x < 1)
			matrix = transposition(matrix);
		else if (x < 2) {
			matrix = swapRowArea(matrix, 0, 2);
			matrix = swapRowArea(matrix, 1, 2);
		} else {
			matrix = swapRow(matrix, 0, 1);
			matrix = swapRow(matrix, 1, 2);
			matrix = swapRow(matrix, 3, 1);
			matrix = swapRow(matrix, 3, 1);
			matrix = swapRow(matrix, 6, 7);
			matrix = swapRow(matrix, 6, 8);
		}
	}
	return matrix;
}

function transposition(matrix) {
	var resMatrix = [];
	for (var i = 0; i < 9; ++i){
		resMatrix[i] = [];
		for (var j = 0; j < 9; ++j){
			resMatrix[i][j] = matrix[j][i];
		}
	}
	
	return (resMatrix);
}

function swapRowArea(matrix, rowArea1, rowArea2) {
	var rowVar1 = matrix[rowArea1 * 3];
	var rowVar2 = matrix[rowArea1 * 3 + 1];
	var rowVar3 = matrix[rowArea1 * 3 + 2];

	matrix[rowArea1 * 3] = matrix[rowArea2 * 3];
	matrix[rowArea1 * 3 + 1] = matrix[rowArea2 * 3 + 1];
	matrix[rowArea1 * 3+ 2] = matrix[rowArea2 * 3 + 2];

	matrix[rowArea2 * 3] = rowVar1;
	matrix[rowArea2 * 3 + 1] = rowVar2;
	matrix[rowArea2 * 3 + 2] = rowVar3;

	return matrix;
}
