import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visit_malaysia/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InfoPage extends StatefulWidget {
  final Locations location;
  const InfoPage({Key key, this.location}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List locdata;

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    double lat = double.parse(widget.location.latitude);
    double log = double.parse(widget.location.longitude);

    setState(() {
      _markers.clear();

      final marker = Marker(
        markerId: MarkerId(widget.location.locName),
        position: LatLng(lat, log),
        infoWindow: InfoWindow(
          title: widget.location.locName,
          snippet: widget.location.address,
        ),
      );
      _markers[widget.location.locName] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Details Description'),
        ),
        body: Container(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
          Container(
            //alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black26,
                image: DecorationImage(
                    image: NetworkImage(
                        "http://slumberjer.com/visitmalaysia/images/${widget.location.imagename}?"),
                    fit: BoxFit.fill)),
            height: 350,
          ),
          SizedBox(
            height: 15,
          ),
          Card(
              child: Table(defaultColumnWidth: FlexColumnWidth(1.0),
                  //columnWidths: {
                  // 0: FlexColumnWidth(8),
                  //1: FlexColumnWidth(6.5),
                  //},
                  children: [
                TableRow(children: [
                  TableCell(
                      child: Column(mainAxisSize: MainAxisSize.min,
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                        Container(
                            alignment: Alignment.topLeft,
                            //height: 150,
                            child: Text(widget.location.locName,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                      ])),
                ]),
                TableRow(children: [
                  TableCell(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                        Container(
                            alignment: Alignment.topLeft,
                            //height: 150,
                            child: Text(widget.location.address,
                                style: TextStyle(
                                    fontSize: 16,
                                    //fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                      ])),
                ]),
              ])),
          Card(
              child: Column(
                  children: <Widget>[
                  Align(alignment: Alignment.centerLeft,),
                  
                Text(
                  "For more details:",
                  style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w900)
                ),
                SizedBox(height: 5,),
                Table(defaultColumnWidth: FlexColumnWidth(1.0), columnWidths: {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(6.5),
                }, children: [
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            width: 3,
                          ),
                          Icon(
                            Icons.link,
                            // size: 40,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                              alignment: Alignment.center,

                              // height: 40,
                              child: Text("URL: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                        ],
                      ),
                    ),
                    TableCell(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () =>
                              _launchInUrl("https://${widget.location.url}?"),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            //height: 40,
                            child: Text(widget.location.url,
                                style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white)),
                          ),
                        )
                      ],
                    )),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            width: 3,
                          ),
                          Icon(
                            Icons.phone,
                            // size: 40,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                              alignment: Alignment.center,
                              //height: 20,
                              child: Text("Phone: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                        ],
                      ),
                    ),
                    TableCell(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => _callPhone(context),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                //height: 20,
                                child: Text(widget.location.contact,
                                    style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white)),
                              ),
                            ),
                          ]),
                    )
                  ]),
                ]),
                SizedBox(
                  height: 15,
                ),
                _googleMap(context),
                SizedBox(
                  height: 10,
                ),
                Card(
                    child: Table(
                        defaultColumnWidth: FlexColumnWidth(1.0),
                        columnWidths: {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(6.5),
                    },
                        children: [
                      TableRow(children: [
                        TableCell(
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                              SizedBox(
                                width: 3,
                              ),
                              Icon(
                                Icons.note,
                                // size: 40,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  //height: 150,
                                  child: Text("Description: ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))),
                            ])),
                        TableCell(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                //height: 150,
                                child: Text(widget.location.description,
                                    style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ])),
                SizedBox(
                  height: 10,
                ),
              ]))
        ]))));
  }

  _callPhone(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Make a phone call' + '?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _makePhoneCall('tel:' + widget.location.contact);
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Colors.blue[600],
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "No",
                style: TextStyle(
                  color: Colors.blue[600],
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _googleMap(BuildContext context) {
    double lat = double.parse(widget.location.latitude);
    double log = double.parse(widget.location.longitude);
    return Container(
      height: 250,
      width: 400,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, log),
          zoom: 12,
        ),
        markers: _markers.values.toSet(),
        mapType: MapType.normal,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        rotateGesturesEnabled: true,
        myLocationEnabled: true,
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
