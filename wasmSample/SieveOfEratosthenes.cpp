// © "Сifra" LLC, 2011-2025
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

#include <emscripten/bind.h>

std::size_t GetPrimeNumberCount(std::size_t limit)
{
	std::vector<bool> sieve(limit + 1, true);

	for (std::size_t i = 2; i * i <= limit; i++)
	{
		if (!sieve[i])
			continue;

		for (std::size_t j = i * 2; j <= limit; j += i)
			sieve[j] = false;
	}

	size_t counter = 0;
	for (std::size_t i = 2; i <= limit; i++)
		if (sieve[i])
			counter++;

	return counter;
}

using namespace emscripten;

EMSCRIPTEN_BINDINGS(sieveOfEratosthenes)
{
	function("getPrimeNumberCount", &GetPrimeNumberCount);
}
