PageStack : Item {
	property int currentIndex: 0;
	property int previousIndex: 0;
	property bool animated; // page stack will use opacity property
	focus: false;

	onCurrentIndexChanged: {
		log("current index changed " + this.currentIndex);
		if (this.previousIndex == this.currentIndex)
			return;

		if (this.previousIndex > -1)
			this.children[this.previousIndex].visible = false;

		this.previousIndex = this.currentIndex;
		this.children[this.currentIndex].visible = true;
	}

	onCompleted: {
		for (var i = 1; i < this.children.length; ++i)
			this.children[i].visible = false;
	}
}
