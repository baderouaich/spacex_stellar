import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../api/api.dart';
import '../imageview.dart';

class Ships extends StatefulWidget {
  @override
  _ShipsState createState() => _ShipsState();
}

class _ShipsState extends State<Ships> {
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
                future: Api.getAllShips(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (!snapshot.hasError && snapshot.hasData) {
                    var response = snapshot.data;
                    if (!response["isError"]) {
                      var ships = response["data"] ?? [];
                      return SliverPadding(
                        padding: const EdgeInsets.all(5.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return _renderShipItem(ships, index);
                            },
                            childCount: ships.length,
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

  Widget _renderShipItem(dynamic ships, int index) {
    const topImageRadius = BorderRadius.vertical(top: Radius.circular(15.0));
    const cardRadius = BorderRadius.vertical(
        bottom: Radius.circular(15.0), top: Radius.circular(15.0));
    return Card(
      elevation: 7,
      margin: EdgeInsets.all(7),
      shape: RoundedRectangleBorder(borderRadius: cardRadius),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ships[index]["image"] == null
                  ? null
                  : ClipRRect(
                      borderRadius: topImageRadius,
                      child: GestureDetector(
                          child: Container(
                            child: CachedNetworkImage(
                              fadeInDuration:
                                  Duration(seconds: 2), // default 700ms
                              fadeInCurve: Curves.fastLinearToSlowEaseIn,
                              fit: BoxFit.cover,
                              imageUrl: ships[index]["image"],
                              placeholder: (context, url) => Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Center(
                                      child: CircularProgressIndicator())),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.cloud_off),
                            ),
                          ),
                          onTap: () => Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  child: ImageView(
                                    url: ships[index]["image"],
                                  ),
                                  duration: Duration(milliseconds: 750))))),
              ships[index]["active"] == null
                  ? null
                  : Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 70,
                            child: Card(
                              elevation: 10,
                              color: ships[index]["active"]
                                  ? Colors.green
                                  : Colors.pink[600],
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                  child: Text(
                                    "${ships[index]["active"] ? "Active" : "Inactive"}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ))),
            ].where((w) => w != null).toList(),
          ),
          ExpansionTile(
            title: Text("Details"),
            children: <Widget>[
              for (String key in ships[index].keys)
                if (key != "roles" &&
                    key != "active" &&
                    key != "position" &&
                    key != "missions" &&
                    key != "url" &&
                    key != "image" &&
                    key != "successful_landings" &&
                    key != "attempted_landings")
                  if (ships[index][key] != null)
                    ListTile(
                      title: Text(key.toUpperCase()),
                      subtitle: Text(ships[index][key].toString()),
                    )
            ].where((w) => w != null).toList(),
          ),
          ships[index]["successful_landings"] == null &&
                  ships[index]["attempted_landings"] == null
              ? null
              : ExpansionTile(
                  title: Text("Landings"),
                  children: <Widget>[
                    ships[index]["attempted_landings"] == null
                        ? null
                        : ListTile(
                            title: Text("Attempted Landings"),
                            subtitle: Text(
                                ships[index]["attempted_landings"].toString()),
                          ),
                    ships[index]["successful_landings"] == null
                        ? null
                        : ListTile(
                            title: Text("Successful Landings"),
                            subtitle: Text(
                                ships[index]["successful_landings"].toString()),
                          )
                  ].where((w) => w != null).toList(),
                ),
          ships[index]["missions"].isEmpty
              ? null
              : ExpansionTile(
                  title: Text("Missions"),
                  children: <Widget>[
                    for (int i = 0; i < ships[index]["missions"].length; i++)
                      ListTile(
                        title: Text(
                            "Name:  ${ships[index]["missions"][i]["name"]}\nFlight:  ${ships[index]["missions"][i]["flight"]}"),
                      ),
                  ].where((w) => w != null).toList(),
                ),
          ships[index]["roles"].isEmpty
              ? null
              : ExpansionTile(
                  title: Text("Roles"),
                  children: <Widget>[
                    for (int i = 0; i < ships[index]["roles"].length; i++)
                      ListTile(
                        title: Text(ships[index]["roles"][i]),
                      ),
                  ].where((w) => w != null).toList(),
                ),
          ships[index]["position"].isEmpty
              ? null
              : ExpansionTile(
                  title: Text("Position"),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                          "Latitude: ${ships[index]["position"]["latitude"]}\nLongitude: ${ships[index]["position"]["longitude"]}"),
                    ),
                  ].where((w) => w != null).toList(),
                ),
        ].where((w) => w != null).toList(),
      ),
    );
  }
}
