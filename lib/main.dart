import 'package:flutter/cupertino.dart';

void main() => runApp(SpadCameroun());

class SpadCameroun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Cupertino App',
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Cupertino App Bar'),
        ),
        child: Center(child: Container(child: Text('Hello World'))),
      ),
    );
  }
}
