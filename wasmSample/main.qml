// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "generated_files/sieveOfEratosthenes.js" as wasmSOEModuleLoader;
import "sieveOfEratosthenes.js" as jsSOEModule;

Application {
	id: wasmSampleApp;

	property variant wasmSOE: wasmSOEModuleLoader.Module;
	property variant jsSOE: jsSOEModule;

	onCompleted: {
		const soeLimit = 10000000;

		this.doSieveOfEratosthenesTest("Wasm", this.wasmSOE, soeLimit);
		this.doSieveOfEratosthenesTest("JS", this.jsSOE, soeLimit);
	}

	function doSieveOfEratosthenesTest(moduleName, module, limit) {
		const start = new Date().getTime();
		const result = module.getPrimeNumberCount(limit);
		const end = new Date().getTime();

		log(`${moduleName} module found ${result} prime numbers with ${limit} limit in ${end - start} ms`);
	}
}
