import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:page_transition/page_transition.dart';
import 'package:time_ago_provider/time_ago_provider.dart';
import '../api/api.dart';
import '../imageview.dart';
import '../show_more.dart';
import '../webview.dart';

class Launches extends StatefulWidget {
  @override
  _LaunchesState createState() => _LaunchesState();
}

class _LaunchesState extends State<Launches> {
 int _selectedChoice = 0; //default 


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
      
          return CustomScrollView(
            slivers: <Widget>
            [
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),

              /////////////////////=== Launches START ====///////////////////
              SliverStickyHeader(
                header: Container(
                  color: Colors.blueGrey[800].withOpacity(.5),
                  child: Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  alignment: WrapAlignment.spaceEvenly,
                  children: <Widget>
                  [
                    ChoiceChip(
                      backgroundColor: Colors.blueGrey[800],
                        pressElevation: 10,
                      onSelected: (bool selected) => setState(() =>  _selectedChoice = 0),                    
                      selected: _selectedChoice == 0,
                        selectedColor: Colors.cyan[600],
                        elevation: 5,
                        label: Text("All", style: TextStyle(color: Colors.white),),
                      ),
                    ChoiceChip(
                       backgroundColor: Colors.blueGrey[800],
                        pressElevation: 10,
                      onSelected: (bool selected) => setState(() =>  _selectedChoice = 1),                    
                      selected: _selectedChoice == 1,
                        selectedColor: Colors.cyan[600],
                        elevation: 5,
                        label: Text("Past", style: TextStyle(color: Colors.white),),
                      ),
                   
                      ChoiceChip(
                       backgroundColor: Colors.blueGrey[800],                      
                        pressElevation: 10,
                        tooltip: "Upcoming Launches",
                      onSelected: (bool selected) => setState(() =>  _selectedChoice = 2),                    
                      selected: _selectedChoice == 2,
                        selectedColor: Colors.cyan[600],
                        elevation: 5,
                        label: Text("Upcoming", style: TextStyle(color: Colors.white),),
                      ),
                      
                      ChoiceChip(
                       backgroundColor: Colors.blueGrey[800],
                        pressElevation: 10,
                      onSelected: (bool selected) => setState(() =>  _selectedChoice = 3),                    
                      selected: _selectedChoice == 3,
                        selectedColor: Colors.cyan[600],
                        elevation: 5,
                        label: Text("Latest", style: TextStyle(color: Colors.white),),
                      ),
                       
                        ChoiceChip(
                       backgroundColor: Colors.blueGrey[800],
                        pressElevation: 10,
                      onSelected: (bool selected) => setState(() =>  _selectedChoice =  4),                    
                      selected: _selectedChoice == 4,
                        selectedColor: Colors.cyan[600],
                        elevation: 5,
                        label: Text("Next", style: TextStyle(color: Colors.white),),
                        ),
                      
                  ],
              ),
                ),
                
                sliver: FutureBuilder<Map<String, dynamic>>(
                  future: _selectedChoice == 0
                      ? Api.getAllLaunches()
                      : _selectedChoice == 1
                          ? Api.getPastLaunches()
                          : _selectedChoice == 2 ?
                           Api.getUpcomingLaunches() :
                            _selectedChoice == 3 ?
                             Api.getLatestLaunches() :
                              Api.getNextLaunches(),
                /*  future: _selectedChoice == 0
                      ? Api.getAllLaunches()
                      : _selectedChoice == 1
                          ? Api.getPastLaunches()
                          : Api.getUpcomingLaunches(),*/
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (!snapshot.hasError && snapshot.hasData) {
                      var response = snapshot.data;
                      if (!response["isError"]) {

                        var launches = response["data"] ?? [];
                        
                        return SliverPadding(
                          padding: const EdgeInsets.all(5.0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) 
                              {
                                return _renderLaunchItem(launches, index);
                              },
                              childCount: launches is List ?  launches.length : 1,
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
              /////////////////////=== Launches END ====///////////////////
            ],
          );
        },
      ),
    );
  }

  Widget  _renderLaunchItem(dynamic launches,int index)
  {
    return launches is List ? Card(
      child: Column(
      children: <Widget>
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>
          [
            launches[index]["flight_number"] == null ? null :
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text("Flight Nº ${launches[index]["flight_number"]}"),
            ),
            launches[index]["launch_success"] == null ? null :
            Card(
                color: launches[index]["launch_success"]
                 ? Colors.green : Colors.pink[600],
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                        child: Text("${launches[index]["launch_success"] ? "Success" : "Failure"}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)))))

          ].where((w)=> w!=null).toList(),
        ),
        Divider(),

          launches[index]["mission_name"] == null ? null :
          Text(launches[index]["mission_name"], style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),),

          launches[index]["details"] == null ? null :
            Padding(
              padding: const EdgeInsets.all(10),
              child: ShowMore(text:launches[index]["details"], maxHeight: 75),
            ),
           Divider(),
           Column(
             children: <Widget>
             [
               Padding(
                 padding: const EdgeInsets.all(2.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>
                   [
                     launches[index]["launch_year"] == null ? null :
                     Text("Launch Year: ${launches[index]["launch_year"]}", style: TextStyle(fontSize: 12)),
                    launches[index]["launch_date_unix"] == null ? null :
                     Text(TimeAgo.getTimeAgo( launches[index]["launch_date_unix"] ) == "just now" ? "Future" :TimeAgo.getTimeAgo( launches[index]["launch_date_unix"] ) , style: TextStyle(fontSize: 12)),

                   ].where((w)=> w!=null).toList(),
                 ),
               ),
               launches[index]["launch_date_local"] == null ? null :
               Padding(padding:EdgeInsets.all(2),child:Text("Launch Date: ${launches[index]["launch_date_local"]}", style: TextStyle(fontSize: 12))),
               launches[index]["static_fire_date_utc"] == null ? null :
               Padding(padding:EdgeInsets.all(2),child:Text("Static Fire Date: ${DateTime.parse(launches[index]["static_fire_date_utc"]).toLocal()}", style: TextStyle(fontSize: 12))),
               launches[index]["static_fire_date_unix"] == null ? null :
               Padding(padding:EdgeInsets.all(2),child:Text(TimeAgo.getTimeAgo( launches[index]["static_fire_date_unix"] ) == "just now" ? "Future" :TimeAgo.getTimeAgo( launches[index]["launch_date_unix"] ) , style: TextStyle(fontSize: 12))),
               //launches[index]["launch_date_utc"] == null ? null :
               //Padding(padding:EdgeInsets.all(2),child:Text("Launch Date UTC: ${DateTime.parse(launches[index]["launch_date_utc"]).toLocal()}", style: TextStyle(fontSize: 12))),
            Divider(),
            Padding(
                 padding: const EdgeInsets.all(2.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>
                   [
                     launches[index]["is_tentative"] == null ? null :
                     Text("Tentative: ${launches[index]["is_tentative"] ? "YES" : "NO"}", style: TextStyle(fontSize: 12)),
                    launches[index]["tentative_max_precision"] == null ? null :
                    Text("Tentative Max Precision: ${launches[index]["tentative_max_precision"]}", style: TextStyle(fontSize: 12)),


                   ].where((w)=> w!=null).toList(),
                 ),
               ),

             ].where((w)=>w!=null).toList(),
             
           ),
           launches[index]["mission_id"].isEmpty ? null : 
           ExpansionTile(
             title: Text("Mission ID"),
             children: <Widget>
             [
               for(int i = 0; i<launches[index]["mission_id"].length; i++) Text(launches[index]["mission_id"][i])
             ],
           ), 
           launches[index]["ships"].isEmpty ? null : 
           ExpansionTile(
             title: Text("Ships"),
             children: <Widget>
             [
               for(int i = 0; i<launches[index]["ships"].length; i++) Text(launches[index]["ships"][i])
             ],
           ), 
           launches[index]["timeline"] == null ? null : 
           ExpansionTile(
             title: Text("Timeline"),
             children: <Widget>
             [
                for (String key in launches[index]["timeline"].keys) ListTile(title: Text(key),subtitle: Text(launches[index]["timeline"][key].toString()))
             ].where((w)=> w!=null).toList(),
           ),
           
          launches[index]["rocket"] == null ? null : 
           ExpansionTile(
             title: Text("Rocket"),
             children: <Widget>
             [
                launches[index]["rocket"]["rocket_id"] == null ? null :
                ListTile(
                  title: Text("Rocket ID"),
                  subtitle: Text(launches[index]["rocket"]["rocket_id"])
                ),

                launches[index]["rocket"]["rocket_name"] == null ? null :
                ListTile(
                  title: Text("Rocket Name"),
                  subtitle: Text(launches[index]["rocket"]["rocket_name"])
                ),

                launches[index]["rocket"]["rocket_type"] == null ? null :
                ListTile(
                  title: Text("Rocket Type"),
                  subtitle: Text(launches[index]["rocket"]["rocket_type"])
                ),
                launches[index]["rocket"]["first_stage"] == null ? null :
                ExpansionTile(
                  title: Text("Cores"),
                  children: <Widget>
                  [

                    launches[index]["rocket"]["first_stage"]["cores"].isEmpty ? null :
                    Builder(
                      builder: (c)
                      {
                        List<Text> coreSerials = [];
                        for(int i = 0; i<launches[index]["rocket"]["first_stage"]["cores"].length; i++)
                        {
                          coreSerials.add(Text(launches[index]["rocket"]["first_stage"]["cores"][i]["core_serial"]));
                        }
                        return Column(children: coreSerials);
                      },
                    )
                                     
                   ]
                ),
    


             ].where((w)=> w!=null).toList(),
           ),
           
         
          launches[index]["launch_site"] == null ? null :
                ExpansionTile(
                  title: Text("Launch Site"),
                  
                    children: <Widget>
                    [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        [
                          launches[index]["launch_site"]["site_id"] == null ? null :
                          Text("-Site ID:  ${launches[index]["launch_site"]["site_id"]}"),
                          launches[index]["launch_site"]["site_name"] == null ? null :
                          Text("-Site Nmae:  ${launches[index]["launch_site"]["site_name"]}"),
                          launches[index]["launch_site"]["site_name_long"] == null ? null :
                          Text("-Site Name Long:  ${launches[index]["launch_site"]["site_name_long"]}"),

                        ].where((w)=> w!=null).toList()
                        ),
                      ),



                    ].where((w)=> w != null).toList(),
                
                ),



                launches[index]["telemetry"] == null ? null :
                launches[index]["telemetry"]["flight_club"] == null ? null :
                ListTile(
                  title: Text("Telemetry"),
                  subtitle: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.downToUp,
                                  child: WebView(
                                      url: launches[index]["telemetry"]["flight_club"],
                                      name: launches[index]["telemetry"]["flight_club"]),
                                  duration: Duration(seconds: 1))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Flight Club",
                                style: TextStyle(
                                    color: Colors.cyan[600],
                                    fontWeight: FontWeight.w600)),
                          ),
                        )
                ), 

              // links,
                launches[index]["links"] == null ? null : 
                ExpansionTile(
                  title: Text("Links"),
                  children: <Widget>
                  [
                     Builder(builder: (c)
                     {
                        List<ListTile> links = [];
                        for (String key in launches[index]["links"].keys)
                        {
                          if(key != "flickr_images") //because we are going to display flickr images in their own expansion tile.
                          {
                           if( launches[index]["links"][key] != null )
                             links.add(
                               ListTile(
                                 title: Text(key),
                                 subtitle: InkWell(
                                 onTap: () => Navigator.push(
                                  context,
                                 PageTransition(
                                  type: PageTransitionType.downToUp,
                                  child: WebView(
                                      url: launches[index]["links"][key],
                                      name: key),
                                  duration: Duration(seconds: 1))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(launches[index]["links"][key],
                                style: TextStyle(
                                    color: Colors.cyan[600],)),
                          ),
                          )));
                          }
                        }
                        return Column(children:links);
                     },
                     )
                  ].where((w)=> w!=null).toList(),
                ),
                


           launches[index]["links"]["flickr_images"].isEmpty ? null :
            ExpansionTile(
              title: Text("Flickr Images"),
              children: <Widget>
              [
                      Builder(
                          builder: (c)
                          {
                            List<Widget> images = [];
                            for(int i =0; i<launches[index]["links"]["flickr_images"].length; i++)
                            {
                              images.add(InkWell(
                                child: Container(
                                  margin: EdgeInsets.all(2),
                                  child: CachedNetworkImage(
                                          height: 100,
                                          width: 100,
                                          fadeInDuration: Duration(seconds: 2),// default 700ms
                                          fadeInCurve: Curves.fastLinearToSlowEaseIn,
                                          fit: BoxFit.cover,
                                          imageUrl: launches[index]["links"]["flickr_images"][i],
                                          placeholder:(context, url)=> CircularProgressIndicator(),
                                          errorWidget:(context, url, error)=> Icon(Icons.cloud_off),
                                        ),
                                ),
                                onTap: ()=> Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.leftToRight,
                                    child: ImageView(
                                          url: launches[index]["links"]["flickr_images"][i],
                                    ),
                                    duration: Duration(milliseconds: 750)))));
                            }
                            return  Wrap(children: images);
                          },
                  ),

                
              ]
            ),
            
        
      ].where((w)=> w!=null).toList()
      ),
    ) 
    : 
     Card(
      child: Column(
      children: <Widget>
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>
          [
            launches["flight_number"] == null ? null :
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text("Flight Nº ${launches["flight_number"]}"),
            ),
            launches["launch_success"] == null ? null :
            Card(
                color: launches["launch_success"] ? Colors.green : Colors.pink[600],
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                        child: Text("${launches["launch_success"] ? "Success" : "Failure"}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)))))

          ].where((w)=> w!=null).toList(),
        ),
        Divider(),

          launches["mission_name"] == null ? null :
          Text(launches["mission_name"], style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),),

          launches["details"] == null ? null :
            Padding(
              padding: const EdgeInsets.all(10),
              child: ShowMore(text:launches["details"], maxHeight: 75),
            ),
           Divider(),
           Column(
             children: <Widget>
             [
               Padding(
                 padding: const EdgeInsets.all(2.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>
                   [
                     launches["launch_year"] == null ? null :
                     Text("Launch Year: ${launches["launch_year"]}", style: TextStyle(fontSize: 12)),
                    launches["launch_date_unix"] == null ? null :
                     Text(TimeAgo.getTimeAgo( launches["launch_date_unix"] ) == "just now" ? "Future" :TimeAgo.getTimeAgo( launches["launch_date_unix"] ) , style: TextStyle(fontSize: 12)),

                   ].where((w)=> w!=null).toList(),
                 ),
               ),
               launches["launch_date_local"] == null ? null :
               Padding(padding:EdgeInsets.all(2),child:Text("Launch Date: ${launches["launch_date_local"]}", style: TextStyle(fontSize: 12))),
               launches["static_fire_date_utc"] == null ? null :
               Padding(padding:EdgeInsets.all(2),child:Text("Static Fire Date: ${DateTime.parse(launches["static_fire_date_utc"]).toLocal()}", style: TextStyle(fontSize: 12))),
               launches["static_fire_date_unix"] == null ? null :
               Padding(padding:EdgeInsets.all(2),child:Text(TimeAgo.getTimeAgo( launches["static_fire_date_unix"] ) == "just now" ? "Future" :TimeAgo.getTimeAgo( launches["launch_date_unix"] ) , style: TextStyle(fontSize: 12))),
            Divider(),
            Padding(
                 padding: const EdgeInsets.all(2.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>
                   [
                     launches["is_tentative"] == null ? null :
                     Text("Tentative: ${launches["is_tentative"] ? "YES" : "NO"}", style: TextStyle(fontSize: 12)),
                    launches["tentative_max_precision"] == null ? null :
                    Text("Tentative Max Precision: ${launches["tentative_max_precision"]}", style: TextStyle(fontSize: 12)),


                   ].where((w)=> w!=null).toList(),
                 ),
               ),

             ].where((w)=>w!=null).toList(),
             
           ),
           launches["mission_id"].isEmpty ? null : 
           ExpansionTile(
             title: Text("Mission ID"),
             children: <Widget>
             [
               for(int i = 0; i<launches["mission_id"].length; i++) Text(launches["mission_id"][i])
             ],
           ), 
           launches["ships"].isEmpty ? null : 
           ExpansionTile(
             title: Text("Ships"),
             children: <Widget>
             [
               for(int i = 0; i<launches["ships"].length; i++) Text(launches["ships"][i])
             ],
           ), 
           launches["timeline"] == null ? null : 
           ExpansionTile(
             title: Text("Timeline"),
             children: <Widget>
             [
                for (String key in launches["timeline"].keys) ListTile(title: Text(key),subtitle: Text(launches["timeline"][key].toString()))
             ].where((w)=> w!=null).toList(),
           ),
           
          launches["rocket"] == null ? null : 
           ExpansionTile(
             title: Text("Rocket"),
             children: <Widget>
             [
                launches["rocket"]["rocket_id"] == null ? null :
                ListTile(
                  title: Text("Rocket ID"),
                  subtitle: Text(launches["rocket"]["rocket_id"])
                ),

                launches["rocket"]["rocket_name"] == null ? null :
                ListTile(
                  title: Text("Rocket Name"),
                  subtitle: Text(launches["rocket"]["rocket_name"])
                ),

                launches["rocket"]["rocket_type"] == null ? null :
                ListTile(
                  title: Text("Rocket Type"),
                  subtitle: Text(launches["rocket"]["rocket_type"])
                ),
                launches["rocket"]["first_stage"] == null ? null :
                ExpansionTile(
                  title: Text("Cores"),
                  children: <Widget>
                  [

                    launches["rocket"]["first_stage"]["cores"].isEmpty ? null :
                    Builder(
                      builder: (c)
                      {
                        List<Text> coreSerials = [];
                        for(int i = 0; i<launches["rocket"]["first_stage"]["cores"].length; i++)
                        {
                          coreSerials.add(Text(launches["rocket"]["first_stage"]["cores"][i]["core_serial"]));
                        }
                        return Column(children: coreSerials);
                      },
                    )
                                     
                   ]
                ),
    


             ].where((w)=> w!=null).toList(),
           ),
           
         
          launches["launch_site"] == null ? null :
                ExpansionTile(
                  title: Text("Launch Site"),
                  
                    children: <Widget>
                    [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        [
                          launches["launch_site"]["site_id"] == null ? null :
                          Text("-Site ID:  ${launches["launch_site"]["site_id"]}"),
                          launches["launch_site"]["site_name"] == null ? null :
                          Text("-Site Nmae:  ${launches["launch_site"]["site_name"]}"),
                          launches["launch_site"]["site_name_long"] == null ? null :
                          Text("-Site Name Long:  ${launches["launch_site"]["site_name_long"]}"),

                        ].where((w)=> w!=null).toList()
                        ),
                      ),



                    ].where((w)=> w != null).toList(),
                
                ),



                launches["telemetry"] == null ? null :
                launches["telemetry"]["flight_club"] == null ? null :
                ListTile(
                  title: Text("Telemetry"),
                  subtitle: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.downToUp,
                                  child: WebView(
                                      url: launches["telemetry"]["flight_club"],
                                      name: launches["telemetry"]["flight_club"]),
                                  duration: Duration(seconds: 1))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Flight Club",
                                style: TextStyle(
                                    color: Colors.cyan[600],
                                    fontWeight: FontWeight.w600)),
                          ),
                        )
                ), 

              // links,
                launches["links"] == null ? null : 
                ExpansionTile(
                  title: Text("Links"),
                  children: <Widget>
                  [
                     Builder(builder: (c)
                     {
                        List<ListTile> links = [];
                        for (String key in launches["links"].keys)
                        {
                          if(key != "flickr_images") //because we are going to display flickr images in their own expansion tile.
                          {
                           if( launches["links"][key] != null )
                             links.add(
                               ListTile(
                                 title: Text(key),
                                 subtitle: InkWell(
                                 onTap: () => Navigator.push(
                                  context,
                                 PageTransition(
                                  type: PageTransitionType.downToUp,
                                  child: WebView(
                                      url: launches["links"][key],
                                      name: key),
                                  duration: Duration(seconds: 1))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(launches["links"][key],
                                style: TextStyle(
                                    color: Colors.cyan[600],)),
                          ),
                          )));
                          }
                        }
                        return Column(children:links);
                     },
                     )
                  ].where((w)=> w!=null).toList(),
                ),
                


           launches["links"]["flickr_images"].isEmpty ? null :
            ExpansionTile(
              title: Text("Flickr Images"),
              children: <Widget>
              [
                      Builder(
                          builder: (c)
                          {
                            List<Widget> images = [];
                            for(int i =0; i<launches["links"]["flickr_images"].length; i++)
                            {
                              images.add(InkWell(
                                child: Container(
                                  margin: EdgeInsets.all(2),
                                  child: CachedNetworkImage(
                                          height: 100,
                                          width: 100,
                                          fadeInDuration: Duration(seconds: 2),// default 700ms
                                          fadeInCurve: Curves.fastLinearToSlowEaseIn,
                                          fit: BoxFit.cover,
                                          imageUrl: launches["links"]["flickr_images"][i],
                                          placeholder:(context, url)=> CircularProgressIndicator(),
                                          errorWidget:(context, url, error)=> Icon(Icons.cloud_off),
                                        ),
                                ),
                                onTap: ()=> Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.leftToRight,
                                    child: ImageView(
                                          url: launches["links"]["flickr_images"][i],
                                    ),
                                    duration: Duration(milliseconds: 750)))));
                            }
                            return  Wrap(children: images);
                          },
                  ),

                
              ]
            ),
            
        
      ].where((w)=> w!=null).toList()
      ),
    ) ;

  }

}