// Copyright (c) 2011 - 2021, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Delegate {
	id: simpleChooserDelegate;

	width: delegateText.width + 20;
	height: 28;

	anchors.verticalCenter: parent.verticalCenter;

	focus: true;

	Rectangle {
		anchors.fill: parent;
		color: simpleChooserDelegate.activeFocus ? colorTheme.activeBorderColor : colorTheme.backgroundColor;
		borderColor: simpleChooserDelegate.activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
		borderWidth: 2;
		radius: colorTheme.rounded ? 10 : 0;

		BodyText {
			id: delegateText;
			x: 10;
			anchors.verticalCenter: parent.verticalCenter;
			color: simpleChooserDelegate.activeFocus ? colorTheme.activeTextColor : simpleChooserDelegate.parent.focused ? colorTheme.textColor : colorTheme.disabledTextColor;
			text: model.text;

			Behavior on color { animation: Animation { duration: 200; } }
		}

		Behavior on color { animation: Animation { duration: 200; } }
		Behavior on borderColor { animation: Animation { duration: 200; } }
	}

	Behavior on x { animation: Animation { duration: 400; easingType: ui.Animation.OutCirc; } }
}
