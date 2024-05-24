// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import { FeatureHolder, SignalConnection } from 'stingray/utils'

export class Drm extends FeatureHolder<stingray.ICasFeaturePtr> {
	private id: (string | null) = null;

	private readonly casInfo: stingray.IConditionalAccessInfoPtr;
	private readonly casInfoConnection: stingray.SignalConnection;

	public constructor() {
		super(app.Cas());

		this.casInfo = this.getFeature().GetDrmCasInfo();

		if (!this.casInfo)
			return;

		this.casInfoConnection = this.casInfo.OnUserIdentityChanged().connect(
			(userIdentity: stingray.IConditionalAccessUserIdentityPtr) => this.id = userIdentity ? userIdentity.GetId() : null
		);
	}

	public get dreId(): (string | null) {
		return this.id;
	}

	public onDreIdChanged(slot: (dreId: (string | null)) => void): SignalConnection {
		if (!this.casInfo)
			return new SignalConnection();
		return new SignalConnection(this.casInfo.OnUserIdentityChanged().connect(
			(userIdentity: stingray.IConditionalAccessUserIdentityPtr) => slot(userIdentity ? userIdentity.GetId() : null)
		));
	}
}

export const Feature = new Drm();
