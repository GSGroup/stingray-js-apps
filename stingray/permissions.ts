// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import { SignalConnection } from 'stingray/utils';

export enum PermissionRequestResult {
    Granted,
    Refused
}

export class PinRequest {
    private readonly nativeRequest: stingray.IPinRequestPtr;

    public constructor(nativeRequest: stingray.IPinRequestPtr) {
        this.nativeRequest = nativeRequest;
    }

    public setPin(pin: string) : boolean {
        return this.nativeRequest.SetPin(pin);
    }
}

type PinRequestCallback = (pinRequest: PinRequest | null) => void;
type PermissionCallback = (permission: PermissionRequestResult) => void;

export class AuthorizationSession {
    private readonly name: string;
    private readonly pinRequestCallback: PinRequestCallback;

    private readonly authSession: stingray.IAuthorizationSessionPtr;
    private readonly pinRequestConnection: SignalConnection;

    private permissionCallback: PermissionCallback;
    private permissionListener: stingray.IPermissionListenerPtr;
    private permissionConnection: SignalConnection;

    public constructor(name: string, pinRequestCallback: PinRequestCallback, expirationTime?: number) {
        this.name = name;
        this.pinRequestCallback = pinRequestCallback;

        this.authSession = app.UserAccountManager().CreateAuthorizationSession(this.name, expirationTime);
        this.pinRequestConnection = new SignalConnection(this.authSession.OnPinRequest().connect((pinRequest: stingray.IPinRequestPtr) => {
            this.pinRequestCallback(pinRequest ? new PinRequest(pinRequest) : null);
        }));
    }

    public requestPermission(permissionCallback: PermissionCallback, age?: number): void {
        this.cancelRequest();

        this.permissionCallback = permissionCallback;
        this.permissionListener = app.PermissionManager().RequestGenericPermission(this.name, this.authSession, age);
        this.permissionConnection = new SignalConnection(this.permissionListener.OnPermissionChanged().connect((result: number) => {
            this.permissionCallback(AuthorizationSession.permissionRequestResultFromValue(result));
        }));
    }

    public cancelRequest(): void {
        if (this.permissionConnection)
            this.permissionConnection.disconnect();
        if (this.permissionListener)
            this.permissionListener.reset();

        this.permissionCallback = null;
        this.permissionListener = null;
        this.permissionConnection = null;
    }

    private static permissionRequestResultFromValue(permissionRequestResult: number): PermissionRequestResult {
        if (permissionRequestResult in PermissionRequestResult)
            return permissionRequestResult;
        throw "Unknown result type: " + permissionRequestResult;
    }

}
