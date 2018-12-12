Image {
	width: 32;
	height: 32;

	focus: true;

	source: model.tile >= 0? "apps/fontanero/t/" + model.tile + ".png": "";

	visible: model.tile >= 0;
}
