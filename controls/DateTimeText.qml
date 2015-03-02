Text {
	id: dateTimeTextItem;
	color: colorTheme.activeTextColor;
	font: smallFont;
	property int unixTime;

	onUnixTimeChanged: {
		var setDate = new Date(unixTime * 1000);
		var currDate = new Date();
		dateTimeTextItem.text = "";
		if (currDate.getFullYear() == setDate.getFullYear() && currDate.getMonth() == setDate.getMonth()) {
			if (currDate.getDate() == setDate.getDate()) {
				dateTimeTextItem.text = "Сегодня";
			} else if (currDate.getDate() == setDate.getDate() + 1) {
				dateTimeTextItem.text = "Вчера";
			}
		}
		if (dateTimeTextItem.text.length == 0) {
				dateTimeTextItem.text += setDate.getDate();
				dateTimeTextItem.text += ".";
				dateTimeTextItem.text += setDate.getMonth() + 1;
				dateTimeTextItem.text += ".";
				dateTimeTextItem.text += setDate.getFullYear();
		}
		dateTimeTextItem.text += " ";
		dateTimeTextItem.text += setDate.getHours();
		dateTimeTextItem.text += ":";
		dateTimeTextItem.text += (setDate.getMinutes() < 10 ? "0" : "") + setDate.getMinutes();
	}
}
