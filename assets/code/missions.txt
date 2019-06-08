import 'package:flutter/material.dart';
import '../webview.dart';
import '../api/api.dart';
import '../show_more.dart';
import 'package:page_transition/page_transition.dart';

class Missions extends StatefulWidget {
  @override
  _MissionsState createState() => _MissionsState();
}

class _MissionsState extends State<Missions> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              FutureBuilder<Map<String, dynamic>>(
                future: Api.getAllMissions(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (!snapshot.hasError && snapshot.hasData) {
                    var response = snapshot.data;
                    if (!response["isError"]) {
                      var missions = response["data"] ?? [];
                      return SliverPadding(
                        padding: const EdgeInsets.all(5.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return _renderMissionItem(missions, index);
                            },
                            childCount: missions.length,
                          ),
                        ),
                      );
                    } else {
                      return SliverFillRemaining(
                          child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(response["message"],
                                style: TextStyle(color: Colors.white)),
                            leading: Icon(Icons.cloud_off),
                          ),
                        ),
                      ));
                    }
                  } else {
                    return SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _renderMissionItem(dynamic missions, int index) {
    return InkWell(
        onTap: () {},
        splashColor: index.isEven ? Colors.cyan[600] : Colors.pink[600],
        child: Card(
          //   color: Colors.blueGrey,
          child: Column(
            children: <Widget>[
              /*Card(
                   margin: EdgeInsets.only(bottom: 5),
                   child: Container(
                    width: double.infinity,
                    color: index.isEven ?  Colors.pink[600] : Colors.cyan[600],
                    padding: EdgeInsets.all(7),
                    child: Center(child: Text("Mission ID: ${missions[index]["mission_id"]}" ,style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),),
                  ),
                ),*/

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Mission ID"),
                  Card(
                      elevation: 5,
                      color: index.isEven ? Colors.pink[600] : Colors.cyan[600],
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(
                              child: Text("${missions[index]["mission_id"]}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold))))),
                ],
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  "${missions[index]["mission_name"]}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900),
                ),
              ),
              missions[index]["description"] == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShowMore(
                          text: missions[index]["description"], maxHeight: 80)),
              /* Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${missions[index]["description"]}"),
            ),*/
              missions[index]["payload_ids"] == null
                  ? null
                  : Card(
                      child: ExpansionTile(
                        title: Text("Payload IDs"),
                        children: <Widget>[
                          //Best way to enable scrolling.
                          Builder(
                            builder: (c) {
                              List<Widget> payloadsIds = [];
                              for (int i = 0;
                                  i < missions[index]["payload_ids"].length;
                                  i++) {
                                payloadsIds.add(ListTile(
                                    title: Text(
                                        missions[index]["payload_ids"][i])));
                              }
                              return Column(children: payloadsIds);
                            },
                          ),
                        ],
                      ),
                    ),
              missions[index]["manufacturers"] == null
                  ? null
                  : Card(
                      child: ExpansionTile(
                        title: Text("Manufacturers"),
                        children: <Widget>[
                          //Best way to enable scrolling.
                          Builder(
                            builder: (c) {
                              List<Widget> manufacturers = [];
                              for (int i = 0;
                                  i < missions[index]["manufacturers"].length;
                                  i++) {
                                manufacturers.add(ListTile(
                                    title: Text(
                                        missions[index]["manufacturers"][i])));
                              }
                              return Column(children: manufacturers);
                            },
                          ),
                        ],
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  missions[index]["website"] == null
                      ? null
                      : InkWell(
                          onTap: () => Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.downToUp,
                                  child: WebView(
                                      url: missions[index]["website"],
                                      name: missions[index]["mission_name"]),
                                  duration: Duration(seconds: 1))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Website",
                                style: TextStyle(
                                    color: Colors.pink[400],
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                  missions[index]["twitter"] == null
                      ? null
                      : InkWell(
                          onTap: () => Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.downToUp,
                                  child: WebView(
                                      url: missions[index]["twitter"],
                                      name: missions[index]["mission_name"]),
                                  duration: Duration(seconds: 1))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Twitter",
                                style: TextStyle(
                                    color: Colors.cyan[300],
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                  missions[index]["wikipedia"] == null
                      ? null
                      : InkWell(
                          onTap: () => Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.downToUp,
                                  child: WebView(
                                      url: missions[index]["wikipedia"],
                                      name: missions[index]["mission_name"]),
                                  duration: Duration(seconds: 1))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Wikipedia",
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                ].where((w) => w != null).toList(),
              )
            ].where((w) => w != null).toList(),
          ),
        ));
  }
}
