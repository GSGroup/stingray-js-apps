PageStack : Item {
	id: pageStackItem;
	property int currentIndex;
	property int previousIndex;
	property bool animated; // page stack will use opacity property
	focus: false;

	onCurrentIndexChanged: {
		if (pageStackItem.previousIndex == pageStackItem.currentIndex)
			return;

		if (pageStackItem.previousIndex > -1)
			pageStackItem.children[pageStackItem.previousIndex].visible = false;

		pageStackItem.previousIndex = pageStackItem.currentIndex;
		pageStackItem.children[pageStackItem.currentIndex].visible = true;
	}

	onCompleted: {
		for (var i = 1; i < this.children.length; ++i)
			this.children[i].visible = false;
	}
}
