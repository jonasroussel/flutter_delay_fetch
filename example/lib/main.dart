import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_delay_fetch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FetchPage()));
        },
        child: Icon(Icons.cloud_download),
      ),
    );
  }
}

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
  void onError(error) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch delayed page'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _todos?.length ?? 0,
              itemBuilder: (context, index) => ListTile(
                leading: Text(
                  'id: ${_todos[index].id}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                title: Text(
                  _todos[index].title,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  _todos[index].body,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
    );
  }
}

class TodoModel {
  int userId;
  int id;
  String title;
  String body;

  TodoModel({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: (json['body'] as String).replaceAll('\n', ' '),
    );
  }
}
