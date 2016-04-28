import controls.SmallText;

import "js/constants.js" as constants;

SmallText {
    id: categoryText;

    text: model.title;

    color: focused ? constants.colors["active"] : "#FFFFFF";
}

