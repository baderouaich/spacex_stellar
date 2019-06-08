import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'about.dart';
import 'code.dart';
import 'tabs/capsules.dart';
import 'tabs/cores.dart';
import 'tabs/dragons.dart';
import 'tabs/history.dart';
import 'tabs/info.dart';
import 'tabs/landing_pads.dart';
import 'tabs/launch_pads.dart';
import 'tabs/launches.dart';
import 'tabs/missions.dart';
import 'tabs/payloads.dart';
import 'tabs/roadster.dart';
import 'tabs/rockets.dart';
import 'tabs/ships.dart';

void main() => runApp(MaterialApp(
    title: "SpaceX Stellar",
    home: SplashScreen(),
    theme: ThemeData(
      fontFamily: 'SF Pro Display',
      backgroundColor: Colors.blue[800],
      brightness: Brightness.dark,
      primaryColor: Colors
          .blueGrey[900], //Changing this will change the color of the TabBar
      accentColor: Colors.cyan[600], // displays when scroll limit
    ),
    debugShowCheckedModeBanner:
        false)); //Imp using MaterialApp otherwise collapsing toolbar will not work.

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rotate,
                child: MyApp(),
                duration: Duration(seconds: 1))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/splash.gif"),
          ),
          Text("SpaceX Stellar",
              style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontFamily: "monospace",
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LinearProgressIndicator(),
          ),
          SizedBox(height: 70)
        ],
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  List<TabItem> _tabs = [
    TabItem(
        tab: Tab(icon: Icon(Icons.card_travel), text: "Missions"),
        image: "missions.jpg"),
    TabItem(
        tab: Tab(icon: Icon(Icons.keyboard_capslock), text: "Capsules"),
        image: "capsules.jpg"),
    TabItem(
        tab: Tab(icon: Icon(Icons.compare), text: "Cores"), image: "cores.jpg"),
    TabItem(
        tab: Tab(icon: Icon(Icons.keyboard_arrow_up), text: "Dragons"),
        image: "dragons.jpg"),
    TabItem(
        tab: Tab(icon: Icon(Icons.pie_chart_outlined), text: "Landing Pads"),
        image: "landing_pads.jpg"),
    TabItem(
        tab: Tab(icon: Icon(Icons.launch), text: "Launches"),
        image: "launches.jpg"),
    TabItem(
        tab: Tab(icon: Icon(Icons.arrow_drop_up), text: "Launch Pads"),
        image: "launch_pads.jpg"),
    TabItem(
        tab: Tab(icon: Icon(Icons.last_page), text: "Payloads"),
        image: "payloads.jpg"),
    TabItem(
        tab: Tab(icon: Icon(Icons.rotate_90_degrees_ccw), text: "Rockets"),
        image: "rockets.jpg"),
    TabItem(
        tab: Tab(icon: Icon(Icons.directions_car), text: "Roadster"),
        image: "roadster.jpg"),
    TabItem(
        tab: Tab(icon: Icon(Icons.brightness_auto), text: "Ships"),
        image: "ships.jpg"),
    TabItem(
        tab: Tab(icon: Icon(Icons.history), text: "History"),
        image: "history.jpg"),
    TabItem(
        tab: Tab(icon: Icon(Icons.info_outline), text: "Info"),
        image: "info.jpg"),
  ];

  var pages = [
    Missions(),
    Capsules(),
    Cores(),
    Dragons(),
    LandingPads(),
    Launches(),
    LaunchPads(),
    Payloads(),
    Rockets(),
    Roadster(),
    Ships(),
    History(),
    Info()
  ];

  int i = 0; //default initial tabs index
  TabController _tabsController;

  @override
  void initState() {
    super.initState();
    _tabsController =
        TabController(length: pages.length, vsync: this, initialIndex: i)
          ..addListener(() {
            setState(() => i = _tabsController.index);
            _tabsController.animateTo(i);
          });
  }

  @override
  void dispose() {
    _tabsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: DefaultTabController(
          length: _tabs.length,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  child: SliverSafeArea(
                    top: false,
                    sliver: SliverAppBar(
                        expandedHeight:
                            MediaQuery.of(context).size.height / 2.4,
                        title: const Text('SpaceX Stellar'),
                        actions: <Widget>[
                          IconButton(
                              icon: Icon(Icons.code, color: Colors.white),
                              onPressed: () => Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.upToDown,
                                      child: Code(),
                                      duration: Duration(seconds: 1)))),
                          IconButton(
                              icon: Icon(Icons.details, color: Colors.white),
                              onPressed: () => Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.upToDown,
                                      child: About(),
                                      duration: Duration(milliseconds: 750)))),
                        ],
                        floating: true,
                        pinned: true,
                        snap: false,
                        primary: true,
                        flexibleSpace: FlexibleSpaceBar(
                            background: Image.asset(
                          "assets/tabs/${_tabs[i].image}",
                          fit: BoxFit.cover,
                        )),
                        forceElevated: innerBoxIsScrolled,
                        bottom: TabBar(
                          isScrollable: true,
                          tabs: _tabs.map((tabItem) => tabItem.tab).toList(),
                          indicatorColor: Colors.white,
                          labelColor: Colors.white,
                          controller: _tabsController,
                        )),
                  ),
                ),
              ];
            },
            body: TabBarView(children: pages, controller: _tabsController),
          ),
        ),
        drawer: Drawer(
          child: Scrollbar(
            child: ListView.builder(
              itemCount: _tabs.length,
              itemBuilder: (c, index) {
                return ListTile(
                  leading: _tabs[index].tab.icon,
                  title: Text(_tabs[index].tab.text),
                  selected: index == i,
                  onTap: () {
                    _tabsController.animateTo(index);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TabItem {
  String image;
  Tab tab;
  TabItem({this.tab, this.image});
}
