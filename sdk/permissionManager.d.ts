// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

/// <reference path="misc.d.ts" />
/// <reference path="signals.d.ts" />
/// <reference path="userAccountManager.d.ts" />

declare namespace stingray {

    /**
     * Listener that used to obtain permission result(0 if requested permissions is granted and 1 otherwise).
     */
    export interface IPermissionListenerPtr extends SmartPointer {
        GetPermission(): number;
        OnPermissionChanged(): Signal<[permission: number]>;
    }


    /**
     * {@link IFeature} representing a module that can be used to request generic permission.
     */
    export interface IPermissionManagerPtr extends IFeature {
        /**
         * Method that can be used to request generic permission.
         *
         * @param action - requested action name
         * @param authSession - authorization session which was obtained from {@link IUserAccountManagerPtr}
         * @param age - set this parameter to request permission for age-restricted content. null case to get permission for unconditionally pin-protected content
         */
        RequestGenericPermission(action: string, authSession: stingray.IAuthorizationSessionPtr, age: number | null): IPermissionListenerPtr;
    }

}
