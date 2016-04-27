import "js/constants.js" as constants;

Rectangle {
    id: catalogDelegate;

    width: posterImage.width + 20; //TODO: Make real border
    height: posterImage.height + 20;

    opacity: activeFocus ? 1.0 : 0.5;

    color: activeFocus ? constants.colors["active"] : "#000000";

    Image {
        id: posterImage;

        width: 172;
        height: 264;

        anchors.centerIn: parent;

        source: model.poster;

        fillMode: PreserveAspectFit;
    }
}
