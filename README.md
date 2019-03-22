[![pub package](https://img.shields.io/pub/v/events2.svg)](https://pub.dartlang.org/packages/events2)

# dart-events
Event emitter for dart2.

## Usage
```dart

import 'package:events2/events2.dart';

main() {
  EventEmitter event_emitter = new EventEmitter();

  event_emitter.on('event1', (arg0, String arg1, int arg2, arg3) {
    print('arg0 = ' + arg0 + ', arg1 = ' + arg1 + ', arg2 = ' + arg2.toString() + ', arg3 = ' + arg3.toString());
  });

  event_emitter.once('event2', () {
    print('event2 ');
  });
  
  event_emitter.emit('event1', 'a', 'b', null);
  event_emitter.emit('event2');
}

```
