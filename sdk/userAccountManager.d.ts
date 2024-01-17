// © "Сifra" LLC, 2011-2024
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

/// <reference path="feature.d.ts" />
/// <reference path="signals.d.ts" />

declare namespace stingray {

    /**
     * Request that used to set user-provided PIN code
     */
    export interface IPinRequestPtr extends SmartPointer {
        SetPin(pin: string): boolean;
    }

    /**
     * Control that used to obtain PIN request or null if PIN code is not required.
     */
    export interface IAuthorizationSessionPtr extends SmartPointer {
        GetPinRequest(): IPinRequestPtr | null;
        OnPinRequest(): Signal<[pinRequest: IPinRequestPtr | null]>;
    }


    /**
     * {@link IFeature} representing a module that can be used to create authorization session.
     */
    export interface IUserAccountManagerPtr extends IFeature {
        /**
         * Method that can be used to create authorization session.
         *
         * @param name - session name
         * @param expirationTime - session object validity time in milliseconds. set null to use system defaults
         */
        CreateAuthorizationSession(name: string, expirationTime: number | null): IAuthorizationSessionPtr;
    }

}
