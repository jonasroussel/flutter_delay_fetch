# Flutter Delay Fetch
[![pub package](https://img.shields.io/pub/v/flutter_delay_fetch.svg)](https://pub.dev/packages/flutter_delay_fetch)

A flutter plugin to put a delay between fetch request and parsing data with a mixin,
during page route navigation to avoid laggy animations.

## Usage

### Import
```dart
import 'package:flutter_delay_fetch/flutter_delay_fetch.dart';
```

### Basic Page

```dart
class FetchPage extends StatefulWidget {
  @override
  _FetchPageState createState() => _FetchPageState();
}

class _FetchPageState extends State<FetchPage> with DelayedFetchMixin<Response, FetchPage> {
  bool _loading = true;
  List<TodoModel> _todos;

  @override
  Future<Response> fetch() async => await Dio().get('https://jsonplaceholder.typicode.com/posts');

  @override
  void onSuccess(Response response) {
    setState(() {
      _todos = (response.data as List).map((data) => TodoModel.fromJson(data)).toList();
      _loading = false;
    });
  }

  @override
  void onError(error) { ... }

  @override
  Widget build(BuildContext context) { ... }
}
```
