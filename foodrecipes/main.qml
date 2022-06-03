// Copyright (c) 2011 - 2022, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import controls.Button;

import "recipesDb.js" as recipesDb;

Application {
	id: foodRecipesApp;

	PageStack {
		id: appPageStack;

		anchors.fill: parent;

		Item {
			anchors.fill: parent;

			Column {
				anchors.centerIn: parent;

				spacing: 5;

				Text {
					font: titleFont;
					text: "Выберите рецепт";
					color: colorTheme.activeTextColor;
				}

				Button {
					id: recipe1Button;

					text: "Кекс в кружке";

					onSelectPressed: { foodRecipesApp.showRecipe(0); }
				}

				Button {
					text: "Салат с креветками и апельсином";

					onSelectPressed: { foodRecipesApp.showRecipe(1); }
				}

				Button {
					text: "Мандариновый татен";

					onSelectPressed: { foodRecipesApp.showRecipe(2); }
				}
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
				anchors.topMargin: 20;
				anchors.horizontalCenter: parent.horizontalCenter;
			}

			ScrollingText {
				id: recipeDescText;

				width: parent.width / 2;

				anchors.top: recipeImage.bottom;
				anchors.topMargin: 20;
				anchors.bottom: parent.bottom;
				anchors.horizontalCenter: parent.horizontalCenter;

				color: colorTheme.textColor;

				onBackPressed: { appPageStack.currentIndex = 0; }
			}
		}
	}

	function showRecipe(recipeIndex) {
		const recipe = recipesDb.getRecipeByIndex(recipeIndex);

		recipeTitleText.text = recipe.title;
		recipeImage.source = recipe.image;
		recipeDescText.text = recipe.desc;

		appPageStack.currentIndex = 1;
	}

	onStarted: {
		appPageStack.currentIndex = 0;
		recipe1Button.setFocus();
	}
}
