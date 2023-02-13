Delegate {
	width: 32hpw;
	height: 32hph;

	focus: true;

	Image {
		anchors.fill: parent;

		source: model.tile >= 0? "apps/fontanero/t/" + model.tile + ".png": "";

		visible: model.tile >= 0;
	}
}
