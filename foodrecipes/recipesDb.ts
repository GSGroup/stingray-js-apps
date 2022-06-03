// Copyright (c) 2011 - 2022, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

class Recipe
{
	readonly title: string;
	readonly image: string;
	readonly desc: string;

	constructor(title: string, image: string, desc: string) {
		this.title = title;
		this.image = image;
		this.desc = desc;
	}
}

const recipes: Array<Recipe> = [
	new Recipe(
		"Кекс в кружке",
		"apps/foodrecipes/res/recipes/1.jpg",
		"Для приготовления кекса по этому рецепту подберите огнеупорную стеклянную или керамическую кружку объемом не менее 200 мл, которую можно использовать в микроволновой печи.\nВбейте в подготовленную кружку яйцо. Добавьте сахар, ванильный экстракт и щепотку соли. Влейте молоко и растительное масло. Перемешайте небольшой ложкой или вилкой.\nМуку для теста кекса просейте с порошком какао через мелкое сито в небольшую емкость. Получившуюся смесь добавьте в кружку с яично-молочной смесью. Тщательно перемешайте.\nКрая кружки протрите салфеткой. Включите микроволновую печь на максимальную мощность. Поместите внутрь кружку с тестом кекса. Готовьте в течение 2–3 минут.\nГотовый кекс в кружке осторожно достаньте из микроволновой печи. Дайте немного остыть при комнатной температуре. Вынимать кекс из кружки нет необходимости.\nКекс в кружке дополните сиропом (ягодным, карамельным, шоколадным), хорошим мороженым (в идеале пломбиром) и посыпьте миндальными лепестками. Подайте на стол."
	),

	new Recipe(
		"Салат с креветками и апельсином",
		"apps/foodrecipes/res/recipes/2.jpg",
		"Подготовить ингредиенты салата с креветками. Апельсины очистить от кожуры. Держа апельсин над миской, вырезать мякоть из пленок. Из остатков отжать сок в ту же миску, сохранить.\nПриготовить заправку для салата с креветками и апельсинами. Чеснок очистить и измельчить или пропустить через пресс. Смешать лимонный и апельсиновый сок, соевый соус, мед и чеснок.\nВареные креветки обвалять в кунжутных семечках. Выложить в салатницу креветки и апельсины. Полить приготовленной ранее заправкой и сразу подать салат на стол."
	),

	new Recipe(
		"Мандариновый татен",
		"apps/foodrecipes/res/recipes/3.jpg",
		"Очистите и разрежьте мандарины на кружочки 5–10 мм толщиной. Смажьте круглую форму для выпечки растопленным маргарином, уложите в нее мандарины.\nРазогрейте духовку до 180 °С. В большую миску разбейте яйцо, всыпьте муку, сахар, ванилин, разрыхлитель и соль, тщательно перемешайте. Влейте к ним молоко и вновь перемешайте. Как только смесь станет однородной, вылейте ее в форму на мандарины, поставьте в духовку на 35 мин.\nДостаньте татен из духовки, остудите 10 мин, осторожно переверните так, чтобы мандарины оказались сверху. Слегка подогрейте абрикосовый или апельсиновый джем, , смажьте им мандарины.\nУкрасьте пирог листиками мяты и подавайте."
	)
];

export function getRecipeByIndex(index: number): Recipe {
	if (index >= recipes.length) {
		throw new RangeError("Recipe index " + index + " out of range " + recipes.length);
	}

	return recipes[index];
}