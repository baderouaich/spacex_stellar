import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  String version = "Loading Version...";

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() => version = packageInfo.version);
    });
  }

  @override
  Widget build(BuildContext context) {
    const paypalUrl = "https://www.paypal.me/baderouaich";
    const githubUrl = "https://github.com/BaderEddineOuaich";
    const sourceCode = "https://github.com/BaderEddineOuaich/spacex_stellar";
    const spaceXApi = "https://docs.spacexdata.com/?version=latest";
    return Scaffold(
        appBar: AppBar(
            title: Text("About"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_upward, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
            automaticallyImplyLeading: false),
        body: ListView(
          children: <Widget>[
            ListTile(
              onTap: () async => launchUrl(githubUrl),
              leading: Icon(Icons.person_outline),
              title: Text("Developer"),
              subtitle: Text("Bader Eddine Ouaich",
                  style: TextStyle(color: Colors.cyan[600])),
            ),
            Divider(),
            ListTile(
              onTap: () async => launchUrl(sourceCode),
              leading: Icon(Icons.code),
              title: Text("Source Code"),
              subtitle:
                  Text("Github", style: TextStyle(color: Colors.cyan[600])),
            ),
            Divider(),
            ListTile(
              onTap: () async => launchUrl(spaceXApi),
              leading: Icon(Icons.cloud_queue),
              title: Text("SpaceX API"),
              subtitle: Text("SpaceX API Docs",
                  style: TextStyle(color: Colors.cyan[600])),
            ),
            Divider(),
            ListTile(
              //onTap: () async => launchUrl(spaceXApi),
              leading: Icon(Icons.info_outline),
              title: Text("Version"),
              subtitle:
                  Text(version, style: TextStyle(color: Colors.cyan[600])),
            ),
          ],
        ),
        bottomSheet: BottomSheet(
          enableDrag: true,
          onClosing: () => print("Closing "),
          builder: (c) {
            return InkWell(
              onTap: () async => launchUrl(paypalUrl),
              splashColor: Colors.cyan[600],
              child: Card(
                color: Colors.blueGrey[900],
                child: Container(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("Buy me a"),
                          Image.asset("assets/coffee.png",
                              width: 50, height: 50),
                        ],
                      ),
                      VerticalDivider(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset("assets/paypal.png",
                              width: 40, height: 40),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text("1\$",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  launchUrl(String url) async =>
      await canLaunch(url) ? await launch(url) : null;
}
