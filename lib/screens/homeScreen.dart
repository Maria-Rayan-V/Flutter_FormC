import 'package:flutter/material.dart';
import 'package:formc_showcase/Widgets/sideDrawer.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:formc_showcase/screens/splashScreen.dart';
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class FormCHomeScreen extends StatefulWidget {
  @override
  _FormCHomeScreenState createState() => _FormCHomeScreenState();
}

class _FormCHomeScreenState extends State<FormCHomeScreen> {
  var qrcodeScanRes;
  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit an App?'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: blue,
                ),
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text('No'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: blue,
                ),
                onPressed: () => SystemNavigator.pop(),
                //return true when click on "Yes"
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  final keyOne = GlobalKey();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  var loggedUser, loggedaccoCode, loggedFrroCode, lastLogin, token, accoName;
  getSecureStorageData() async {
    loggedFrroCode = await HttpUtils().getFrrocode();
    loggedUser = await HttpUtils().getUsername();
    loggedaccoCode = await HttpUtils().getAccocode();
    lastLogin = await HttpUtils().getLastLogin();
    token = await HttpUtils().getToken();
    accoName = await HttpUtils().getAccoName();
    setState(() {
      loggedFrroCode = loggedFrroCode;
      token = token;
      if (loggedUser != null) loggedUser = loggedUser.toUpperCase();
      loggedaccoCode = loggedaccoCode;
      lastLogin = lastLogin;

      if (accoName != null) accoName = accoName.toUpperCase();
    });
  }

  var logoutResponse;
  Future getLogResponse() async {
    logoutResponse = await http.post(Uri.parse(LOGOUT_URL), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    }).then((response) {
      //  print('${response.body}' + '${response.statusCode}');
      if (response.statusCode == 200)
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => SplashScreen()));
    });

    // print(resBody4);
  }

  Future<void> scanQR() async {
    try {
      qrcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      // print(qrcodeScanRes);
    } on PlatformException {
      qrcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      qrcodeScanRes = qrcodeScanRes;
    });
  }

  @override
  void initState() {
    super.initState();
    getSecureStorageData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HOMEPAGESCROLLIMAGELIST.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
  }

  late var context;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setState(() => this.context = context);
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(size.height * 0.09), // here the desired height
            child: AppBar(
              backgroundColor: blue,
              leading: IconButton(
                icon: Icon(Icons.menu, size: 40), // change this size and style
                onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              ),
              title: Text(
                'Form C',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4),
              ),
              actions: [
                // Padding(
                //     padding: EdgeInsets.only(right: 20.0),
                //     child: GestureDetector(
                //         onTap: () {
                //           // _scanBytes().then((value) {
                //           //   print('scannedvalue $value');
                //           // });
                //           scanQR();
                //         },
                //         child: Column(children: <Widget>[
                //           Icon(
                //             Icons.scanner,
                //             size: 30,
                //           ),
                //           Text("Scan QR")
                //         ]))),
              ],
              centerTitle: true,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.vertical(
              //     bottom: Radius.circular(50),
              //   ),
              // ),
            ),
          ),
          drawer: FormCSideDrawer(),
          body: Column(
              //  mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.grey[200],
                  elevation: 10,
                  child: ListTile(
                      leading: CircleAvatar(
                        // minRadius: 40,
                        // radius: 50,
                        maxRadius: 40,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            AssetImage('assets/images/hotel_image.png'),
                      ),
                      title: loggedUser != null
                          ? Text('USERNAME: $loggedUser')
                          : Text(''),
                      subtitle: accoName != null
                          ? Text(
                              accoName,
                              style: TextStyle(color: Colors.black),
                            )
                          : Text('')),
                ),
                // Container(
                //   padding: EdgeInsets.only(left: size.width * 0.2),
                //   child: Table(
                //     columnWidths: {0: FractionColumnWidth(.4)},
                //     textDirection: ui.TextDirection.ltr,
                //     children: [
                //       TableRow(children: [
                //         Padding(
                //           padding: EdgeInsets.all(8.0),
                //           child: Text(
                //             'Username:',
                //             style: TextStyle(
                //               //   color: blue,
                //               fontSize: 15,
                //             ),
                //           ),
                //         ),
                //         Padding(
                //           padding: EdgeInsets.all(8.0),
                //           child: Text(
                //             '${loggedUser}',
                //             style: TextStyle(
                //               color: blue,
                //               fontSize: 16,
                //             ),
                //           ),
                //         ),
                //       ]),
                //       TableRow(children: [
                //         Padding(
                //           padding: EdgeInsets.all(8.0),
                //           child: Text(
                //             'Accommodator Name:',
                //             style: TextStyle(
                //               //   color: blue,
                //               fontSize: 15,
                //             ),
                //           ),
                //         ),
                //         Padding(
                //           padding: EdgeInsets.all(8.0),
                //           child: Text(
                //             '${accoName}',
                //             style: TextStyle(
                //               color: blue,
                //               fontSize: 16,
                //             ),
                //           ),
                //         ),
                //       ]),
                //     ],
                //   ),
                // ),
                if (imageSliders != null)
                  Container(
                    child: CarouselSlider(
                        options: CarouselOptions(autoPlay: true),
                        items: imageSliders),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Any Hotel/ Guest House/ Dharmashala/Individual House/ University/ Hospital/ Institute/ Others etc. who provide accommodation to foreigners must submit the details of the residing foreigner in Form C to the Registration authorities within 24 hours of the arrival of the foreigner at their premises. This will help the registration authorities in locating and tracking the foreigners. This document provides the functionality of registration process of Hotel/ Guest House/ Dharmashala/Individual House / University/  Hospital/ Institute/ Others etc. owners for Form-C.',
                            style: TextStyle(
                              fontSize: 16,
                              //  fontWeight: FontWeight.w500,
                              color: Colors.black,
                              letterSpacing: 1,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ])),
    );
  }
}

final List<Widget> imageSliders = HOMEPAGESCROLLIMAGELIST
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 400.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();
