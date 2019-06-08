import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;

class WebView extends StatefulWidget {
  final String url, name;
  WebView({this.url, this.name});
  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      appBar: AppBar(
          title: Text(widget.name,
              style: TextStyle(fontSize: 16, color: Colors.white)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_downward, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
          automaticallyImplyLeading: false // Will hide leading back arrow.
          ),
      body: webview.WebView(
        key: UniqueKey(),
        javascriptMode: webview.JavascriptMode.unrestricted,
        initialUrl: widget.url,
      ),
    );
  }
}
