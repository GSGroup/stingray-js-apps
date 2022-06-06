import controls.Button;

Delegate {
	height: recipeButton.height;
	width: recipeButton.width;

	Button {
		id: recipeButton;

		text: model.text;
	}
}
