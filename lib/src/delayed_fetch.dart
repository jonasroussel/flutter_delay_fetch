import 'package:flutter/widgets.dart';

mixin DelayedFetchMixin<T, E extends StatefulWidget> on State<E> {
  int _start;

  Future<T> fetch();
  void onSuccess(T response);
  void onError(dynamic error);

  @override
  void initState() {
    super.initState();

    _start = DateTime.now().millisecondsSinceEpoch;

    this.fetch().then((res) {
      final _end = DateTime.now().millisecondsSinceEpoch;
      final td = ModalRoute.of(context).transitionDuration.inMilliseconds + 200;

      print(td);
      print(_end - _start);
      print(td - (_end - _start));

      if (_end - _start >= td) {
        this.onSuccess(res);
      } else {
        Future.delayed(Duration(microseconds: td - (_end - _start))).then((_) => this.onSuccess(res));
      }
    }).catchError((error) => this.onError(error));
  }
}
