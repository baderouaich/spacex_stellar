import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../webview.dart';
import '../imageview.dart';
import '../api/api.dart';
import '../show_more.dart';

class Dragons extends StatefulWidget {
  @override
  _DragonsState createState() => _DragonsState();
}

class _DragonsState extends State<Dragons> {
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
                future: Api.getAllDragons(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (!snapshot.hasError && snapshot.hasData) {
                    var response = snapshot.data;
                    if (!response["isError"]) {
                      var dragons = response["data"] ?? [];
                      return SliverPadding(
                        padding: const EdgeInsets.all(5.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return _renderDragonItem(dragons, index);
                            },
                            childCount: dragons.length,
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

  Widget _renderDragonItem(dynamic dragons, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                dragons[index]["active"] == null
                    ? null
                    : Card(
                        elevation: 5,
                        color: dragons[index]["active"]
                            ? Colors.green
                            : Colors.pink[600],
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                              dragons[index]["active"] ? "Active" : "Inactive"),
                        ),
                      ),
                dragons[index]["name"] == null
                    ? null
                    : Text(dragons[index]["name"]),
                dragons[index]["type"] == null
                    ? null
                    : Text(dragons[index]["type"]),
              ].where((w) => w != null).toList(),
            ),
            Divider(),
            dragons[index]["description"] == null
                ? null
                : Padding(
                    padding: EdgeInsets.all(7.0),
                    child: ShowMore(text: dragons[index]["description"]),
                  ),
            dragons[index]["first_flight"] == null
                ? null
                : Padding(
                    padding: EdgeInsets.all(7.0),
                    child:
                        Text("First Flight: ${dragons[index]["first_flight"]}"),
                  ),

            ExpansionTile(
              title: Text("Details"),
              children: <Widget>[
                ExpansionTile(
                  title: Text("Overall"),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        dragons[index]["crew_capacity"] == null
                            ? null
                            : Text(
                                "Crew Capacity: ${dragons[index]["crew_capacity"]}"),
                        dragons[index]["sidewall_angle_deg"] == null
                            ? null
                            : Text(
                                "SideWall Angle Deg: ${dragons[index]["sidewall_angle_deg"]}"),
                      ].where((w) => w != null).toList(),
                    ),
                    dragons[index]["orbit_duration_yr"] == null
                        ? null
                        : Text(
                            "Orbit Duration years: ${dragons[index]["orbit_duration_yr"]}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        dragons[index]["dry_mass_kg"] == null
                            ? null
                            : Text(
                                "Dry mass kg: ${dragons[index]["dry_mass_kg"]}"),
                        dragons[index]["dry_mass_lb"] == null
                            ? null
                            : Text(
                                "Dry mass lb: ${dragons[index]["dry_mass_lb"]}"),
                      ].where((w) => w != null).toList(),
                    ),
                  ].where((w) => w != null).toList(),
                ),

                dragons[index]["heat_shield"] == null
                    ? null
                    : ExpansionTile(
                        title: Text("Heat Shield"),
                        children: <Widget>[
                          dragons[index]["heat_shield"]["material"] == null
                              ? null
                              : Text(
                                  "Material: ${dragons[index]["heat_shield"]["material"]}"),
                          dragons[index]["heat_shield"]["size_meters"] == null
                              ? null
                              : Text(
                                  "Size Meters: ${dragons[index]["heat_shield"]["size_meters"]}"),
                          dragons[index]["heat_shield"]["temp_degrees"] == null
                              ? null
                              : Text(
                                  "Temp Degrees: ${dragons[index]["heat_shield"]["temp_degrees"]}"),
                          dragons[index]["heat_shield"]["dev_partner"] == null
                              ? null
                              : Text(
                                  "Dev Partner: ${dragons[index]["heat_shield"]["dev_partner"]}"),
                        ].where((w) => w != null).toList(),
                      ),

                //thrusters
                dragons[index]["thrusters"] == null
                    ? null
                    : ExpansionTile(
                        title: Text("Thrusters"),
                        children: <Widget>[
                          Builder(
                            builder: (c) {
                              List<ListTile> thrusters = [];
                              for (int i = 0;
                                  i < dragons[index]["thrusters"].length;
                                  i++) {
                                thrusters.add(ListTile(
                                  title: Text(
                                      "type: ${dragons[index]["thrusters"][i]["type"]}"),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          "Amount: ${dragons[index]["thrusters"][i]["amount"]}"),
                                      Text(
                                          "Pods: ${dragons[index]["thrusters"][i]["pods"]}"),
                                      Divider(),
                                      Text(
                                          "Fuel 1: ${dragons[index]["thrusters"][i]["fuel_1"]}"),
                                      Text(
                                          "Fuel 2: ${dragons[index]["thrusters"][i]["fuel_2"]}"),
                                      Divider(),
                                      ListTile(
                                        title: Text("Thrust"),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                "kN: ${dragons[index]["thrusters"][i]["thrust"]["kN"]}"),
                                            Text(
                                                "lbf: ${dragons[index]["thrusters"][i]["thrust"]["lbf"]}"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                              }
                              return Column(children: thrusters);
                            },
                          ),
                        ],
                      ),

                //launch_payload_mass
                dragons[index]["launch_payload_mass"] == null
                    ? null
                    : ExpansionTile(
                        title: Text("Launch Payload Mass"),
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                  "KG: ${dragons[index]["launch_payload_mass"]["kg"]}"),
                              Text(
                                  "LB: ${dragons[index]["launch_payload_mass"]["lb"]}"),
                            ],
                          )
                        ],
                      ),

                //launch_payload_vol
                dragons[index]["launch_payload_vol"] == null
                    ? null
                    : ExpansionTile(
                        title: Text("Launch Payload Vol"),
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                  "Cubic Meters: ${dragons[index]["launch_payload_vol"]["cubic_meters"]}"),
                              Text(
                                  "Cubic Feet: ${dragons[index]["launch_payload_vol"]["cubic_feet"]}"),
                            ],
                          )
                        ],
                      ),

                //return_payload_mass
                dragons[index]["return_payload_mass"] == null
                    ? null
                    : ExpansionTile(
                        title: Text("Return Payload Mass"),
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                  "KG: ${dragons[index]["return_payload_mass"]["kg"]}"),
                              Text(
                                  "LB: ${dragons[index]["return_payload_mass"]["lb"]}"),
                            ],
                          )
                        ],
                      ),

                //return_payload_vol
                dragons[index]["return_payload_vol"] == null
                    ? null
                    : ExpansionTile(
                        title: Text("Return Payload Vol"),
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                  "Cubic Meters: ${dragons[index]["return_payload_vol"]["cubic_meters"]}"),
                              Text(
                                  "Cubic Feet: ${dragons[index]["return_payload_vol"]["cubic_feet"]}"),
                            ],
                          )
                        ],
                      ),

                //pressurized_capsule
                dragons[index]["pressurized_capsule"] == null
                    ? null
                    : ExpansionTile(
                        title: Text("Pressurized Papsule"),
                        children: <Widget>[
                          ListTile(
                            title: Text("Payload Volume"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    "Cubic Meters: ${dragons[index]["pressurized_capsule"]["payload_volume"]["cubic_meters"]}"),
                                Text(
                                    "Cubic Feet: ${dragons[index]["pressurized_capsule"]["payload_volume"]["cubic_feet"]}"),
                              ],
                            ),
                          )
                        ],
                      ),

                //trunk
                dragons[index]["trunk"] == null
                    ? null
                    : ExpansionTile(
                        title: Text("Trunk"),
                        children: <Widget>[
                          ListTile(
                            title: Text("Trunk Volume"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    "Cubic Meters: ${dragons[index]["trunk"]["trunk_volume"]["cubic_meters"]}"),
                                Text(
                                    "Cubic Feet: ${dragons[index]["trunk"]["trunk_volume"]["cubic_feet"]}"),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Text("Cargo"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    "Solar Array: ${dragons[index]["trunk"]["cargo"]["solar_array"]}"),
                                Text(
                                    "Unpressurized Cargo: ${dragons[index]["trunk"]["cargo"]["unpressurized_cargo"] ? "YES" : "NO"}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                //height_w_trunk
                dragons[index]["height_w_trunk"] == null
                    ? null
                    : ExpansionTile(
                        title: Text("Trunk Height"),
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                  "Meters: ${dragons[index]["height_w_trunk"]["meters"]}"),
                              Text(
                                  "Feet: ${dragons[index]["height_w_trunk"]["feet"]}"),
                            ],
                          )
                        ],
                      ),
                //diameter
                dragons[index]["diameter"] == null
                    ? null
                    : ExpansionTile(
                        title: Text("Diameter"),
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                  "Meters: ${dragons[index]["diameter"]["meters"]}"),
                              Text(
                                  "Feet: ${dragons[index]["diameter"]["feet"]}"),
                            ],
                          )
                        ],
                      ),
              ].where((w) => w != null).toList(),
            ),

            dragons[index]["flickr_images"] == null
                ? null
                : ExpansionTile(title: Text("Flickr Images"), children: <
                    Widget>[
                    Builder(
                      builder: (c) {
                        List<Widget> images = [];
                        for (int i = 0;
                            i < dragons[index]["flickr_images"].length;
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
                                  imageUrl: dragons[index]["flickr_images"][i],
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
                                        url: dragons[index]["flickr_images"][i],
                                      ),
                                      duration: Duration(milliseconds: 750)))));
                        }
                        return Wrap(children: images);
                      },
                    ),
                  ]),
            //Divider(),
            dragons[index]["wikipedia"] == null
                ? null
                : InkWell(
                    onTap: () => Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.downToUp,
                            child: WebView(
                                url: dragons[index]["wikipedia"],
                                name: dragons[index]["name"]),
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
        ),
      ),
    );
  }
}
