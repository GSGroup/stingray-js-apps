// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

export class SignalConnection {
	private readonly connection: stingray.SignalConnection;

	public constructor(connection: stingray.SignalConnection = null) {
		this.connection = connection;
	}

	public disconnect(): void {
		if (this.connection)
			this.connection.disconnect();
	}
}

export class ConnectionPool {
	private connections: SignalConnection[] = new Array<SignalConnection>();

	public add(connection: SignalConnection): void {
		this.connections.push(connection);
	}

	public release(): void {
		this.connections.forEach(connection => connection.disconnect());
		this.connections = [];
	}
}

export class FeatureHolder<Type extends stingray.IFeature> {
	private readonly feature: Type;

	public isValid(): boolean {
		return this.feature.IsFeatureValid();
	}

	public getFeature(): Type {
		this.checkFeature();
		return this.feature;
	}

	protected constructor(feature: Type) {
		this.feature = feature;
	}

	private checkFeature(): void {
		if (!this.isValid())
			throw "Feature is not valid!";
	}
}

export enum CollectionOp {
	Added,
	Removed,
	Updated
}

export function collectionOpFromValue(value: number): CollectionOp {
	if (value in CollectionOp)
		return value;
	throw "Unknown collection op value: " + value;
}
