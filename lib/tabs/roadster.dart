import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../api/api.dart';
import 'package:time_ago_provider/time_ago_provider.dart';
import '../imageview.dart';
import '../show_more.dart';
import '../webview.dart';

class Roadster extends StatefulWidget {
  @override
  _RoadsterState createState() => _RoadsterState();
}

class _RoadsterState extends State<Roadster> {
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
                future: Api.getRoadster(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (!snapshot.hasError && snapshot.hasData) {
                    var response = snapshot.data;
                    if (!response["isError"]) {
                      var roadster = response["data"];
                      var roadsterInfoList = [
                        ListTile(
                          title: Text("Name"),
                          subtitle: Text(roadster["name"]),
                        ),
                        ListTile(
                          title: Text("Details"),
                          subtitle: ShowMore(text: roadster["details"]),
                        ),
                        ListTile(
                          title: Text("Launch Date"),
                          subtitle: Text(
                              "${DateTime.parse(roadster["launch_date_utc"]).toLocal().toString()} (${TimeAgo.getTimeAgo(roadster["launch_date_unix"])})"),
                        ),
                        ListTile(
                          title: Text("Launch Mass KG"),
                          subtitle: Text(roadster["launch_mass_kg"].toString()),
                        ),
                        ListTile(
                          title: Text("Launch Mass LBS"),
                          subtitle:
                              Text(roadster["launch_mass_lbs"].toString()),
                        ),
                        ListTile(
                          title: Text("Norad ID"),
                          subtitle: Text(roadster["norad_id"].toString()),
                        ),
                        ListTile(
                          title: Text("Epoch JD"),
                          subtitle: Text(roadster["epoch_jd"].toString()),
                        ),
                        ListTile(
                          title: Text("Orbit Type"),
                          subtitle: Text(roadster["orbit_type"].toString()),
                        ),
                        ListTile(
                          title: Text("Apoapsis au"),
                          subtitle: Text(roadster["apoapsis_au"].toString()),
                        ),
                        ListTile(
                          title: Text("Periapsis au"),
                          subtitle: Text(roadster["periapsis_au"].toString()),
                        ),
                        ListTile(
                          title: Text("Semi Major Axis au"),
                          subtitle:
                              Text(roadster["semi_major_axis_au"].toString()),
                        ),
                        ListTile(
                          title: Text("Eccentricity"),
                          subtitle: Text(roadster["eccentricity"].toString()),
                        ),
                        ListTile(
                          title: Text("Inclination"),
                          subtitle: Text(roadster["inclination"].toString()),
                        ),
                        ListTile(
                          title: Text("Longitude"),
                          subtitle: Text(roadster["longitude"].toString()),
                        ),
                        ListTile(
                          title: Text("Periapsis Arg"),
                          subtitle: Text(roadster["periapsis_arg"].toString()),
                        ),
                        ListTile(
                          title: Text("Period Days"),
                          subtitle: Text(roadster["period_days"].toString()),
                        ),
                        ListTile(
                          title: Text("Speed kph"),
                          subtitle: Text(roadster["speed_kph"].toString()),
                        ),
                        ListTile(
                          leading: Text("Speed mph"),
                          subtitle: Text(roadster["speed_mph"].toString()),
                        ),
                        ListTile(
                          leading: Text("Earth Distance km"),
                          subtitle:
                              Text(roadster["earth_distance_km"].toString()),
                        ),
                        ListTile(
                          leading: Text("Earth Distance mi"),
                          subtitle:
                              Text(roadster["earth_distance_mi"].toString()),
                        ),
                        ListTile(
                          leading: Text("Mars Distance km"),
                          subtitle:
                              Text(roadster["mars_distance_km"].toString()),
                        ),
                        ListTile(
                          leading: Text("Mars Distance mi"),
                          subtitle:
                              Text(roadster["mars_distance_mi"].toString()),
                        ),
                        Divider(),
                        ExpansionTile(title: Text("Flickr Images"), children: <
                            Widget>[
                          Builder(
                            builder: (c) {
                              List<Widget> images = [];
                              for (int i = 0;
                                  i < roadster["flickr_images"].length;
                                  i++) {
                                images.add(InkWell(
                                    child: Container(
                                      margin: EdgeInsets.all(2),
                                      child: CachedNetworkImage(
                                        height: 100,
                                        width: 100,
                                        fadeInDuration: Duration(
                                            seconds: 2), // default 700ms
                                        fadeInCurve:
                                            Curves.fastLinearToSlowEaseIn,
                                        fit: BoxFit.cover,
                                        imageUrl: roadster["flickr_images"][i],
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.cloud_off),
                                      ),
                                    ),
                                    onTap: () => Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.leftToRight,
                                            child: ImageView(
                                              url: roadster["flickr_images"][i],
                                            ),
                                            duration:
                                                Duration(milliseconds: 750)))));
                              }
                              return Wrap(children: images);
                            },
                          ),
                        ]),
                        Divider(),
                        Center(
                          child: InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text("Wikipedia",
                                  style: TextStyle(color: Colors.cyan[600])),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.downToUp,
                                    child: WebView(
                                        url: roadster["wikipedia"],
                                        name: roadster["wikipedia"]),
                                    duration: Duration(seconds: 1))),
                          ),
                        ),
                      ].where((w) => w != null).toList();

                      return SliverPadding(
                        padding: const EdgeInsets.all(5.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return roadsterInfoList[index];
                            },
                            childCount: roadsterInfoList.length,
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
