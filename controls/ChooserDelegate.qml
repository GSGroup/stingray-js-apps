// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Delegate {
	id: chooserDelegateProto;

	property string text: model.text != undefined ? tr(model.text) : "";
	property string icon: model.icon != undefined ? model.icon : "";

	property bool chooserFocused;

	width: 20hpw + chooserDelegateText.width * chooserDelegateText.visible + chooserIcon.width * chooserIcon.visible + (chooserIcon.visible && chooserDelegateText.visible) * 10hpw;
	height: parent.height;

	focus: true;

	Image {
		id: chooserIcon;

		anchors.left: parent.left;
		anchors.leftMargin: 10hpw;
		anchors.top: parent.top;
		anchors.topMargin: 10hph;
		anchors.bottom: parent.bottom;
		anchors.bottomMargin: 10hph;
		anchors.verticalCenter: parent.verticalCenter;

		source: chooserDelegateProto.icon;
		fillMode: ui.Image.FillMode.PreserveAspectFit;

		visible: source != undefined && source != "";
		opacity: parent.focused || chooserDelegateProto.chooserFocused ? 1 : 0.6;

		Behavior on opacity { animation: Animation { duration: 300; } }
	}

	BodyText {
		id: chooserDelegateText;

		anchors.right: parent.right;
		anchors.rightMargin: 10hpw;
		anchors.verticalCenter: parent.verticalCenter;

		text: chooserDelegateProto.text;
		color: chooserDelegateProto.activeFocus ? colorTheme.globalBackgroundColor :
				chooserDelegateProto.chooserFocused ? colorTheme.focusedTextColor : colorTheme.activeTextColor;

		visible: text != undefined && text != "";
		opacity: parent.focused || chooserDelegateProto.chooserFocused ? 1 : 0.6;

		Behavior on color { animation: Animation { duration: 300; } }
		Behavior on opacity { animation: Animation { duration: 300; } }
	}
}
