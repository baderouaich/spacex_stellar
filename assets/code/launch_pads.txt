import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../webview.dart';
import '../api/api.dart';

class LaunchPads extends StatefulWidget {
  @override
  _LaunchPadsState createState() => _LaunchPadsState();
}

class _LaunchPadsState extends State<LaunchPads> {
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
                future: Api.getAllLaunchPads(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (!snapshot.hasError && snapshot.hasData) {
                    var response = snapshot.data;
                    if (!response["isError"]) {
                      var launchPads = response["data"] ?? [];
                      return SliverPadding(
                        padding: const EdgeInsets.all(5.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return _renderLaunchPadItem(launchPads, index);
                            },
                            childCount: launchPads.length,
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

  Widget _renderLaunchPadItem(dynamic launchPads, int index) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Card(
                  elevation: 5,
                  color: launchPads[index]["status"] == "active"
                      ? Colors.green
                      : launchPads[index]["status"] == "destroyed"
                          ? Colors.blueGrey
                          : launchPads[index]["status"] == "retired"
                              ? Colors.pink[600]
                              : Colors.cyan[600],
                  child: Padding(
                      padding: EdgeInsets.all(3),
                      child: Text(launchPads[index]["status"])),
                ),
                launchPads[index]["site_id"] == null
                    ? null
                    : Text("Site ID:  ${launchPads[index]["site_id"]}"),
              ].where((w) => w != null).toList(),
            ),
            Divider(),
            launchPads[index]["site_name_long"] == null
                ? null
                : ListTile(
                    title: Text("Site Name"),
                    subtitle: Text(launchPads[index]["site_name_long"]),
                  ),
            Divider(),
            launchPads[index]["details"] == null
                ? null
                : ListTile(
                    title: Text("Details"),
                    subtitle: Text(launchPads[index]["details"]),
                  ),
            Divider(),
            launchPads[index]["location"] == null
                ? null
                : ListTile(
                    title: Text("Location"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        launchPads[index]["location"]["name"] == null
                            ? null
                            : Text(
                                "Name:  ${launchPads[index]["location"]["name"]}"),
                        launchPads[index]["location"]["region"] == null
                            ? null
                            : Text(
                                "Region:  ${launchPads[index]["location"]["region"]}"),
                        launchPads[index]["location"]["latitude"] == null
                            ? null
                            : Text(
                                "Latitude:  ${launchPads[index]["location"]["latitude"].toString()}"),
                        launchPads[index]["location"]["longitude"] == null
                            ? null
                            : Text(
                                "Longitude:  ${launchPads[index]["location"]["longitude"].toString()}"),
                      ].where((w) => w != null).toList(),
                    ),
                  ),
            Divider(),
            launchPads[index]["vehicles_launched"].isEmpty
                ? null
                : Card(
                    child: ExpansionTile(
                      title: Text("Vehicles Launched",
                          style: TextStyle(fontSize: 13)),
                      children: <Widget>[
                        //Best way to enable scrolling.
                        Builder(
                          builder: (c) {
                            List<Widget> vehiclesLaunched = [];
                            for (int i = 0;
                                i <
                                    launchPads[index]["vehicles_launched"]
                                        .length;
                                i++) {
                              vehiclesLaunched.add(
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(launchPads[index]
                                      ["vehicles_launched"][i]),
                                ),
                              );
                            }
                            return Column(children: vehiclesLaunched);
                          },
                        ),
                      ],
                    ),
                  ),
            Divider(),
            Column(
              children: <Widget>[
                launchPads[index]["attempted_launches"] == null
                    ? null
                    : Text(
                        "Attempted Launches:  ${launchPads[index]["attempted_launches"].toString()}"),
                launchPads[index]["successful_launches"] == null
                    ? null
                    : Text(
                        "Successful Launches:  ${launchPads[index]["successful_launches"].toString()}"),
              ].where((w) => w != null).toList(),
            ),
            Divider(),
            launchPads[index]["wikipedia"] == null
                ? null
                : InkWell(
                    onTap: () => Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.downToUp,
                            child: WebView(
                                url: launchPads[index]["wikipedia"],
                                name: launchPads[index]["wikipedia"]),
                            duration: Duration(seconds: 1))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Wikipedia",
                          style: TextStyle(
                              color: Colors.cyan[600],
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
          ].where((w) => w != null).toList(),
        ),
      ),
    );
  }
}
