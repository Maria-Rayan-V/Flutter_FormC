import 'dart:convert';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/models/formCdataModel.dart';
import 'package:formc_showcase/services/formC_commonServices.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'checkIn/form6_reference&otherDetails.dart';
import 'checkIn/form3_personalDetails.dart';
import 'checkIn/form4_PassportVisa.dart';
import 'checkIn/form5_arrivalNxtDest.dart';
import 'package:formc_showcase/screens/checkIn/form1_applicationGeneration.dart';
import 'package:formc_showcase/screens/checkIn/form2_photoUpload.dart';

class FormCWizardMenuItem extends StatefulWidget {
  String? passportNumberInWizard, nationalityInWizard;
  String? currentPageNo, applicationId;
  FormCWizardMenuItem.editFormCTempApplication(
      {this.applicationId, this.currentPageNo});
  FormCWizardMenuItem(
      {this.passportNumberInWizard,
      this.nationalityInWizard,
      this.currentPageNo});

  @override
  _FormCWizardMenuItemState createState() => _FormCWizardMenuItemState();
}

class _FormCWizardMenuItemState extends State<FormCWizardMenuItem>
    with SingleTickerProviderStateMixin {
  var page;
  AnimationController? animationController;
  Map<String, dynamic>? _formCDetailsinJson;
  Map<String, dynamic>? _formCPendingDetailsinJson;
  List<FormCDataModel>? _formCPendingDetails;
  List<FormCDataModel>? _formCDetails;
  bool moveToNextForm = false;
  var steps = [
    {"stepId": "1", "stepName": "Generate Application Id"},
    {"stepId": "2", "stepName": "Upload Photo"},
    {"stepId": "3", "stepName": "Personal Details"},
    {"stepId": "4", "stepName": "Passport & Visa Details"},
    {"stepId": "5", "stepName": "Arrival & Next Destination Details"},
    {"stepId": "6", "stepName": "Reference & Other Details"},
  ];
  Future getFormCDetailsById(String tmpFileNumber) async {
    // var token = await httpUtils.HttpUtils().getToken();
    var response = await http.get(
        Uri.parse(GET_APPLICANT_FULLDETAILS_URL + '$tmpFileNumber'),
        headers: {
          "Accept": "application/json",
          //'Authorization': 'Bearer $token'
        });
    var responseBody = json.decode(response.body);
    //print('response statuscode :${response.statusCode}');
    if (response.statusCode == 200) moveToNextForm = true;
    //print('response body : ${response.body}');
    var formCFullDetails = (responseBody as List)
        .map((i) => new FormCDataModel.fromJson(i))
        .toList();
    return formCFullDetails;
  }

  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();

    if (widget.passportNumberInWizard != null &&
        widget.nationalityInWizard != null) {
      FormCCommonServices.getApplicantDetailByPassportNo(
              widget.passportNumberInWizard!, widget.nationalityInWizard!)
          .then((result) {
        setState(() {
          _formCDetails = result;
        });

        //  //print('frrodetails ${_formCDetails[0].givenName}');
      });
    }
    WidgetsBinding.instance
        .addPostFrameCallback((_) => animationController!.forward(from: 0.0));
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

/*  child: Icon(
  Icons.open_with_rounded,
  color: Colors.blueAccent,
  ),*/
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

  void moveToPendingDataScreen(
      String applicationId, page, BuildContext context) async {
    _formCPendingDetails =
        await FormCCommonServices.getPendingDetailsByApplId(applicationId);
    //print('Inside Pending Switcj');
    //print('Move to penfding screen');
    //print('inside pending switch $_formCPendingDetails');
    switch (page) {
      case "1":
        page = new ApplicationGeneration(
          data: _formCPendingDetails,
        );
        break;
      case "2":
        page = new FormCPhotoUploadScreen(
          data: _formCPendingDetails,
        );
        break;

      case "3":
        page = new PersonalDetailsScreen(
          data: _formCPendingDetails,
        );
        break;
      case "4":
        page = new PassportVisaArrivalForm(
          data: (_formCPendingDetails),
        );
        break;
      case "5":
        page = new ArrivalNxtDestScreen(
          data: (_formCPendingDetails),
        );
        break;
      case "6":
        page = new ReferenceOtherScreen(
          data: (_formCPendingDetails),
        );
        break;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void moveToScreen(String passportNumber, String nationality, page,
      BuildContext context) async {
    _formCDetailsinJson = Map();
    _formCDetails = await FormCCommonServices.getApplicantDetailByPassportNo(
        passportNumber, nationality);
    //print('inside switch $_formCDetails');

    //print("MOVE TO SCREEN");
    switch (page) {
      case "1":
        page = new ApplicationGeneration(
          data: _formCDetails,
        );
        break;
      case "2":
        page = new FormCPhotoUploadScreen(
          data: _formCDetails,
        );
        break;

      case "3":
        page = new PersonalDetailsScreen(
          data: _formCDetails,
        );
        break;
      case "4":
        page = new PassportVisaArrivalForm(
          data: (_formCDetails),
        );
        break;
      case "5":
        page = new ArrivalNxtDestScreen(
          data: (_formCDetails),
        );
        break;
      case "6":
        page = new ReferenceOtherScreen(
          data: (_formCDetails),
        );
        break;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
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
}
