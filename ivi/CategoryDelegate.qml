import controls.SmallText;

import "js/constants.js" as constants;

SmallText {
    id: titleText;

    text: model.title;

    color: activeFocus ? constants.colors["active"] : "#FFFFFF";
}
