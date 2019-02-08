import "js/constants.js" as constants;

BodyText {
    id: categoryText;

    text: model.title;

    color: focused ? constants.colors["active"] : "#FFFFFF";
}

