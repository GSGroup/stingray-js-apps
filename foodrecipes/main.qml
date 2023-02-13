// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "RecipeDelegate.qml";

import "recipesDb.json" as recipesDb;

Application {
	id: foodRecipesApp;

	PageStack {
		id: appPageStack;

		anchors.fill: parent;

		Item {
			anchors.fill: parent;

			Text {
				id: titleText;

				anchors.centerIn: parent;

				font: titleFont;
				text: "Выберите рецепт";
				color: colorTheme.activeTextColor;
			}

			ListView {
				id: recipesListView;

				anchors.top: titleText.bottom;
				anchors.topMargin: 5hph;
				anchors.left: titleText.left;
				anchors.bottom: safeArea.bottom;

				spacing: 5;

				model: ListModel { id: recipesModel; }
				delegate: RecipeDelegate { }

				onSelectPressed: { foodRecipesApp.showRecipe(currentIndex); }

				onCompleted: { recipesDb.recipes.forEach(recipe => recipesModel.append({ text: recipe.title })); }
			}
		}

		Item {
			anchors.fill: parent;

			Text {
				id: recipeTitleText;

				anchors.horizontalCenter: parent.horizontalCenter;

				font: titleFont;
				color: colorTheme.activeTextColor;
			}

			Image {
				id: recipeImage;

				anchors.top: recipeTitleText.bottom;
				anchors.topMargin: 20hph;
				anchors.horizontalCenter: parent.horizontalCenter;
			}

			ScrollingText {
				id: recipeDescText;

				width: parent.width / 2;

				anchors.top: recipeImage.bottom;
				anchors.topMargin: 20hph;
				anchors.bottom: parent.bottom;
				anchors.horizontalCenter: parent.horizontalCenter;

				color: colorTheme.textColor;

				onBackPressed: { appPageStack.currentIndex = 0; }
			}
		}
	}

	function showRecipe(recipeIndex) {
		if (recipeIndex >= recipesDb.recipes.length)
			throw new RangeError("Recipe index " + index + " out of range " + recipesDb.recipes.length);

		const recipe = recipesDb.recipes[recipeIndex];

		recipeTitleText.text = recipe.title;
		recipeImage.source = recipe.image;
		recipeDescText.text = recipe.desc;

		appPageStack.currentIndex = 1;
	}

	onStarted: {
		appPageStack.currentIndex = 0;
		recipesListView.setFocus();
	}
}
