import "js/constants.js" as constants;


Rectangle {
    id: catalogDelegate;

    width: constants.poster["width"]  + (constants.margin / 3);
    height: constants.poster["height"] + (constants.margin / 3);

    opacity: activeFocus ? 1.0 : constants.inactiveOpacity;

    focus: true;

    Image {
        id: posterImage;

        width:  activeFocus ? constants.poster["width"]  + (constants.margin / 3)  : constants.poster["width"];
        height: activeFocus ? constants.poster["height"] + (constants.margin / 3)  : constants.poster["height"];

        anchors.centerIn: parent;

        activeFocus: catalogDelegate.activeFocus;

        source: model.poster;

        fillMode: PreserveAspectFit;

        Behavior on width  { animation: Animation { duration: constants.animationDuration; } }
        Behavior on height { animation: Animation { duration: constants.animationDuration; } }
    }
}

