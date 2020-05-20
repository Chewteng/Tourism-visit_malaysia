import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:visit_malaysia/infopage.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visit_malaysia/location.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double screenHeight, screenWidth;
   //bool _rememberMe = false;
  List locdata;
  String titlecenter;
  //bool _visiblestates = false;
  String selectedState;
  String titletop = "";
  String curstate = "Kedah";
  List _state = [
    "Johor",
    "Kedah",
    "Kelantan",
    "Perak",
    "Selangor",
    "Melaka",
    "Negeri Sembilan",
    "Pahang",
    "Perlis",
    "Penang",
    "Sabah",
    "Sarawak",
    "Terengganu",
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Love Malaysia',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                // Visibility(
                //  visible: _visiblestates,
                Card(
                  elevation: 5,
                  child: Container(
                    height: screenHeight / 14,
                    margin: EdgeInsets.all(2),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //Icon(Icons.search),
                          Text(
                            "Select State: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                              flex: 4,
                              child: DropdownButton(
                                //sorting dropdownoption
                                hint: Text(
                                  'State',
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: selectedState,

                                onChanged: (newValue) {
                                  setState(() {
                                    selectedState = newValue;
                                   // _rememberMe = true;
                                    //selectedLocal = null;
                                  });
                                  _loadDataLocality(selectedState);
                                },
                                items: _state.map((selectedState) {
                                  return DropdownMenuItem(
                                    child: new Text(selectedState,
                                        style:
                                            TextStyle(color: Colors.blue[600])),
                                    value: selectedState,
                                  );
                                }).toList(),
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            curstate,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                ),

                locdata == null
                    ? Flexible(
                        child: Container(
                            child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Loading",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      )))
                    : Expanded(
                        child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio:
                                (screenWidth / screenHeight) / 0.65,
                            children: List.generate(locdata.length, (index) {
                              return Container(
                                  child: Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () => {
                                                _onLocationDisplay(index),
                                              },
                                              child: Container(
                                                height: screenHeight / 4.5,
                                                width: screenWidth / 2.0,
                                                decoration: BoxDecoration(
                                                    color: Colors.blue[400],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          blurRadius: 3,
                                                          spreadRadius: 2)
                                                    ]),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.fill,
                                                      imageUrl:
                                                          "http://slumberjer.com/visitmalaysia/images/${locdata[index]['imagename']}",
                                                      placeholder: (context,
                                                              url) =>
                                                          new CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(Icons.error),
                                                    )),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(locdata[index]['loc_name'],
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(locdata[index]['state'],
                                                maxLines: 1,
                                                style: TextStyle(
                                                    //fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      )));
                            }))),
              ],
            ),
          ),
        ));
  }

  _onLocationDisplay(int index) async {
    Locations location = new Locations(
      pid: locdata[index]["pid"],
      locName: locdata[index]["loc_name"],
      state: locdata[index]["state"],
      description: locdata[index]["description"],
      latitude: locdata[index]["latitude"],
      longitude: locdata[index]["longitude"],
      url: locdata[index]["url"],
      contact: locdata[index]["contact"],
      address: locdata[index]["address"],
      imagename: locdata[index]["imagename"],
    );

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => InfoPage(
                  location: location,
                )));

    _loadData();
  }

  void _loadDataLocality(String state) {
    String urlLoadLoc =
        "http://slumberjer.com/visitmalaysia/load_destinations.php";
    http.post(urlLoadLoc, body: {
      "state": state,
    }).then((res) {
      print(res.body);
      setState(() {
        //curaddress = lc;
        if (res.body == "nodata") {
          locdata = null;
          titlecenter = "No location can be found";
          //titletop = "Carian menjumpai sebarang produk";

          Toast.show("No location can be found in this state", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          //pr.dismiss();
        } else {
          curstate = state;
          var extractdata = json.decode(res.body);
          locdata = extractdata["locations"];
          // titletop = "Carian menjumpai "+ extractdata["products"].length.toString()+" produk";
          savepref(true);
          //  pr.dismiss();
        }
        //pr.dismiss();
      });
      // pr.dismiss();
    }).catchError((err) {
      print(err);
      //pr.dismiss();
    }).timeout(const Duration(seconds: 5), onTimeout: () {
      print("timeout");
      // pr.dismiss();
    }).then((value) => {
          //pr.dismiss()
        });
    // pr.dismiss();
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String state = (prefs.getString('state')) ?? '';
    setState(() {
      this.curstate = state;
   // _rememberMe = true;
    });
  }

  void savepref(bool value) async {
    
    String state = curstate;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      
      await prefs.setString('state', state);
      Toast.show("Preferences have been saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      //delete preference
      await prefs.setString('state', '');
      setState(() {
        //  _rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void _loadData() {
    String urlLoadLocs =
        "http://slumberjer.com/visitmalaysia/load_destinations.php";
    http.post(urlLoadLocs, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        locdata = extractdata["locations"];
        _loadDataLocality(curstate);
        // _visiblestates = false;
      });
    }).catchError((err) {
      print(err);
    });
  }

  Future<bool> _onBackPressed() {
    savepref(true);
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: new Text(
              'Do you want to exit Love Malaysia',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Colors.blue[600],
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.blue[600],
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }
}
