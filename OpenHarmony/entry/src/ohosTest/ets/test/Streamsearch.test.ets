import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import StreamSearch from 'ohos_streamsearch'
import { buffer } from '@kit.ArkTS';

export default function StreamSearchTest() {
  describe('StreamSearch', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('StreamSearch1', 0, (done:Function) => {
      let needle = '\r\n';
      let chunks = [
        'foo',
        ' bar',
        '\r',
        '\n',
        'baz, hello\r',
        '\n world.',
        '\r\n Node.JS rules!!\r\n\r\n',
      ];
      let expects = [
        [false, 'foo'],
        [false, ' bar'],
        [true, null],
        [false, 'baz, hello'],
        [true, null],
        [false, ' world.'],
        [true, null],
        [true, ' Node.JS rules!!'],
        [true, ''],
      ];

      const results: ((string | boolean)[] | (boolean | null)[])[] = [];
      const ss = new StreamSearch(buffer.from(needle),
        (isMatch, data, start, end) => {
          if (data) {
            let res = data.toString('latin1', start, end);
            results.push([isMatch, res]);
          } else {
            let res = null;
            results.push([isMatch, res]);
          }
        });

      for (const chunk of chunks) {
        ss.push(buffer.from(chunk));
      }
      setTimeout(() => {
        expect(JSON.stringify(results)).assertEqual(JSON.stringify(expects));
        done();
      }, 2000);
    })

    it('StreamSearch2', 1, (done:Function) => {
      let needle = '---foobarbaz';
      let chunks = [
        '---foobarbaz',
        'asdf',
        '\r\n',
        '---foobarba',
        '---foobar',
        'ba',
        '\r\n---foobarbaz--\r\n',
      ];
      let expects = [
        [true, null],
        [false, 'asdf'],
        [false, '\r\n'],
        [false, '---foobarba'],
        [false, '---foobarba'],
        [true, '\r\n'],
        [false, '--\r\n'],
      ];
      const results: ((string | boolean)[] | (boolean | null)[])[] = [];
      const ss = new StreamSearch(buffer.from(needle),
        (isMatch, data, start, end) => {
          if (data) {
            let res = data.toString('latin1', start, end);
            results.push([isMatch, res]);
          } else {
            let res = null;
            results.push([isMatch, res]);
          }
        });

      for (const chunk of chunks) {
        ss.push(buffer.from(chunk));
      }
      setTimeout(() => {
        expect(JSON.stringify(results)).assertEqual(JSON.stringify(expects));
        done();
      }, 2000);
    })
  })
}