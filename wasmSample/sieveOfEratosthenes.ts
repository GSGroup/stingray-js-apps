// © "Сifra" LLC, 2011-2022
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

export function getPrimeNumberCount(limit: number) : number
{
	const sieve = new Array<boolean>(limit + 1).fill(true);

	for (let i = 2; i * i <= limit; i++)
	{
		if (!sieve[i])
			continue;

		for (let j: number = i * 2; j <= limit; j += i)
			sieve[j] = false;
	}

	let counter = 0;
	for (let i = 2; i <= limit; i++)
		if (sieve[i])
			counter++;

	return counter;
}
