import 'dart:core';
import 'package:events2/events.dart';


class MyClass extends EventEmitter {
  MyClass(){}
  void sendEvent(){
    this.emit('event2', 'a', 'b', 3, 'd');
  }
}

main() {
  MyClass my_class_obj = new MyClass();

  my_class_obj.on('event1', (a, String b, int c, d) {
    print('a = ' +
        a +
        ', b = ' +
        b +
        ', c = ' +
        c.toString() +
        ', d = ' +
        d.toString());
  });

  my_class_obj.once('event2', () {
    print('event2 ');
  });

  my_class_obj.on('event3', (a) {
    print('event3 ');
  });

  my_class_obj.on('event3', (a, b) {
    print('event322 ');
  });

  my_class_obj.emit('event1', 'a', 'b', null);
  my_class_obj.emit('event3', 'a', 'b', 3, 'd');
  my_class_obj.sendEvent();
  my_class_obj.off('event1');
}
