ListModel {
	onCompleted: {
		for(var i=1; i<10; ++i)
			this.append({digit : i});
	}
}
