import buffer from '@ohos.buffer';
import StreamSearch  from '@Sett/ohos-streamsearch'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(()=>{
          const needle = buffer.from('\r\n');

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
            ss.push(buffer.from(chunk));
        })
    }
    .height('100%')
    .width('100%')
  }
}