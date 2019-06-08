import 'package:flutter/material.dart';
import '../api/api.dart';
import 'package:time_ago_provider/time_ago_provider.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class Capsules extends StatefulWidget {
  @override
  _CapsulesState createState() => _CapsulesState();
}

class _CapsulesState extends State<Capsules> {
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
                    spacing: 2.0, // gap between adjacent chips
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
                      ? Api.getAllCapsules()
                      : _selectedChoice == 1
                          ? Api.getPastCapsules()
                          : Api.getUpcomingCapsules(),
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (!snapshot.hasError && snapshot.hasData) {
                      var response = snapshot.data;
                      if (!response["isError"]) {
                        var capsules = response["data"] ?? [];
                        return SliverPadding(
                          padding: const EdgeInsets.all(5.0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return _renderCapsuleItem(
                                    capsules, index, context);
                              },
                              childCount: capsules.length,
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
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _renderCapsuleItem(dynamic capsules, int index, BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  capsules[index]["status"] == null
                      ? null
                      : Card(
                          elevation: 5,
                          color: capsules[index]["status"] == "active"
                              ? Colors.green
                              : capsules[index]["status"] == "destroyed"
                                  ? Colors.blueGrey
                                  : capsules[index]["status"] == "retired"
                                      ? Colors.pink[600]
                                      : Colors.cyan[600],
                          child: Padding(
                              padding: EdgeInsets.all(3),
                              child: Text(capsules[index]["status"])),
                        ),
                  capsules[index]["capsule_serial"] == null
                      ? null
                      : Text("${capsules[index]["capsule_serial"]}"),
                  capsules[index]["capsule_id"] == null
                      ? null
                      : Text("${capsules[index]["capsule_id"]}"),
                ].where((w) => w != null).toList(),
              ),
              Divider(),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: capsules[index]["details"] == null
                        ? Text("No Details Provided")
                        : Text(capsules[index]["details"]),
                  ),
                  capsules[index]["original_launch"] == null &&
                          capsules[index]["original_launch_unix"] == null
                      ? null
                      : Divider(),
                  capsules[index]["original_launch"] == null
                      ? null
                      : Text(
                          "Original Launch: ${DateTime.parse(capsules[index]["original_launch"]).toLocal()}",
                          style: TextStyle(fontSize: 12)),
                  capsules[index]["original_launch_unix"] == null
                      ? null
                      : Text(
                          "(${TimeAgo.getTimeAgo(capsules[index]["original_launch_unix"])})",
                          style: TextStyle(fontSize: 13)),
                  capsules[index]["missions"].isEmpty
                      ? null
                      : Card(
                          // color: Colors.blueGrey,
                          child: ExpansionTile(
                            title: Text("Missions",
                                style: TextStyle(fontSize: 13)),
                            children: <Widget>[
                              //Best way to enable scrolling.
                              Builder(
                                builder: (c) {
                                  List<ListTile> missions = [];
                                  for (int i = 0;
                                      i < capsules[index]["missions"].length;
                                      i++) {
                                    missions.add(ListTile(
                                      dense: true,
                                      title: Text(
                                          "Name:  ${capsules[index]["missions"][i]["name"]}"),
                                      subtitle: Text(
                                          "Flight:  ${capsules[index]["missions"][i]["flight"]}"),
                                    ));
                                  }
                                  return Column(children: missions);
                                },
                              ),
                            ],
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                            "Landings: ${capsules[index]["landings"].toString()}"),
                        Text(
                            "Reuse count: ${capsules[index]["reuse_count"].toString()}")
                      ],
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: capsules[index]["type"] == null
                            ? null
                            : Text(
                                "${capsules[index]["type"]}",
                                style: TextStyle(fontSize: 10),
                              ),
                      ),
                    ].where((w) => w != null).toList(),
                  )
                ].where((w) => w != null).toList(),
              )
            ].where((w) => w != null).toList(),
          )),
    );
  }
}
