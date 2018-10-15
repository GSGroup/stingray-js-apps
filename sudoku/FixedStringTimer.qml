BigText {
	property int seconds;

	color:"#813722";
	text: Math.floor(seconds / 60) + ":" + seconds % 60;
}
