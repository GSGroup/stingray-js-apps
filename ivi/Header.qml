import controls.BigText;

Rectangle {
    id: header;

    property alias title: titleText.text;

    height: logoImage.height;

    color: "#EC174F";

    Image {
        id: logoImage;

        anchors.left: header.left;

        source: "apps/ivi/logo.png";
    }

    BigText {
        id: titleText;

        anchors.centerIn: header;

        color: "#FFFFFF";
    }
}
