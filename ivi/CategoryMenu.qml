import "CategoryDelegate.qml";

import "js/constants.js" as constants;

ListView {
    id: categoryList;

    focus: true;
    clip: true;

    model: ListModel {}

    delegate: CategoryDelegate {}

    onCompleted: {
        constants.categories.forEach(function (category) {
            model.append( { title: category.title, url: category.url });
        });
    }
}
