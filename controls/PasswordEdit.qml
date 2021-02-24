import "BaseEdit.qml";
import "PasswordEditDelegate.qml";

BaseEdit {
	id: passwordEditItem;

	property Color pinDotColor: activeFocus ? colorTheme.focusedTextColor : colorTheme.activeTextColor;

	width: pinList.width;
	height: 12;
	
	focus: true;

	ListView {
		id: pinList;

		property int currentPinLength;
		property Color pinDotColor: passwordEditItem.pinDotColor;

		width: listModel.count ? listModel.count * 12 + (listModel.count - 1) * this.spacing : 0;
		height: parent.height;

		spacing: 12;
		orientation: Horizontal;

		model: ListModel { id: listModel; }
		delegate: PasswordEditDelegate {
			filled: pinList.currentPinLength >= (modelIndex + 1);
			color: pinList.pinDotColor;
		}

		onCompleted: {
			if (passwordEditItem.maxLen)
				passwordEditItem.fillModel(passwordEditItem.maxLen);
			else
				passwordEditItem.fillModel(passwordEditItem.text.length);
		}
	}

	onTextChanged: {
		pinList.currentPinLength = passwordEditItem.text.length;

		if (!passwordEditItem.maxLen)
			passwordEditItem.fillModel(passwordEditItem.text.length);
	}

	function fillModel(textSize) {
		while (listModel.count != textSize)
		{
			if (listModel.count > textSize)
				listModel.remove(listModel.count - 1);
			else
				listModel.append({ });
		}
	}
}
