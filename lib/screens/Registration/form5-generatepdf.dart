import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formc_showcase/screens/regn_wizard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/formC_constants.dart';
import '../../models/Registration/AccoProfileModel.dart';
import '../../util/httpUtil.dart';
import '../splashScreen.dart';

class GeneratePdfForApproval extends StatefulWidget {
  AccomodatorModel data = AccomodatorModel();
  GeneratePdfForApproval({Key? key, required this.data}) : super(key: key);

  @override
  State<GeneratePdfForApproval> createState() => _GeneratePdfForApprovalState();
}

class _GeneratePdfForApprovalState extends State<GeneratePdfForApproval> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController _nationalityController = new TextEditingController();
  var nationality, accoCode, frroCode, userId;
  // UpdateProfile updateUsrObj = UpdateProfile();
  bool buttonEnabled = true;
  // List<CountryModel> countryList = [];
  bool dobFromOnchanged = false;
  back() {
    //print('Previous Page: P0');
    Navigator.pop(context);
  }

  static Future<List> getAccoDts(
      String accoCode, String frroCode, String userId) async {
    EasyLoading.show(status: 'Please Wait...');
    var frroList;
    //print('passedState :$passedstate');
    //print(GET_DISTRICT_URL + '$passedstate');
    var response = await http.get(
        Uri.parse(GET_ACCOM_DETAILS +
            '$accoCode&frro_fro_code=$frroCode&userid=$userId'),
        headers: {
          "Accept": "application/json",
          //  'Authorization': 'Bearer $token'
        });
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200)
      frroList = (responseBody as List)
          .map((i) => new AccomodatorModel.fromJson(i))
          .toList();
    EasyLoading.dismiss();

    return frroList;
  }

  next() {
    if (_fbKey.currentState!.saveAndValidate()) {
      // postPersonalDetailsData();
      // Navigator.of(context)
      //     .pushReplacementNamed("/loginScreen");
      //  validateUser(getuserName);
      //   print('true');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                actions: [
                  TextButton(
                    child: new Text('Ok', style: TextStyle(color: blue)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                title: Text(" Please enter the mandatory field "),
              ));
    }
    // enableButton(false);

    // Navigator.push(context, MaterialPageRoute( builder: (context) => FRRO_P1()),);
  }

  enableButton(bool flag) {
    setState(() {
      buttonEnabled = flag;
    });
  }

  isEnabled() {
    return buttonEnabled;
  }

  RegnWizard? stepsWizard;
  @override
  void initState() {
    super.initState();
    setState(() {
      //  page1 = widget.data;
      stepsWizard = new RegnWizard(currentPageNo: "5");
    });
    getAccoDts(accoCode, frroCode, userId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0), // here the desired height
            child: AppBar(
              backgroundColor: blue,
              leading: Container(),
              // leading: IconButton(
              //   icon: Icon(Icons.arrow_back, color: Colors.white),
              //   onPressed: () => Navigator.of(context).pop(),
              // ),
              title: Text('Form C'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    // getLogResponse();
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Exit App'),
                        content: Text('Do you want to exit an App?'),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: blue,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },

                            //return false when click on "NO"
                            child: Text('No'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: blue,
                            ),
                            onPressed: () {
                              HttpUtils().clearTokens();
                              Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => SplashScreen()));
                            },
                            //return true when click on "Yes"
                            child: Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
              centerTitle: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(50),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: FormBuilder(
              key: _fbKey,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(' Form C Details ',
                      style: TextStyle(
                          //   decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: blue)),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ExpansionTileCard(
                      animateTrailing: true,
                      colorCurve: Curves.easeIn,
                      leading: CircleAvatar(
                          backgroundColor: blue,
                          child: Icon(
                            FontAwesomeIcons.solidAddressBook,
                            color: Colors.white,
                          )),
                      title: Text('Address Details',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              color: Colors.black)),
                      subtitle: Text(
                        // snapshot.data[index]['addroutind'] != null
                        //     ? 'Address : ${snapshot.data[index]['addroutind']}'
                        //     : 'Address Outside India : ',
                        "",
                        style: TextStyle(fontSize: 17, color: Colors.black),
                        // textAlign: TextAlign.center,
                      ),
                      children: <Widget>[
                        // onTap: getImage,

                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(17, 64, 113, 1.0),
                                Colors.grey[900]!
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  // snapshot.data[index]['cityoutind'] != null
                                  //     ? 'City: ${snapshot.data[index]['cityoutind']}'
                                  //     : 'City Outside India:  ',
                                  "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: Colors.white),
                                  //  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  // snapshot.data[index]['counoutindDesc'] != null
                                  //     ? 'Country: ${snapshot.data[index]['counoutindDesc']}'
                                  //     : 'Country Outside India: ',
                                  "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: Colors.white),
                                  //  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: blue,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(10)),
                  ),
                  onPressed: back,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.arrow_back_ios, color: Colors.white),
                      Text("Prev",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ),
                // CustomShowcaseWidget(
                //   globalKey: keyOne,
                //   description: "applyForVisaForm_P1.highlightMenu",
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: stepsWizard,
                //   ),
                // ),
                //   DotsIndicator( dotsCount: totalPage, position: totalPage.toDouble()),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(10)),
                  ),
                  onPressed: isEnabled() ? next : null,
                  child: Row(
                    children: <Widget>[
                      Text("Next",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
