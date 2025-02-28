class UpdateObservable {
  final _subscribers = <Function>[];

  void subscribe(Function callback) {
    _subscribers.add(callback);
  }

  void unsubscribe(Function callback) {
    _subscribers.remove(callback);
  }

  void notify() {
    for (final subscriber in _subscribers) {
      subscriber();
    }
  }
}
