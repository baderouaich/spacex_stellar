import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

class Code extends StatefulWidget {
  @override
  _CodeState createState() => _CodeState();
}

class _CodeState extends State<Code> with SingleTickerProviderStateMixin {
  int i = 0; //default index
  TabController _tabsController;
  static SyntaxTheme selectedSyntaxTheme =
      SyntaxTheme.dracula(); // default syntax theme
  List<TabItem> _tabItems = [
    TabItem(
        title: "main.dart",
        codePath: "assets/code/main.txt",
        syntaxTheme: selectedSyntaxTheme),
    TabItem(
        title: "capsules.dart",
        codePath: "assets/code/capsules.txt",
        syntaxTheme: selectedSyntaxTheme),
    TabItem(
        title: "cores.dart",
        codePath: "assets/code/cores.txt",
        syntaxTheme: selectedSyntaxTheme),
    TabItem(
        title: "dragons.dart",
        codePath: "assets/code/dragons.txt",
        syntaxTheme: selectedSyntaxTheme),
    TabItem(
        title: "history.dart",
        codePath: "assets/code/history.txt",
        syntaxTheme: selectedSyntaxTheme),
    TabItem(
        title: "info.dart",
        codePath: "assets/code/info.txt",
        syntaxTheme: selectedSyntaxTheme),
    TabItem(
        title: "landing_pads.dart",
        codePath: "assets/code/landing_pads.txt",
        syntaxTheme: selectedSyntaxTheme),
    TabItem(
        title: "launch_pads.dart",
        codePath: "assets/code/launch_pads.txt",
        syntaxTheme: selectedSyntaxTheme),
    TabItem(
        title: "launches.dart",
        codePath: "assets/code/launches.txt",
        syntaxTheme: selectedSyntaxTheme),
    TabItem(
        title: "missions.dart",
        codePath: "assets/code/missions.txt",
        syntaxTheme: selectedSyntaxTheme),
    TabItem(
        title: "payloads.dart",
        codePath: "assets/code/payloads.txt",
        syntaxTheme: selectedSyntaxTheme),
    TabItem(
        title: "roadster.dart",
        codePath: "assets/code/roadster.txt",
        syntaxTheme: selectedSyntaxTheme),
    TabItem(
        title: "rockets.dart",
        codePath: "assets/code/rockets.txt",
        syntaxTheme: selectedSyntaxTheme),
    TabItem(
        title: "ships.dart",
        codePath: "assets/code/ships.txt",
        syntaxTheme: selectedSyntaxTheme),
    TabItem(
        title: "api.dart",
        codePath: "assets/code/api.txt",
        syntaxTheme: selectedSyntaxTheme),
  ];

  List<Tab> _tabs = [];
  List<CodeViewTab> _codeViews = [];
  @override
  void initState() {
    super.initState();
    for (var tabItem in _tabItems)
      _tabs.add(Tab(text: tabItem.title, icon: Icon(Icons.code)));
    for (var tabItem in _tabItems)
      _codeViews.add(CodeViewTab(
          codePath: tabItem.codePath, syntaxTheme: tabItem.syntaxTheme));

    _tabsController =
        TabController(length: _tabs.length, vsync: this, initialIndex: 0)
          ..addListener(() {
            setState(() => i = _tabsController.index);
          });
  }

  @override
  void dispose() {
    _tabsController.dispose();
    super.dispose();
  }

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isRefreshingSyntaxTheme = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text("Code"),
          bottom: TabBar(
            isScrollable: true,
            tabs: _tabs,
            indicatorColor: Colors.white,
            controller: _tabsController,
            labelColor: Colors.white,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.content_copy, color: Colors.white),
              onPressed: () async {
                Clipboard.setData(new ClipboardData(
                        text: await DefaultAssetBundle.of(context)
                            .loadString(_tabItems[i].codePath)))
                    .then((_) {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: new Text("Copied to Clipboard")));
                }, onError: (e) {
                  _scaffoldKey.currentState
                      .showSnackBar(SnackBar(content: new Text("$e")));
                });
              },
            ),
            PopupMenuButton<SyntaxTheme>(
              icon: Icon(Icons.settings),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<SyntaxTheme>>[
                    PopupMenuItem<SyntaxTheme>(
                        child: SwitchListTile(
                      title: Text("Zoom"),
                      value: _codeViews[i].withZoom,
                      onChanged: (v) {
                        //enable/disable zoom
                        setState(() {
                          _codeViews[i].withZoom = v;
                          isRefreshingSyntaxTheme = true;
                        });
                        Timer(Duration(seconds: 1), () {
                          setState(() => isRefreshingSyntaxTheme = false);
                        });
                      },
                    )),
                    PopupMenuItem<SyntaxTheme>(
                        child: SwitchListTile(
                      title: Text("Lines Count"),
                      value: _codeViews[i].withLinesCount,
                      onChanged: (v) {
                        //enable/disable zoom
                        setState(() {
                          _codeViews[i].withLinesCount = v;
                          isRefreshingSyntaxTheme = true;
                        });
                        Timer(Duration(seconds: 1), () {
                          setState(() => isRefreshingSyntaxTheme = false);
                        });
                      },
                    )),
                  ],
            ),
            PopupMenuButton<SyntaxTheme>(
              icon: Icon(Icons.color_lens),
              onSelected: (SyntaxTheme v) {
                //setState(()=> _codeViews[i].syntaxTheme = v);
                setState(() {
                  _codeViews[i].syntaxTheme = v;
                  isRefreshingSyntaxTheme = true;
                });
                Timer(Duration(seconds: 1), () {
                  setState(() => isRefreshingSyntaxTheme = false);
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<SyntaxTheme>>[
                    PopupMenuItem<SyntaxTheme>(
                      value: SyntaxTheme.dracula(),
                      child: Text('Dracula'),
                    ),
                    PopupMenuItem<SyntaxTheme>(
                      value: SyntaxTheme.standard(),
                      child: Text('Standard'),
                    ),
                    PopupMenuItem<SyntaxTheme>(
                      value: SyntaxTheme.ayuDark(),
                      child: Text('Ayu Dark'),
                    ),
                    PopupMenuItem<SyntaxTheme>(
                      value: SyntaxTheme.ayuLight(),
                      child: Text('Ayu Light'),
                    ),
                    PopupMenuItem<SyntaxTheme>(
                      value: SyntaxTheme.gravityDark(),
                      child: Text('Gravity Dark'),
                    ),
                    PopupMenuItem<SyntaxTheme>(
                      value: SyntaxTheme.gravityLight(),
                      child: Text('Gravity Light'),
                    ),
                    PopupMenuItem<SyntaxTheme>(
                      value: SyntaxTheme.monokaiSublime(),
                      child: Text('Monokai Sublime'),
                    ),
                    PopupMenuItem<SyntaxTheme>(
                      value: SyntaxTheme.obsidian(),
                      child: Text('Obsidian'),
                    ),
                    PopupMenuItem<SyntaxTheme>(
                      value: SyntaxTheme.oceanSunset(),
                      child: Text('Ocean Sunset'),
                    ),
                  ],
            ),
            IconButton(
              icon: Icon(Icons.arrow_upward, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
          automaticallyImplyLeading: false),
      body: isRefreshingSyntaxTheme
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 5),
                //Text("Applying Theme...",style: _codeViews[i].syntaxTheme.baseStyle)
              ],
            ))
          : TabBarView(children: _codeViews, controller: _tabsController),
    );
  }
}

class CodeViewTab extends StatefulWidget {
  final String codePath;
  bool withZoom;
  bool withLinesCount;
  SyntaxTheme syntaxTheme;

  CodeViewTab({this.syntaxTheme, this.codePath});
  @override
  _CodeViewTabState createState() => _CodeViewTabState();
}

class _CodeViewTabState extends State<CodeViewTab> {
  Future<String> _loadCodeContent() async =>
      await DefaultAssetBundle.of(context).loadString(widget.codePath);

  @override
  Widget build(BuildContext context) {
    widget.withZoom ??= true;
    widget.withLinesCount ??= true;
    return Scaffold(
      backgroundColor: widget.syntaxTheme.backgroundColor,
      body: FutureBuilder<String>(
        future: _loadCodeContent(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (!snapshot.hasError && snapshot.hasData) {
            return SyntaxView(
              code: snapshot.data,
              syntax: Syntax.DART,
              syntaxTheme: widget.syntaxTheme,
              withZoom: widget.withZoom,
              withLinesCount: widget.withLinesCount,
            );
          } else if (snapshot.hasError) {
            return Center(
                child: ListTile(
              leading: Icon(Icons.error_outline),
              title: Text("Error Occurred"),
              subtitle: Text(snapshot.error.toString()),
            ));
          }
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 5),
              Text("Loading...", style: widget.syntaxTheme.baseStyle)
            ],
          ));
        },
      ),
    );
  }
}

class TabItem {
  String title, codePath;
  SyntaxTheme syntaxTheme;
  TabItem({this.syntaxTheme, this.title, this.codePath});
}
