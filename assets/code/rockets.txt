import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../api/api.dart';
import '../imageview.dart';
import '../show_more.dart';
import '../webview.dart';

class Rockets extends StatefulWidget {
  @override
  _RocketsState createState() => _RocketsState();
}

class _RocketsState extends State<Rockets> {
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
                future: Api.getAllRockets(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (!snapshot.hasError && snapshot.hasData) {
                    var response = snapshot.data;
                    if (!response["isError"]) {
                      var rockets = response["data"] ?? [];
                      return SliverPadding(
                        padding: const EdgeInsets.all(5.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return _renderRocketItem(rockets, index);
                            },
                            childCount: rockets.length,
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

  Widget _renderRocketItem(dynamic rockets, int index) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
                children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  rockets[index]["active"] == null
                      ? null
                      : Card(
                          elevation: 5,
                          color: rockets[index]["active"]
                              ? Colors.green
                              : Colors.pink[600],
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(rockets[index]["active"]
                                ? "Active"
                                : "Inactive"),
                          ),
                        ),
                  rockets[index]["rocket_name"] == null
                      ? null
                      : Text(rockets[index]["rocket_name"]),
                  rockets[index]["rocket_type"] == null
                      ? null
                      : Text(rockets[index]["rocket_type"]),
                ].where((w) => w != null).toList(),
              ),
              Divider(),
              rockets[index]["description"] == null
                  ? null
                  : Padding(
                      padding: EdgeInsets.all(7.0),
                      child: ShowMore(text: rockets[index]["description"]),
                    ),
              rockets[index]["first_flight"] == null
                  ? null
                  : Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Text(
                          "First Flight: ${rockets[index]["first_flight"]}"),
                    ),

              //
              ExpansionTile(
                title: Text("Details"),
                children: <Widget>[
                  ExpansionTile(
                    title: Text("Overall"),
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          rockets[index]["stages"] == null
                              ? null
                              : Text("Stages: ${rockets[index]["stages"]}"),
                          rockets[index]["boosters"] == null
                              ? null
                              : Text("Boosters: ${rockets[index]["boosters"]}"),
                        ].where((w) => w != null).toList(),
                      ),
                      rockets[index]["cost_per_launch"] == null
                          ? null
                          : Text(
                              "Cost Per Launch: ${rockets[index]["orbit_duration_yr"]}\$"),
                      rockets[index]["success_rate_pct"] == null
                          ? null
                          : Text(
                              "Success Rate pct: ${rockets[index]["success_rate_pct"]}"),
                      rockets[index]["country"] == null
                          ? null
                          : Text("Country: ${rockets[index]["country"]}"),
                      rockets[index]["company"] == null
                          ? null
                          : Text("Company: ${rockets[index]["company"]}"),
                    ].where((w) => w != null).toList(),
                  ),

                  rockets[index]["height"] == null
                      ? null
                      : ExpansionTile(
                          title: Text("Height"),
                          children: <Widget>[
                            rockets[index]["height"]["meters"] == null
                                ? null
                                : Text(
                                    "Meters: ${rockets[index]["height"]["meters"]}"),
                            rockets[index]["height"]["feet"] == null
                                ? null
                                : Text(
                                    "Feet: ${rockets[index]["height"]["feet"]}"),
                          ].where((w) => w != null).toList(),
                        ),

                  //diameter
                  rockets[index]["diameter"] == null
                      ? null
                      : ExpansionTile(
                          title: Text("Diameter"),
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                    "Meters: ${rockets[index]["diameter"]["meters"]}"),
                                Text(
                                    "Feet: ${rockets[index]["diameter"]["feet"]}"),
                              ],
                            )
                          ],
                        ),

                  rockets[index]["mass"] == null
                      ? null
                      : ExpansionTile(
                          title: Text("Mass"),
                          children: <Widget>[
                            Text("kg: ${rockets[index]["mass"]["kg"]}"),
                            Text("lb: ${rockets[index]["mass"]["lb"]}"),
                          ],
                        ),

                  rockets[index]["payload_weights"].isEmpty
                      ? null
                      : ExpansionTile(
                          title: Text("Payload Weights"),
                          children: <Widget>[
                            for (int i = 0;
                                i < rockets[index]["payload_weights"].length;
                                i++)
                              ListTile(
                                leading: Text(
                                    rockets[index]["payload_weights"][i]["id"]),
                                title: Text(rockets[index]["payload_weights"][i]
                                    ["name"]),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        "kg: ${rockets[index]["payload_weights"][i]["kg"]}"),
                                    Text(
                                        "lb: ${rockets[index]["payload_weights"][i]["lb"]}")
                                  ],
                                ),
                              )
                          ],
                        ),

                  rockets[index]["landing_legs"] == null
                      ? null
                      : ExpansionTile(
                          title: Text("Landing Legs"),
                          children: <Widget>[
                            for (String key
                                in rockets[index]["landing_legs"].keys)
                              if (rockets[index]["landing_legs"][key] != null)
                                Text(
                                    "${key.toUpperCase()}: ${rockets[index]["landing_legs"][key]}")
                          ],
                        ),

                  rockets[index]["engines"] == null
                      ? null
                      : ExpansionTile(
                          title: Text("Engines"),
                          children: <Widget>[
                            for (String key in rockets[index]["engines"].keys)
                              if (rockets[index]["engines"][key] != null)
                                rockets[index]["engines"][key] is! Map
                                    ? ListTile(
                                        title: Text(key.toUpperCase()),
                                        subtitle: Text(rockets[index]["engines"]
                                                [key]
                                            .toString()),
                                      )
                                    : ExpansionTile(
                                        title: Text(key.toUpperCase()),
                                        children: <Widget>[
                                          for (String k in rockets[index]
                                                  ["engines"][key]
                                              .keys)
                                            if (rockets[index]["engines"][key]
                                                    [k] !=
                                                null)
                                              Text(
                                                  "${k.toUpperCase()}: ${rockets[index]["engines"][key][k]}")
                                        ],
                                      )
                          ],
                        ),
                ].where((w) => w != null).toList(),
              ),
              //

              rockets[index]["flickr_images"] == null
                  ? null
                  : ExpansionTile(title: Text("Flickr Images"), children: <
                      Widget>[
                      Builder(
                        builder: (c) {
                          List<Widget> images = [];
                          for (int i = 0;
                              i < rockets[index]["flickr_images"].length;
                              i++) {
                            images.add(InkWell(
                                child: Container(
                                  margin: EdgeInsets.all(2),
                                  child: CachedNetworkImage(
                                    height: 100,
                                    width: 100,
                                    fadeInDuration:
                                        Duration(seconds: 2), // default 700ms
                                    fadeInCurve: Curves.fastLinearToSlowEaseIn,
                                    fit: BoxFit.cover,
                                    imageUrl: rockets[index]["flickr_images"]
                                        [i],
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.cloud_off),
                                  ),
                                ),
                                onTap: () => Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.leftToRight,
                                        child: ImageView(
                                          url: rockets[index]["flickr_images"]
                                              [i],
                                        ),
                                        duration:
                                            Duration(milliseconds: 750)))));
                          }
                          return Wrap(children: images);
                        },
                      ),
                    ]),

              rockets[index]["wikipedia"] == null
                  ? null
                  : InkWell(
                      onTap: () => Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.downToUp,
                              child: WebView(
                                  url: rockets[index]["wikipedia"],
                                  name: rockets[index]["wikipedia"]),
                              duration: Duration(seconds: 1))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Wikipedia",
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
            ].where((w) => w != null).toList())));
  }
}
