import controls.SmallText;

Item {
    id: videoDelegate;
    width: 172;
    height: 300;

    Image {
        id: posterImage;
        width: 172;
        height: 264;
        fillMode: PreserveAspectFit;

        source: model.poster;
    }

    SmallText {
        id: titleText;
        anchors.top: posterImage.bottom;
        anchors.left: videoDelegate.left;
        anchors.right: videoDelegate.right;
        anchors.topMargin: 10;

        text: model.title;

        color: "#91949C";
        horizontalAlignment: AlignHCenter;
        wrapMode: WordWrap;
    }

    onSelectPressed: { log("Width: ", this.width); log("height: ", this.height); }
}
