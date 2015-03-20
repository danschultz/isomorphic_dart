library async;

import 'dart:async';
import 'package:frappe/frappe.dart';

class Subject<T> implements StreamController<T> {
  final StreamController<T> _controller;

  Subject._(this._controller);

  factory Subject() => new Subject._(new StreamController());

  factory Subject.broadcast() => new Subject._(new StreamController.broadcast());

  EventStream<T> get stream => new EventStream(_controller.stream);
  StreamSink<T> get sink => _controller.sink;
  bool get isClosed => _controller.isClosed;
  bool get isPaused => _controller.isPaused;
  bool get hasListener => _controller.hasListener;
  Future get done => _controller.done;

  Future close() => _controller.close();

  void add(T event) => _controller.add(event);

  Future addStream(Stream<T> source, {bool cancelOnError}) => _controller.addStream(source, cancelOnError: cancelOnError);

  void addError(Object error, [StackTrace stackTrace]) => _controller.addError(error, stackTrace);

  call(T event) => add(event);

}