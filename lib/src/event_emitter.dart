import 'dart:async';
import 'dart:core';

class EventEmitter {
  /**
   * Mapping of events to a list of event handlers
   */
  Map<String, List<Function>> _events;

  /**
   * Mapping of events to a list of one-time event handlers
   */
  Map<String, List<Function>> _eventsOnce;

  /**
   * Typical constructor
   */
  EventEmitter() {
    this._events = new Map<String, List<Function>>();
    this._eventsOnce = new Map<String, List<Function>>();
  }

  callback(Function func, [arg0, arg1, arg2, arg3, arg4, arg5]) {
    String arguments = func.runtimeType.toString().split(' => ')[0];
    if (arguments.length > 3) {
      String args = arguments.substring(1, arguments.length - 1);
      args = args.replaceAll(RegExp("<(.*)>"), "");
      int argc = args.split(', ').length;
      switch (argc) {
        case 1:
          func(arg0 ?? null);
          break;
        case 2:
          func(arg0 ?? null, arg1 ?? null);
          break;
        case 3:
          func(arg0 ?? null, arg1 ?? null, arg2 ?? null);
          break;
        case 4:
          func(arg0 ?? null, arg1 ?? null, arg2 ?? null, arg3 ?? null);
          break;
        case 5:
          func(arg0 ?? null, arg1 ?? null, arg2 ?? null, arg3 ?? null,
              arg4 ?? null);
          break;
        case 5:
          func(arg0 ?? null, arg1 ?? null, arg2 ?? null, arg3 ?? null,
              arg4 ?? null, arg5 ?? null);
          break;
      }
    } else {
      func();
    }
  }

  Future<dynamic> callbackAsFuture(Function func,
      [arg0, arg1, arg2, arg3, arg4, arg5]) async {
    Completer completer = new Completer();
    try {
      String arguments = func.runtimeType.toString().split(' => ')[0];
      var result;
      if (arguments.length > 3) {
        String args = arguments.substring(1, arguments.length - 1);
        args = args.replaceAll(RegExp("<(.*)>"), "");
        int argc = args.split(', ').length;
        switch (argc) {
          case 1:
            result = await func(arg0 ?? null);
            break;
          case 2:
            result = await func(arg0 ?? null, arg1 ?? null);
            break;
          case 3:
            result = await func(arg0 ?? null, arg1 ?? null, arg2 ?? null);
            break;
          case 4:
            result = await func(
                arg0 ?? null, arg1 ?? null, arg2 ?? null, arg3 ?? null);
            break;
          case 5:
            result = await func(arg0 ?? null, arg1 ?? null, arg2 ?? null,
                arg3 ?? null, arg4 ?? null);
            break;
          case 5:
            result = await func(arg0 ?? null, arg1 ?? null, arg2 ?? null,
                arg3 ?? null, arg4 ?? null, arg5 ?? null);
            break;
        }
      } else {
        result = await func();
      }
      completer.complete(result);
    } catch (error) {
      completer.completeError(error);
    }
    return completer;
  }

  /**
   * This function triggers all the handlers currently listening
   * to `event` and passes them `data`.
   *
   * @param String event - The event to trigger
   * @param [args] - The variable numbers of arguments to send to each handler
   * @return void
   */
  void emit(String event, [arg0, arg1, arg2, arg3, arg4, arg5]) {
    this._events[event]?.toList()?.forEach((Function func) {
      callback(func, arg0, arg1, arg2, arg3, arg4, arg5);
    });
    this._eventsOnce.remove(event)?.forEach((Function func) {
      callback(func, arg0, arg1, arg2, arg3, arg4, arg5);
    });
  }

  /**
   * This function triggers all the handlers currently listening
   * to `event` and passes them `data`.
   *
   * @param String event - The event to trigger
   * @param [args] - The variable numbers of arguments to send to each handler
   * @return Future<dynamic>
   */
  Future<dynamic> emitAsFuture(String event,
      [arg0, arg1, arg2, arg3, arg4, arg5]) async {
    this._events[event]?.toList()?.forEach((Function func) async {
      return await callbackAsFuture(func, arg0, arg1, arg2, arg3, arg4, arg5);
    });
    this._eventsOnce.remove(event)?.forEach((Function func) async {
      return await callbackAsFuture(func, arg0, arg1, arg2, arg3, arg4, arg5);
    });
  }

  /**
   * This function binds the `handler` as a listener to the `event`
   *
   * @param String event     - The event to add the handler to
   * @param Function handler - The handler to bind to the event
   * @return void
   */
  void on(String event, Function handler) {
    this._events.putIfAbsent(event, () => new List<Function>());
    this._events[event].add(handler);
  }

  /**
   * This function binds the `handler` as a listener to the first
   * occurrence of the `event`. When `handler` is called once,
   * it is removed.
   *
   * @param String event     - The event to add the handler to
   * @param Function handler - The handler to bind to the event
   * @return void
   */
  void once(String event, Function handler) {
    this._eventsOnce.putIfAbsent(event, () => new List<Function>());
    this._eventsOnce[event].add(handler);
  }

  /**
   * This function attempts to unbind the `handler` from the `event`
   *
   * @param String event     - The event to remove the handler from
   * @param Function handler - The handler to remove
   * @return void
   */
  void remove(String event, Function handler) {
    this._events[event]?.removeWhere((item) => item == handler);
    this._eventsOnce[event]?.removeWhere((item) => item == handler);
  }

  /**
   * This function attempts to unbind all the `handler` from the `event`
   *
   * @param String event     - The event to remove the handler from
   * @return void
   */
  void off(String event) {
    this._events[event] = new List<Function>();
    this._eventsOnce[event] = new List<Function>();
  }

  /**
   * This function unbinds all the handlers for all the events
   *
   * @return void
   */
  void clearListeners() {
    this._events = new Map<String, List<Function>>();
    this._eventsOnce = new Map<String, List<Function>>();
  }

  /**
   * Return function list named `event`.
   *
   * @return List<Function>
   */
  List<dynamic> listeners(event) {
    var list = [];
    list += this._events[event] ?? [];
    list += this._eventsOnce[event] ?? [];
    return list;
  }
}
