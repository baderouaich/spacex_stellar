import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../webview.dart';
import '../api/api.dart';

class LandingPads extends StatefulWidget {
  @override
  _LandingPadsState createState() => _LandingPadsState();
}

class _LandingPadsState extends State<LandingPads> {
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
                future: Api.getAllLandingPads(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (!snapshot.hasError && snapshot.hasData) {
                    var response = snapshot.data;
                    if (!response["isError"]) {
                      var landingPads = response["data"] ?? [];
                      return SliverPadding(
                        padding: const EdgeInsets.all(5.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return _renderLandingPadItem(landingPads, index);
                            },
                            childCount: landingPads.length,
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

  Widget _renderLandingPadItem(dynamic landingPads, int index) {
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
                  color: landingPads[index]["status"] == "active"
                      ? Colors.green
                      : landingPads[index]["status"] == "destroyed"
                          ? Colors.blueGrey
                          : landingPads[index]["status"] == "retired"
                              ? Colors.pink[600]
                              : Colors.cyan[600],
                  child: Padding(
                      padding: EdgeInsets.all(3),
                      child: Text(landingPads[index]["status"])),
                ),
                landingPads[index]["full_name"] == null
                    ? null
                    : Text(landingPads[index]["full_name"]),
                landingPads[index]["id"] == null
                    ? null
                    : Text(landingPads[index]["id"]),
              ].where((w) => w != null).toList(),
            ),
            Divider(),
            landingPads[index]["details"] == null
                ? null
                : ListTile(
                    title: Text("Details"),
                    subtitle: Text(landingPads[index]["details"]),
                  ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                landingPads[index]["landing_type"] == null
                    ? null
                    : Text(
                        "Landing Type: ${landingPads[index]["landing_type"]}"),
                landingPads[index]["attempted_landings"] == null
                    ? null
                    : Text(
                        "Attempted Landings: ${landingPads[index]["attempted_landings"].toString()}"),
                landingPads[index]["successful_landings"] == null
                    ? null
                    : Text(
                        "Successful Landings: ${landingPads[index]["successful_landings"].toString()}"),
              ].where((w) => w != null).toList(),
            ),
            Divider(),
            landingPads[index]["location"] == null
                ? null
                : ListTile(
                    title: Text("Location"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        landingPads[index]["location"]["name"] == null
                            ? null
                            : Text(
                                "Name:  ${landingPads[index]["location"]["name"]}"),
                        landingPads[index]["location"]["region"] == null
                            ? null
                            : Text(
                                "Region:  ${landingPads[index]["location"]["region"]}"),
                        landingPads[index]["location"]["latitude"] == null
                            ? null
                            : Text(
                                "Latitude:  ${landingPads[index]["location"]["latitude"].toString()}"),
                        landingPads[index]["location"]["longitude"] == null
                            ? null
                            : Text(
                                "Longitude:  ${landingPads[index]["location"]["longitude"].toString()}"),
                      ].where((w) => w != null).toList(),
                    ),
                  ),
            Divider(),
            landingPads[index]["wikipedia"] == null
                ? null
                : InkWell(
                    onTap: () => Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.downToUp,
                            child: WebView(
                                url: landingPads[index]["wikipedia"],
                                name: landingPads[index]["wikipedia"]),
                            duration: Duration(seconds: 1))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Wikipedia",
                          style: TextStyle(
                              color: Colors.cyan[600],
                              fontWeight: FontWeight.w600)),
                    ),
                  )
          ].where((w) => w != null).toList(),
        ),
      ),
    );
  }
}
