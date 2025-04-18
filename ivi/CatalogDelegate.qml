// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "js/constants.js" as constants;

Delegate {
	id: catalogDelegate;

	width: constants.poster["width"] + (constants.margin / 3);
	height: constants.poster["height"] + (constants.margin / 3);

	focus: true;

	opacity: activeFocus ? 1.0 : constants.inactiveOpacity;

	Rectangle {
		anchors.fill: parent;

		Image {
			id: posterDefaultImage;

			width: catalogDelegate.activeFocus ? constants.poster["width"] + (constants.margin / 3) : constants.poster["width"];
			height: catalogDelegate.activeFocus ? constants.poster["height"] + (constants.margin / 3) : constants.poster["height"];

			anchors.centerIn: parent;

			sourceWidth: Math.max(constants.poster["width"] + (constants.margin / 3), constants.poster["width"]);
			sourceHeight: Math.max(constants.poster["height"] + (constants.margin / 3), constants.poster["height"]);

			source: constants.defaultPoster;

			fillMode: ui.Image.FillMode.PreserveAspectFit;

			visible: posterImage.status !== ui.Image.Status.Ready;

			Behavior on width { animation: Animation { duration: constants.animationDuration; } }
			Behavior on height { animation: Animation { duration: constants.animationDuration; } }
		}

		Image {
			id: posterImage;

			width: catalogDelegate.activeFocus ? constants.poster["width"] + (constants.margin / 3) : constants.poster["width"];
			height: catalogDelegate.activeFocus ? constants.poster["height"] + (constants.margin / 3) : constants.poster["height"];

			anchors.centerIn: parent;

			registerInCacheSystem: false;

			source: model.poster;

			fillMode: ui.Image.FillMode.PreserveAspectFit;

			Behavior on width { animation: Animation { duration: constants.animationDuration; } }
			Behavior on height { animation: Animation { duration: constants.animationDuration; } }
		}
	}
}
