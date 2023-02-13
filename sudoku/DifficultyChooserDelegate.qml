// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Delegate {
	width: 99hpw;
	height: 28;
	anchors.verticalCenter: parent.verticalCenter;
	focus: true;

	Image {
		id:dcDelegateImgage;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.verticalCenter: parent.verticalCenter;
		source: "apps/sudoku/img/btn_set_"+(parent.activeFocus? "focus": (parent.focused?"selected":"regular"))+".png";
	}

	BodyText {
		id: delegateText;
		x: 10hpw;
		anchors.verticalCenter: parent.verticalCenter;
		anchors.horizontalCenter: parent.horizontalCenter;
//		color: parent.activeFocus ? colorTheme.activeTextColor : parent.parent.focused ? colorTheme.textColor : colorTheme.disabledTextColor;
		color: "#581B18";
		text: model.name;
		
		Behavior on color { animation: Animation { duration: 200; } }
	}

	Behavior on x { animation: Animation { duration: 400; easingType: OutCirc; } }
}

