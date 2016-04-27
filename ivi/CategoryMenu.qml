import controls.Button;
import "js/constants.js" as constants;

ListView {
    id: categoryListView;

    focus: true;
    clip: true;

    model: ListModel {}

    delegate: SmallText {
        id: categoryText;

        text: model.title;

        verticalAlignment: Text.AlignVCenter;

        color: activeFocus ? constants.colors["active"] : "#FFFFFF";
    }

    onCompleted: {
        constants.categories.forEach(function (category) {
            model.append( { title: category.title, url: category.url });
        });
    }
}
