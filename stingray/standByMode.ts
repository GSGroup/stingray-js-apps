// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import { FeatureHolder, SignalConnection } from 'stingray/utils'

export enum SwitchReason {
	Default,
	User,
	Auto,
	Scheduler
}

export class StandByMode extends FeatureHolder<stingray.IStandByModePtr> {
	public constructor() {
		super(app.StandByMode());
	}

	public get isEnabled(): boolean {
		return this.getFeature().IsEnabled();
	}

	public onEnabledChanged(slot: (status: boolean, switchReason: SwitchReason) => void): SignalConnection {
		return new SignalConnection(this.getFeature().OnEnabledChanged().connect((status: boolean, switchReason: number) => {
			return slot(status, StandByMode.switchReasonFromValue(switchReason));
		}));
	}

	private static switchReasonFromValue(nativeReason: number): SwitchReason {
		if (nativeReason in SwitchReason)
			return nativeReason;
		throw "Unknown reason: " + nativeReason;
	}
}

export const Feature = new StandByMode();
