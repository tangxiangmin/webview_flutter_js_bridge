import 'package:flutter/material.dart';

import './webview.dart';

class EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('empty'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WebViewExample()),
            );
          },
          child: Text('to webview'),
        ),
      ),
    );
  }
}
