import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spacex_stellar/webview.dart';
import '../api/api.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
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
                future: Api.getInfo(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (!snapshot.hasError && snapshot.hasData) {
                    var response = snapshot.data;
                    if (!response["isError"]) {
                      var info = response["data"];
                      var infoList = [
                        ListTile(
                          leading: Text("Name:"),
                          title: Text(info["name"]),
                        ),
                        ListTile(
                          leading: Text("Founder:"),
                          title: Text(info["founder"]),
                        ),
                        ListTile(
                          leading: Text("Founded:"),
                          title: Text(info["founded"].toString()),
                        ),
                        ListTile(
                          leading: Text("Employees:"),
                          title: Text(info["employees"].toString()),
                        ),
                        ListTile(
                          leading: Text("Vehicles:"),
                          title: Text(info["vehicles"].toString()),
                        ),
                        ListTile(
                          leading: Text("Launch Sites:"),
                          title: Text(info["launch_sites"].toString()),
                        ),
                        ListTile(
                          leading: Text("Test Sites:"),
                          title: Text(info["test_sites"].toString()),
                        ),
                        ListTile(
                          leading: Text("Ceo:"),
                          title: Text(info["ceo"]),
                        ),
                        ListTile(
                          leading: Text("Cto:"),
                          title: Text(info["cto"]),
                        ),
                        ListTile(
                          leading: Text("Coo:"),
                          title: Text(info["coo"]),
                        ),
                        ListTile(
                          leading: Text("Cto Propulsion:"),
                          title: Text(info["cto_propulsion"]),
                        ),
                        ListTile(
                          leading: Text("Valuation:"),
                          title: Text("${info["valuation"].toString()}\$"),
                        ),
                        ListTile(
                          title: Text("Summary:"),
                          subtitle: Text(info["summary"]),
                        ),
                        SizedBox(height: 10),
                        ListTile(
                          title: Text("Head Quarters"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  "Address: ${info["headquarters"]["address"]}"),
                              Text("City: ${info["headquarters"]["city"]}"),
                              Text("State: ${info["headquarters"]["state"]}"),
                            ],
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Links"),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Website",
                                      style:
                                          TextStyle(color: Colors.pink[600])),
                                ),
                                onTap: () => Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.downToUp,
                                        child: WebView(
                                            url: info["links"]["website"],
                                            name: info["links"]["website"]),
                                        duration: Duration(seconds: 1))),
                              ),
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Flickr",
                                      style:
                                          TextStyle(color: Colors.blue[600])),
                                ),
                                onTap: () => Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.downToUp,
                                        child: WebView(
                                            url: info["links"]["flickr"],
                                            name: info["links"]["flickr"]),
                                        duration: Duration(seconds: 1))),
                              ),
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Twitter",
                                      style:
                                          TextStyle(color: Colors.cyan[600])),
                                ),
                                onTap: () => Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.downToUp,
                                        child: WebView(
                                            url: info["links"]["twitter"],
                                            name: info["links"]["twitter"]),
                                        duration: Duration(seconds: 1))),
                              ),
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Elon Twitter",
                                      style:
                                          TextStyle(color: Colors.green[600])),
                                ),
                                onTap: () => Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.downToUp,
                                        child: WebView(
                                            url: info["links"]["elon_twitter"],
                                            name: info["links"]
                                                ["elon_twitter"]),
                                        duration: Duration(seconds: 1))),
                              ),
                            ],
                          ),
                        ),
                      ].where((w) => w != null).toList();

                      return SliverPadding(
                        padding: const EdgeInsets.all(5.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return infoList[index];
                            },
                            childCount: infoList.length,
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
}
