var currentColorIndex = 0;

//блоки и варианты их поворота по частовой стрелке
var j = [0x44C0, 0x8E00, 0x6440, 0x0E20];
var l = [0x4460, 0x0E80, 0xC440, 0x2E00];
var o = [0xCC00, 0xCC00, 0xCC00, 0xCC00];
var i = [0x0F00, 0x2222, 0x00F0, 0x4444];
var s = [0x06C0, 0x8C40, 0x6C00, 0x4620];
var t = [0x0E40, 0x4C40, 0x4E00, 0x4640];
var z = [0x0C60, 0x4C80, 0xC600, 0x2640];

var colorGradientStart = ["#E49C8B","#E297D8","#E7CD6E","#B2C016","#7298E3"];
var colorGradientEnd = ["#CE573D","#D151BD","#D9B42F","#919C11","#366DD9"];

//выдача цвета
this.randomColor = function () {
	currentColorIndex = Math.floor(Math.random() * 5);
}

this.getGradientStart = function () {
	return colorGradientStart[currentColorIndex];
}

this.getGradientEnd = function () {
	return colorGradientEnd[currentColorIndex];
}

//выдача случайного элемента
this.randomBlock = function () {
	var pieces = [i,j,l,o,s,t,z];
	var indexBlockView = Math.floor(Math.random() * 4);
	var next = pieces[Math.floor(Math.random() * 7)];
	var nextBlock = next[indexBlockView];

	return nextBlock;
}
