Description
===========

streamsearch is a module for [node.js](http://nodejs.org/) that allows searching a stream using the Boyer-Moore-Horspool algorithm.

ohos-streamsearch is a ported version of streamsearch on Node.js for OpenHarmony

This module is based heavily on the Streaming Boyer-Moore-Horspool C++ implementation by Hongli Lai [here](https://github.com/FooBarWidget/boyer-moore-horspool).


Requirements
============
|Module Name|Platform|Environment|
|--|--|--|
|ohos-streamsearch|OpenHarmony|DevEco Studio: 5.0.1 Release(5.0.5.315), SDK: API13(5.0.1.111) or newer|
|streamsearch|Node.js|Node.js v10.0.0 or newer|

Installation
============
- OpenHarmony (ohos-streamsearch):
  ```js
    ohpm install @sett/ohos-streamsearch
  ```
- Node.js (streamsearch):
  ```js
    npm install streamsearch
  ```

Example
=======

```js
  import StreamSearch from '@sett/ohos-streamsearch'; // OpenHarmony
// 或 const StreamSearch = require('streamsearch'); // Node.js
  import buffer from '@ohos.buffer'; // OpenHarmony only

  const needle = buffer.from('\r\n'); // OpenHarmony
  // 或  const needle = Buffer.from('\r\n'); // Node.js

  const ss = new StreamSearch(needle, (isMatch, data, start, end) => {
    if (data)
      console.log('data: ' + data.toString('latin1', start, end));
    if (isMatch)
      console.log('match!');
  });

  const chunks = [
    'foo',
    ' bar',
    '\r',
    '\n',
    'baz, hello\r',
    '\n world.',
    '\r\n Node.JS rules!!\r\n\r\n',
  ];

  for (const chunk of chunks)
    ss.push(buffer.from(chunk)); // 在 Node.js 中也使用 Buffer.from

  // output:
  //
  // data: 'foo'
  // data: ' bar'
  // match!
  // data: 'baz, hello'
  // match!
  // data: ' world.'
  // match!
  // data: ' Node.JS rules!!'
  // match!
  // data: ''
  // match!
```


API
===

Properties
----------

* **maxMatches** - < _integer_ > - The maximum number of matches. Defaults to `Infinity`.

* **matches** - < _integer_ > - The current match count.


Functions
---------

* **(constructor)**(< _mixed_ >needle, < _function_ >callback) - Creates and returns a new instance for searching for a _Buffer_ or _string_ `needle`. `callback` is called any time there is non-matching data and/or there is a needle match. `callback` will be called with the following arguments:

  1. `isMatch` - _boolean_ - Indicates whether a match has been found

  2. `data` - _mixed_ - If set, this contains data that did not match the needle.

  3. `start` - _integer_ - The index in `data` where the non-matching data begins (inclusive).

  4. `end` - _integer_ - The index in `data` where the non-matching data ends (exclusive).

  5. `isSafeData` - _boolean_ - Indicates if it is safe to store a reference to `data` (e.g. as-is or via `data.slice()`) or not, as in some cases `data` may point to a Buffer whose contents change over time.

* **destroy**() - _(void)_ - Emits any last remaining unmatched data that may still be buffered and then resets internal state.

* **push**(< _Buffer_ >chunk) - _integer_ - Processes `chunk`, searching for a match. The return value is the last processed index in `chunk` + 1.

* **reset**() - _(void)_ - Resets internal state. Useful for when you wish to start searching a new/different stream for example.

