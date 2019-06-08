import 'package:flutter/material.dart';
import '../api/api.dart';

class Payloads extends StatefulWidget {
  @override
  _PayloadsState createState() => _PayloadsState();
}

class _PayloadsState extends State<Payloads> {
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
                future: Api.getAllPayloads(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (!snapshot.hasError && snapshot.hasData) {
                    var response = snapshot.data;
                    if (!response["isError"]) {
                      var payloads = response["data"] ?? [];
                      return SliverPadding(
                        padding: const EdgeInsets.all(5.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return _renderPayloadItem(payloads, index);
                            },
                            childCount: payloads.length,
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

  Widget _renderPayloadItem(dynamic payloads, int index) {
    return InkWell(
        onTap: () {},
        splashColor: index.isEven ? Colors.cyan[600] : Colors.pink[600],
        child: Card(
            child: Column(
                children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Payload ID"),
              Card(
                  color: index.isEven ? Colors.pink[600] : Colors.cyan[600],
                  child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(
                          child: Text("${payloads[index]["payload_id"]}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold))))),
            ],
          ),
          Divider(),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                payloads[index]["nationality"] == null
                    ? null
                    : Text("Nationality: ${payloads[index]["nationality"]}",
                        style: TextStyle(fontSize: 12)),
                payloads[index]["manufacturer"] == null
                    ? null
                    : Text("Manufacturer: ${payloads[index]["manufacturer"]}"),
              ].where((w) => w != null).toList()),
          Divider(),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                payloads[index]["reused"] == null
                    ? null
                    : Text(
                        "Reused: ${payloads[index]["reused"] ? "YES" : "NO"}",
                        style: TextStyle(fontSize: 12)),
                payloads[index]["orbit"] == null
                    ? null
                    : Text("Orbit: ${payloads[index]["orbit"]}"),
              ].where((w) => w != null).toList()),
          ExpansionTile(
            title: Text("Payload Details"),
            children: <Widget>[
              payloads[index]["payload_type"] == null
                  ? null
                  : ListTile(
                      title: Text("Payload Type"),
                      subtitle: Text(payloads[index]["payload_type"]),
                    ),
              payloads[index]["payload_mass_kg"] == null
                  ? null
                  : ListTile(
                      title: Text("Payload Mass KG"),
                      subtitle:
                          Text(payloads[index]["payload_mass_kg"].toString()),
                    ),
              payloads[index]["payload_mass_lbs"] == null
                  ? null
                  : ListTile(
                      title: Text("Payload Mass LBS"),
                      subtitle:
                          Text(payloads[index]["payload_mass_lbs"].toString()),
                    ),
            ].where((w) => w != null).toList(),
          ),
          payloads[index]["customers"] == null
              ? null
              : ExpansionTile(
                  title: Text("Customers"),
                  children: <Widget>[
                    for (int i = 0;
                        i < payloads[index]["customers"].length;
                        i++)
                      Padding(
                          padding: EdgeInsets.all(3),
                          child: Text(payloads[index]["customers"][i]))
                  ],
                ),
          payloads[index]["orbit_params"] == null
              ? null
              : ExpansionTile(
                  title: Text("Orbit Params"),
                  children: <Widget>[
                    for (String key in payloads[index]["orbit_params"].keys)
                      if (payloads[index]["orbit_params"][key] != null)
                        ListTile(
                            title: Text(key),
                            subtitle: Text(payloads[index]["orbit_params"][key]
                                .toString()))
                  ],
                ),
          payloads[index]["norad_id"].isEmpty
              ? null
              : ExpansionTile(
                  title: Text("Norad ID"),
                  children: <Widget>[
                    for (int i = 0; i < payloads[index]["norad_id"].length; i++)
                      Padding(
                          padding: EdgeInsets.all(5),
                          child:
                              Text(payloads[index]["norad_id"][i].toString()))
                  ],
                ),
        ].where((w) => w != null).toList())));
  }
}
