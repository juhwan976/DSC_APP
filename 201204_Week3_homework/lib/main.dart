import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  _MainPage createState() {
    return _MainPage();
  }
}

class _MainPage extends State<MainPage> {
  int counter = 0;
  StreamController<int> _controller = new StreamController();

  Future _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    counter = prefs.getInt('counter') ?? 0;

    _controller.sink.add(counter);
  }

  Future _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('counter', ++counter);

    _controller.sink.add(counter);
  }

  Future _resetCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('counter', 0);

    _controller.sink.add(0);

    counter = 0;
  }

  @override
  initState() {
    super.initState();

    _loadData();
  }

  @override
  dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Stream Test Page'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: StreamBuilder(
                stream: _controller.stream,
                initialData: 0,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                      color: CupertinoColors.white,
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: CupertinoButton(
                    child: Text('누르면 1 증가'),
                    onPressed: () async {
                      await _incrementCounter();
                    },
                  ),
                ),
                Container(
                  child: CupertinoButton(
                    child: Text('누르면 리셋'),
                    onPressed: () async {
                      await _resetCounter();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
