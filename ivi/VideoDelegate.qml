Rectangle {
    id: videoDelegate;

    width: 186;
    height: 278;
    color: activeFocus ? "#EC174F" : "#F9F9F9";

    Image {
        id: posterImage;

        width: 172;
        height: 264;

        anchors.centerIn: parent;

        source: model.poster;

        fillMode: PreserveAspectFit;
    }
}
