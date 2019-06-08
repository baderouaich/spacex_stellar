import 'package:flutter/material.dart';
import '../api/api.dart';
import 'package:time_ago_provider/time_ago_provider.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class Cores extends StatefulWidget {
  @override
  _CoresState createState() => _CoresState();
}

class _CoresState extends State<Cores> {
  int _selectedChoice = 0; //default

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
              SliverStickyHeader(
                header: Container(
                  color: Colors.blueGrey[800].withOpacity(.5),
                  child: Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    alignment: WrapAlignment.spaceEvenly,
                    children: <Widget>[
                      ChoiceChip(
                        backgroundColor: Colors.blueGrey[800],
                        pressElevation: 10,
                        onSelected: (bool selected) =>
                            setState(() => _selectedChoice = 0),
                        selected: _selectedChoice == 0,
                        selectedColor: Colors.cyan[600],
                        elevation: 5,
                        label: Text(
                          "All",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ChoiceChip(
                        backgroundColor: Colors.blueGrey[800],
                        pressElevation: 10,
                        onSelected: (bool selected) =>
                            setState(() => _selectedChoice = 1),
                        selected: _selectedChoice == 1,
                        selectedColor: Colors.cyan[600],
                        elevation: 5,
                        label: Text(
                          "Past",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ChoiceChip(
                        backgroundColor: Colors.blueGrey[800],
                        pressElevation: 10,
                        tooltip: "Upcoming Launches",
                        onSelected: (bool selected) =>
                            setState(() => _selectedChoice = 2),
                        selected: _selectedChoice == 2,
                        selectedColor: Colors.cyan[600],
                        elevation: 5,
                        label: Text(
                          "Upcoming",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                sliver: FutureBuilder<Map<String, dynamic>>(
                  future: _selectedChoice == 0
                      ? Api.getAllCores()
                      : _selectedChoice == 1
                          ? Api.getPastCores()
                          : Api.getUpcomingCores(),
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (!snapshot.hasError && snapshot.hasData) {
                      var response = snapshot.data;
                      if (!response["isError"]) {
                        var cores = response["data"] ?? [];
                        return SliverPadding(
                          padding: const EdgeInsets.all(5.0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return _renderCoreItem(cores, index);
                              },
                              childCount: cores.length,
                            ),
                          ),
                        );
                      } else {
                        return SliverFillRemaining(
                            child: Center(
                                child: Text(response["message"],
                                    style: TextStyle(color: Colors.white))));
                      }
                    } else {
                      return SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _renderCoreItem(dynamic cores, int index) {
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
                    color: cores[index]["status"] == "lost"
                        ? Colors.pink[600]
                        : cores[index]["status"] == "inactive"
                            ? Colors.blueGrey
                            : cores[index]["status"] == "active"
                                ? Colors.green
                                : Colors.cyan[600],
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(cores[index]["status"]))),
                Text(cores[index]["core_serial"] == null
                    ? "No Core Serial Provided."
                    : cores[index]["core_serial"]),
              ].where((w) => w != null).toList(),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(cores[index]["details"] == null
                      ? "No Details Provided."
                      : cores[index]["details"]),
                ),
                cores[index]["original_launch"] == null &&
                        cores[index]["original_launch_unix"] == null
                    ? null
                    : Divider(),
                cores[index]["original_launch"] == null
                    ? null
                    : Text(
                        "Original Launch: ${DateTime.parse(cores[index]["original_launch"]).toLocal()}",
                        style: TextStyle(fontSize: 12)),
                cores[index]["original_launch_unix"] == null
                    ? null
                    : Text(
                        "(${TimeAgo.getTimeAgo(cores[index]["original_launch_unix"])})",
                        style: TextStyle(fontSize: 13)),
                cores[index]["missions"].isEmpty
                    ? null
                    : Card(
                        // color: Colors.blueGrey,
                        child: ExpansionTile(
                          title: Text("Missions"),
                          children: <Widget>[
                            Builder(
                              builder: (c) {
                                List<ListTile> missions = [];
                                for (int i = 0;
                                    i < cores[index]["missions"].length;
                                    i++) {
                                  missions.add(ListTile(
                                    dense: true,
                                    title: Text(
                                        "Name:  ${cores[index]["missions"][i]["name"]}"),
                                    subtitle: Text(
                                        "Flight:  ${cores[index]["missions"][i]["flight"]}"),
                                  ));
                                }
                                return Column(children: missions);
                              },
                            ),
                          ],
                        ),
                      ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Divider(),
                    cores[index]["block"] == null
                        ? null
                        : Text("Block: ${cores[index]["block"]}",
                            style: TextStyle(fontSize: 12)),
                    cores[index]["reuse_count"] == null
                        ? null
                        : Text("Reuse Count: ${cores[index]["reuse_count"]}",
                            style: TextStyle(fontSize: 12)),
                    Divider(),
                    cores[index]["rtls_attempts"] == null
                        ? null
                        : Text(
                            "RTLS Attempted Landings: ${cores[index]["rtls_attempts"]}",
                            style: TextStyle(fontSize: 12)),
                    cores[index]["rtls_landings"] == null
                        ? null
                        : Text(
                            "RTLS Successful Landings: ${cores[index]["rtls_landings"]}",
                            style: TextStyle(fontSize: 12)),
                    Divider(),
                    cores[index]["asds_attempts"] == null
                        ? null
                        : Text(
                            "ASDS Attempted Landings: ${cores[index]["asds_attempts"]}",
                            style: TextStyle(fontSize: 12)),
                    cores[index]["asds_landings"] == null
                        ? null
                        : Text(
                            "ASDS Successful Landings: ${cores[index]["asds_landings"]}",
                            style: TextStyle(fontSize: 12)),
                    Divider(),
                    cores[index]["water_landing"] == null
                        ? null
                        : Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                                "Water Landing: ${cores[index]["water_landing"] ? "YES" : "No"}",
                                style: TextStyle(fontSize: 12)),
                          ),
                  ].where((w) => w != null).toList(),
                ),
              ].where((w) => w != null).toList(),
            ),
          ].where((w) => w != null).toList(),
        ),
      ),
    );
  }
}
