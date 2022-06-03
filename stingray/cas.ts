// Copyright (c) 2011 - 2022, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import { FeatureHolder, SignalConnection } from 'stingray/utils'

class CasFeatureHolder extends FeatureHolder<stingray.ICasFeaturePtr> {}

export class Cas {
	private readonly feature: CasFeatureHolder;
	private readonly signalConnection: SignalConnection;

	private id: string;

	public get dreId(): string {
		return this.id;
	}

	public constructor() {
		this.feature = new CasFeatureHolder(app.Cas());
		this.signalConnection = new SignalConnection(this.feature.get().GetDreCasInfo().OnUserIdentityChanged().connect(
			userIdentity => this.id = userIdentity ? userIdentity.GetId() : null
		));
	}
}

export const Feature = new Cas();