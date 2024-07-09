import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:formc_showcase/models/Registration/AccoProfileModel.dart';
import 'package:formc_showcase/models/masters/AccogradeModel.dart';
import 'package:formc_showcase/screens/Registration/form2-hotelInfo.dart';
import 'package:formc_showcase/screens/Registration/form3-ownerdetails.dart';
import 'package:formc_showcase/screens/Registration/form4-submitAccoDts.dart';
import 'package:formc_showcase/screens/Registration/form5-generatepdf.dart';
import '../constants/formC_constants.dart';
import '../services/formC_commonServices.dart';
import '../util/httpUtil.dart';
import 'Registration/form1-accomodatorInfo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegnWizard extends StatefulWidget {
  String? currentPageNo;
  // const RegnWizard({Key key}) : super(key: key);
  RegnWizard({this.currentPageNo});
  // @override
  // State<RegnWizard> createState() => _RegnWizardState();
  @override
  _RegnWizardState createState() => _RegnWizardState();
}

class _RegnWizardState extends State<RegnWizard>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _accoDetailsinJson;
  // var _accoDetails;
  var accoCode, frroCode, userId, serverResponse;
  var steps = [
    {"stepId": "1", "stepName": "Accommodator Information"},
    {"stepId": "2", "stepName": "Hotel Information"},
    {"stepId": "3", "stepName": "Hotel Owner Details"},
    {"stepId": "4", "stepName": "Submit For Approval"},
    {"stepId": "5", "stepName": "Generate Pdf"},
  ];

  getAccoDts(String accoCode, String frroCode, String userId) async {
    EasyLoading.show(status: 'Please Wait...');
    var token = await HttpUtils().getToken();
    //print(GET_SALT_URL + '$usernameInsideFun');

    try {
      var response = await http.get(
          Uri.parse(GET_ACCOM_DETAILS +
              '$accoCode&frro_fro_code=$frroCode&userid=$userId'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $token'
          });
      print('get acco dts response :${response.body}');

      serverResponse = (response.body as List)
          .map((i) => new AccomodatorModel.fromJson(i))
          .toList();
      print('/////////////////////');
      print('Inside function ${serverResponse['ownerDetails']}');
      print('*********************');
      if (serverResponse != "" &&
          serverResponse != null &&
          response.statusCode == 200) {
        //print('saltvalid : $salt');
        setState(() {
          // _accoDetails = serverResponse;
        });
      }

      if (response.statusCode != 200) {
        var result =
            FormCCommonServices.getStatusCodeError(response.statusCode);

        if (serverResponse != null && serverResponse["message"] != null) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                    actions: [
                      TextButton(
                        child: new Text('Ok',
                            style: TextStyle(color: Colors.blue.shade500)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          // print('user id after cleared ${userRegnObj.userId}');
                        },
                      ),
                    ],
                    title: Column(children: [
                      Text('${serverResponse["message"]}'),
                    ]));
              });
        } else {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                    actions: [
                      TextButton(
                        child: new Text('Ok', style: TextStyle(color: blue)),
                        onPressed: () {
                          // Navigator.popAndPushNamed(
                          //                   context, "/loginScreen");
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                    title: Column(children: [
                      Text('$result'),
                    ]));
              });
        }
      }
    } catch (e) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
                actions: [
                  TextButton(
                    child: new Text('Ok', style: TextStyle(color: blue)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                title: Column(children: [
                  Text('$e'),
                ]));
          });
    }
    EasyLoading.dismiss();
    return serverResponse;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        /* Fluttertoast.showToast(
            msg: "You have selected " + value.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, 
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);*/

        //  moveToScreen(widget.tmpApplId, value, context);
      },
      elevation: 10,
      child: Container(
        height: 20,
        width: 100,
/*        decoration: ShapeDecoration(
          color: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(color: Colors.lightBlue, width: 2),
          ),
        ),*/
        child: Center(
            /*  child: Text(
            stepMenuText,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),*/
            child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.0),
          child: Icon(
            Icons.open_with_rounded,
            color: Colors.blueAccent,
          ),
        )),
      ),
      itemBuilder: (context) => getPopupMenus(),
    );
  }

  List<PopupMenuItem<String>> getPopupMenus() {
    List<PopupMenuItem<String>> list = [];
    steps.forEach((element) {});
    for (var x in steps)
      list.add(new PopupMenuItem(
          value: x['stepId'],
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                child: isFilled(x['stepId']!)
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.pending_rounded,
                        color: Colors.red,
                      ),
              ),
              Text(x['stepName']!)
            ],
          )));
    return list;
  }

  isFilled(String x) {
    bool status = false;
    try {
      switch (x) {
        case "1":
          break;
        case "2":
          status = true;
          break;
        case "3":
          status = true;
          break;
        case "4":
          status = true;

          break;

        default:
          status = false;
      }
    } catch (e) {
      status = false;
    }
    return status;
  }

  void moveToRegnScreen(page, BuildContext context,
      [AccomodatorModel? _accoDetails]) async {
    _accoDetailsinJson = Map();
    // _accoDetails = await getAccoDts(accoCode, frroCode, userId);
    //print('inside switch $_formCDetails');

    //print("MOVE TO SCREEN");
    switch (page) {
      case "1":
        page = new AccomodatorInformation(
          data: _accoDetails!,
        );
        break;
      case "2":
        page = new HotelInfo(
          data: _accoDetails!,
        );
        break;

      case "3":
        page = new OwnerDetails(data: _accoDetails!);
        break;
      case "4":
        page = new SubmitAccoDts(
          data: (_accoDetails!),
        );
        break;
      case "5":
        page = new GeneratePdfForApproval(
          data: (_accoDetails!),
        );
        break;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
