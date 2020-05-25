// Copyright (c) 2011 - 2019, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
    id: categoryDelegate;
    property bool isActive: (categoryList.currentIndex + 1) === model.id;

    width: categoryText.width;
    height: 20;
    focus: true;

    BodyText {
        id: categoryText;
        text: model.title;
        opacity: 1.0;
        color: categoryDelegate.isActive ? constants.colors["active"] : "#FFFFFF";
    }

    Rectangle {
        id: activeHighlight;
        anchors.bottom: categoryText.bottom;

        height: 2;
        width: categoryText.width;

        color: constants.colors["active"];
        opacity: categoryDelegate.activeFocus ? 1.0 : constants.inactiveOpacity;
        visible: categoryDelegate.isActive;
    }
}

