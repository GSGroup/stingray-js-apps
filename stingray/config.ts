// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import { FeatureHolder, SignalConnection } from 'stingray/utils'

class ConfigFeatureHolder extends FeatureHolder<stingray.IConfigPtr> {}

export class Config {
	private readonly feature: ConfigFeatureHolder;

	public constructor() {
		this.feature = new ConfigFeatureHolder(app.Config());
	}

	public get volume(): number {
		return this.feature.get().GetVolume();
	}

	public set volume(volume_: number) {
		this.feature.get().SetVolume(volume_);
	}

	public volumeUp(): void {
		return this.feature.get().VolumeUp();
	}

	public volumeDown(): void {
		return this.feature.get().VolumeDown();
	}

	public onVolumeAboutToBeChanged(slot: () => void): SignalConnection {
		return new SignalConnection(this.feature.get().OnVolumeAboutToBeChanged().connect(() => {
			return slot();
		}));
	};

	public onVolumeChanged(slot: (volume: number) => void): SignalConnection {
		return new SignalConnection(this.feature.get().OnVolumeChanged().connect((volume: number) => {
			return slot(volume);
		}));
	};

	public get muted(): boolean {
		return this.feature.get().IsMuted();
	}

	public set muted(muted_: boolean) {
		this.feature.get().Mute(muted_);
	}

	public toggleMute(): void {
		return this.feature.get().ToggleMute();
	}

	public onMutedChanged(slot: (muted: boolean) => void): SignalConnection {
		return new SignalConnection(this.feature.get().OnMutedChanged().connect((muted: boolean) => {
			return slot(muted);
		}));
	};
}

export const Feature = new Config();
