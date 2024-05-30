// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import { FeatureHolder, SignalConnection } from 'stingray/utils'

export class Cas extends FeatureHolder<stingray.ICasFeaturePtr> {
	private readonly signalConnection: stingray.SignalConnection;

	private id: string = null;

	public constructor() {
		super(app.Cas());

		const dreCasInfo = this.getFeature().GetDreCasInfo();

		if (!dreCasInfo)
			return;

		this.signalConnection = dreCasInfo.OnUserIdentityChanged().connect(
			userIdentity => this.id = userIdentity ? userIdentity.GetId() : null
		);
	}

	public get dreId(): string {
		return this.id;
	}
}

export const Feature = new Cas();
