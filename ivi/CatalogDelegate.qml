Rectangle {
    id: catalogDelegate;

    width: posterImage.width + 14;
    height: posterImage.height + 14;

    color: activeFocus ? "#EC174F" : "#F9F9F9";

    opacity: activeFocus ? 1.0 : 0.5;

    Image {
        id: posterImage;

        width: 172;
        height: 264;

        anchors.centerIn: parent;

        source: model.poster;

        fillMode: PreserveAspectFit;
    }
}
