import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:formc_showcase/screens/Auth/userRegn.dart';
import 'package:formc_showcase/screens/Auth/validateUsername.dart';
import 'package:formc_showcase/screens/homeScreen.dart';
import 'package:formc_showcase/screens/splashScreen.dart';
import 'package:formc_showcase/util/spUtil.dart';
import 'package:formc_showcase/screens/checkOut/checkOutSearchScreen.dart';
import 'package:formc_showcase/screens/checkIn/form4_PassportVisa.dart';
import 'package:formc_showcase/screens/checkIn/ExistingFormCAppl_search.dart';
import 'package:formc_showcase/screens/checkIn/form2_photoUpload.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/src/services/asset_bundle.dart';

import 'services/globals.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<bool> addSelfSignedCertificate() async {
  ByteData data = await rootBundle.load('assets/raw/burpsuite.pem');
  //ByteData data = await rootBundle.load('assets/raw/certificate.pem');
  SecurityContext context = SecurityContext.defaultContext;
  context.setTrustedCertificatesBytes(data.buffer.asUint8List());
  return true;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  assert(await addSelfSignedCertificate());
  await SpUtil.getInstance();
  runApp(MyApp());
}

void configLoading() {
  EasyLoading.instance..userInteractions = false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    configLoading();
    return new MaterialApp(
        theme: ThemeData(primaryColor: blue),
        navigatorKey: navigatorKey,
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: snackbarKey,
        routes: {
          '/validateUser': (context) => ValidateUserScreen(),

          // '/photoUploadScreen': (context) => FormCPhotoUploadScreen(),
          '/checkInSearch': (context) => CheckInSearch(),
          //'/loginScreen': (context) => FormCLogin(),
          '/homeScreen': (context) => FormCHomeScreen(),
          '/userRegn': (context) => UserRegnScreen(),
          // '/accomodatorProfile': ((context) => AccomodatorProfile())
          // '/searchScreen':(context)=>
        },
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false, body: SplashScreen());
  }
}
