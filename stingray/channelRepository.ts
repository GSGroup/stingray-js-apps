// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import { FeatureHolder, SignalConnection } from 'stingray/utils'

export enum SourceType {
	None,
	Dvb,
	Ip,
	Hybrid
}

export class ChannelRepository extends FeatureHolder<stingray.IChannelRepositoryPtr> {
	public constructor() {
		super(app.ChannelRepository());
	}

	public get sourceType(): SourceType {
		return ChannelRepository.sourceTypeFromValue(this.getFeature().GetSourceType());
	}

	public onSourceTypeChanged(slot: (sourceType: SourceType) => void): SignalConnection {
		return new SignalConnection(this.getFeature().OnSourceTypeChanged().connect((sourceType: number) => {
			return slot(ChannelRepository.sourceTypeFromValue(sourceType));
		}));
	};

	private static sourceTypeFromValue(nativeSourceType: number): SourceType {
		if (nativeSourceType in SourceType)
			return nativeSourceType;
		throw "Unknown source type: " + nativeSourceType;
	}
}

export const Feature = new ChannelRepository();
