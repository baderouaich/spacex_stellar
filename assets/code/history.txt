import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:time_ago_provider/time_ago_provider.dart';
import '../api/api.dart';
import '../webview.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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
                future: Api.getAllHistoryEvents(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (!snapshot.hasError && snapshot.hasData) {
                    var response = snapshot.data;
                    if (!response["isError"]) {
                      var histories = response["data"] ?? [];
                      return SliverPadding(
                        padding: const EdgeInsets.all(5.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return _renderHistoryItem(histories, index);
                            },
                            childCount: histories.length,
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

  Widget _renderHistoryItem(dynamic histories, int index) {
    return InkWell(
        onTap: () {},
        splashColor: index.isEven ? Colors.cyan[600] : Colors.pink[600],
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              histories[index]["title"] == null
                  ? null
                  : Text(histories[index]["title"],
                      style: TextStyle(
                          color: Colors.cyan[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
              Divider(),
              histories[index]["details"] == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(histories[index]["details"]),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  histories[index]["event_date_utc"] == null
                      ? null
                      : Text(
                          DateTime.parse(histories[index]["event_date_utc"])
                              .toLocal()
                              .toString(),
                          style: TextStyle(fontSize: 12)),
                  histories[index]["event_date_unix"] == null
                      ? null
                      : Text(
                          "(${TimeAgo.getTimeAgo(histories[index]["event_date_unix"])})",
                          style: TextStyle(fontSize: 12)),
                ].where((w) => w != null).toList(),
              ),
              histories[index]["flight_number"] == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                          "Flight Nº ${histories[index]["flight_number"]}",
                          style: TextStyle(fontSize: 12)),
                    ),
              histories[index]["links"] == null
                  ? null
                  : ExpansionTile(
                      title: Text("Links"),
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            for (String key in histories[index]["links"].keys)
                              if (histories[index]["links"][key] != null)
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.downToUp,
                                          child: WebView(
                                              url: histories[index]["links"]
                                                  [key],
                                              name: histories[index]["links"]
                                                  [key]),
                                          duration: Duration(seconds: 1))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("$key",
                                        style: TextStyle(
                                            color: Colors.pink[600],
                                            fontWeight: FontWeight.w600)),
                                  ),
                                )
                          ],
                        )
                      ].where((w) => w != null).toList(),
                    )
            ].where((w) => w != null).toList(),
          ),
        )));
  }
}
