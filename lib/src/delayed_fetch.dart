import 'package:flutter/widgets.dart';

mixin DelayedFetchMixin<T, E extends StatefulWidget> on State<E> {
  int _start;

  int get extraTime => 200;

  Future<T> fetch();
  void onSuccess(T response);
  void onError(dynamic error);

  @override
  void initState() {
    super.initState();

    _start = DateTime.now().millisecondsSinceEpoch;

    this.fetch().then((res) {
      final _end = DateTime.now().millisecondsSinceEpoch;
      final td = ModalRoute.of(context).transitionDuration.inMilliseconds + this.extraTime;

      if (_end - _start >= td) {
        this.onSuccess(res);
      } else {
        Future.delayed(Duration(microseconds: td - (_end - _start))).then((_) => this.onSuccess(res));
      }
    }).catchError((error) => this.onError(error));
  }
}
