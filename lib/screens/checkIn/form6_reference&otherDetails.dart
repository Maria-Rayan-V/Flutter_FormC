import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/models/masters/districtModel.dart';
import 'package:formc_showcase/models/masters/purposeModel.dart';
import 'package:formc_showcase/models/masters/stateModel.dart';
import 'package:formc_showcase/models/referenceModel.dart';
import 'package:formc_showcase/services/formC_commonServices.dart';
import 'package:formc_showcase/util/validations.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:formc_showcase/screens/formC_wizard.dart';
import 'dart:convert';
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:http/http.dart' as http;
import 'package:formc_showcase/models/masters/splCategoryModel.dart';
import 'package:formc_showcase/util/spUtil.dart';

import 'package:formc_showcase/screens/homeScreen.dart';

import 'finalConfirmationScreen.dart';

class ReferenceOtherScreen extends StatefulWidget {
  //const ReferenceOtherScreen({ Key? key }) : super(key: key);
  final dynamic data;
  ReferenceOtherScreen({Key? key, @required this.data, String? appId})
      : super(key: key);
  @override
  _ReferenceOtherScreenState createState() => _ReferenceOtherScreenState();
}

class _ReferenceOtherScreenState extends State<ReferenceOtherScreen> {
  String? givenName, surName, nextDestCoun;
  TextEditingController _splCategoryController = new TextEditingController();
  ReferenceModel referenceOtherObj = new ReferenceModel();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  FormCWizardMenuItem? stepsWizard;
  FormCWizardMenuItem? stepsWizardForPendingAppl;
  //TextEditingController _controller;
  TextEditingController _purposeController = new TextEditingController();
  TextEditingController _nextDestStateInInd = new TextEditingController();
  bool isDisablePage = false;
  bool buttonEnabled = true;
  bool? isPendingApplication;
  List<PurposeModel> povList = [];
  var formCApplicationId;
  List<DistrictModel> distInIndList = [];
  List<SplCategoryModel> editSplCatList = [];
  List<StateModel> stateList = [];
  List<SplCategoryModel> splCategoryList = [];
  List<PurposeModel> editPurpose = [];
  var passportNumberFromSearch,
      splCategory,
      nationalityFromSearch,
      finalSubmitresponse;
  finalSubmitFormCData() async {
    EasyLoading.show(status: 'Please Wait...');
    var token = await HttpUtils().getToken();
    var newApplicationId = await HttpUtils().getNewApplicationId();
    //print(FINAL_SUBMIT_URL + "$newApplicationId");
    //print('inside final func');
    try {
      await http.post(
        Uri.parse(FINAL_SUBMIT_URL + "$newApplicationId"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $token'
        },
      ).then((response) async {
        //print("Response status: ${response.statusCode}");
        //print("Response body: ${response.body}");
        finalSubmitresponse = json.decode(response.body);
        if (response.statusCode == 200) {
          // stepsWizard.createState().moveToScreen(
          //     passportNumberFromSearch, nationalityFromSearch, "6", context);
          //print('200 Success');
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    actions: [
                      TextButton(
                        child: new Text('Ok', style: TextStyle(color: blue)),
                        onPressed: () {
                          //print('navigate to home');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FormCHomeScreen()));
                        },
                      ),
                    ],
                    title: Text(
                        "Your application $newApplicationId submitted successfully"),
                  ));

          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Home()));
        }
        if (response.statusCode != 200) {
          var result =
              FormCCommonServices.getStatusCodeError(response.statusCode);

          if (finalSubmitresponse != null &&
              finalSubmitresponse["message"] != null) {
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
                          },
                        ),
                      ],
                      title: Column(children: [
                        Text('${finalSubmitresponse["message"]}'),
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
      });
    } catch (e) {
      //print('final excep:$e');
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
                      //                   context, "/homeScreen");
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                title: Column(children: [
                  Text('Something went wrong. Please try again later'),
                ]));
          });
    }
    EasyLoading.dismiss();
  }

  postReferenceOtherDetailsData() async {
    EasyLoading.show(status: 'Please Wait...');
    var token = await HttpUtils().getToken();
    var newApplicationId = await HttpUtils().getNewApplicationId();
    //print('token: $token');
    referenceOtherObj.stateofrefinind =
        await HttpUtils().getApplicantStateOfReference();
    referenceOtherObj.cityofrefinind =
        await HttpUtils().getApplicantCityOfReference();

    try {
      var data = json.encode({
        "form_c_appl_id": newApplicationId,
        "addrofrefinind": referenceOtherObj.addrofrefinind,
        "stateofrefinind": referenceOtherObj.stateofrefinind,
        "cityofrefinind": referenceOtherObj.cityofrefinind,
        "pincodeofref": referenceOtherObj.pincodeofref,
        "mblnuminind": referenceOtherObj.mblnuminind,
        "phnnuminind": referenceOtherObj.phnnuminind,
        "mblnum": referenceOtherObj.mblnum,
        "phnnum": referenceOtherObj.phnnum,
        "employedinind": referenceOtherObj.employedinind,
        "splcategorycode": referenceOtherObj.splcategorycode,
        "purposeofvisit": referenceOtherObj.purposeofvisit
      });
      //print(data);
      //print(POST_REFERENCEOTHERS_DETAILS);
      await http.post(
        Uri.parse(POST_REFERENCEOTHERS_DETAILS),
        body: data,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $token'
        },
      ).then((response) async {
        //print("Response status: ${response.statusCode}");
        //print("Response body: ${response.body}");
        var responseJson = json.decode(response.body);
        //print('ResponseJson :$responseJson');

        // //print(chkuser);
        if (response.statusCode == 200) {
          // showDialog(
          //     barrierDismissible: false,
          //     context: context,
          //     builder: (context) {
          //       return AlertDialog(
          //           actions: [
          //               TextButton(
          //               child: new Text('No',
          //                   style: TextStyle(color: blue)),
          //               onPressed: () {
          //                 Navigator.of(context).pop();

          //               },
          //             ),
          //             TextButton(
          //               child: new Text('Yes',
          //                   style: TextStyle(color: blue)),
          //               onPressed: () {
          //                 Navigator.of(context).pop();
          //                 finalSubmitFormCData();
          //               },
          //             ),
          //           ],
          //           title: Column(children: [
          //             Text('Do you want to submit the application?'),
          //           ]));
          //     });
          // stepsWizard.createState().moveToScreen(
          //     passportNumberFromSearch, nationalityFromSearch, "6", context);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FormCDetailsConfirmationScreen(newApplicationId!)));
        }
        if (response.statusCode != 200) {
          var result =
              FormCCommonServices.getStatusCodeError(response.statusCode);

          if (responseJson != null && responseJson["message"] != null) {
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
                          },
                        ),
                      ],
                      title: Column(children: [
                        Text('${responseJson["message"]}'),
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
      });
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
                      // Navigator.popAndPushNamed(
                      //                   context, "/homeScreen");
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                title: Column(children: [
                  Text('Something went wrong. Please try again later'),
                ]));
          });
    }

    EasyLoading.dismiss();
  }

  List? formCExistingData;
  getFlutterSecureStorageData() async {
    passportNumberFromSearch = await HttpUtils().getExistingFormCPptNo();
    nationalityFromSearch = await HttpUtils().getExistingFormCNationality();
    formCApplicationId = await HttpUtils().getNewApplicationId();

    setState(() {
      passportNumberFromSearch = passportNumberFromSearch;
      nationalityFromSearch = nationalityFromSearch;
      formCApplicationId = formCApplicationId;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFlutterSecureStorageData();

    isPendingApplication = SpUtil.getBool('isPendingApplication');
    // setState(() {
    //   pptIssueFromInit = true;
    //   visaIssueFromInit = true;
    // });
    FormCCommonServices.getSplCategory().then((result) {
      splCategoryList = result;
    });
    FormCCommonServices.getState().then((result) {
      stateList = result;
      //print('state $stateList');
    });
    FormCCommonServices.getPurposeOfVisit().then((result) {
      povList = result;
    });
    if (widget.data != null) {
      formCExistingData = widget.data;
    }
    if (formCExistingData != null && formCExistingData!.length > 0) {
      referenceOtherObj.addrofrefinind = formCExistingData![0].addrOfReference;
      referenceOtherObj.stateofrefinind =
          formCExistingData![0].stateOfReference;
      referenceOtherObj.cityofrefinind = formCExistingData![0].cityOfReference;
      referenceOtherObj.pincodeofref = formCExistingData![0].pincodeOfReference;
      referenceOtherObj.mblnuminind = formCExistingData![0].mobileNumberInIndia;
      referenceOtherObj.phnnuminind = formCExistingData![0].phoneNumberInIndia;
      referenceOtherObj.phnnum = formCExistingData![0].phoneNumber;
      referenceOtherObj.mblnum = formCExistingData![0].mobileNumber;
      referenceOtherObj.employedinind = formCExistingData![0].employedInIndia;
      referenceOtherObj.splcategorycode = formCExistingData![0].splCategoryCode;
      if (referenceOtherObj.splcategorycode != null) {
        FormCCommonServices.getSpecificSplCategory(
                referenceOtherObj.splcategorycode!)
            .then((result) {
          editSplCatList = result;
          if (editSplCatList != null && editSplCatList.length > 0) {
            _splCategoryController.text = editSplCatList[0].splcategoryDesc!;
            referenceOtherObj.splcategorycode =
                editSplCatList[0].splcategoryCode;
          }
        });
      }
      referenceOtherObj.purposeofvisit = formCExistingData![0].purposeOfVisit;
      if (referenceOtherObj.purposeofvisit != null) {
        FormCCommonServices.getSpecificPurposeOfVisit(
                referenceOtherObj.purposeofvisit!)
            .then((result) {
          editPurpose = result;
          if (editPurpose != null && editPurpose.length > 0) {
            _purposeController.text = editPurpose[0].purposedesc!;
            referenceOtherObj.purposeofvisit = editPurpose[0].purposeCode;
          }
        });
      }
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) =>
    //     ShowCaseWidget.of(_scaffoldKey.currentContext).startShowCase([keyOne]));

    setState(() {
      //  page1 = widget.data;
      stepsWizard = new FormCWizardMenuItem(
          passportNumberInWizard: passportNumberFromSearch,
          nationalityInWizard: nationalityFromSearch,
          currentPageNo: "6");
      stepsWizardForPendingAppl =
          new FormCWizardMenuItem.editFormCTempApplication(
        applicationId: formCApplicationId,
        currentPageNo: "6",
      );
    });

    /* value.data.nationality.forEach((element) =>
            //print(element.value)
        );
        */
  }

  isEnabled() {
    return buttonEnabled;
  }

  enableButton(bool flag) {
    setState(() {
      buttonEnabled = flag;
    });
  }

  disablePage(bool flag) {
    setState(() {
      isDisablePage = flag;
    });
  }

  isPageDisabled() {
    return isDisablePage;
  }

  next() {
    // enableButton(false);
    //print('Next Page: P1');
    if (_fbKey.currentState!.saveAndValidate()) {
      //print(DateTime.now());
      // _moveToStep3(referenceOtherObj);
      postReferenceOtherDetailsData();
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
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                title: Column(children: [
                  Text('Fill the mandatory fields'),
                ]));
          });
    }

    // Navigator.push(context, MaterialPageRoute( builder: (context) => FRRO_P1()),);
  }

  back() {
    //print('Previous Page: P0');
    Navigator.pop(context);
  }

  dateParseFormatter(var beforeParse) {
    var date = DateTime.parse('$beforeParse');
    var dateFormatter = new DateFormat("dd/MM/yyyy");
    String formattedDate = dateFormatter.format(date);
    //print('result $formattedDate');
    return formattedDate;
  }

  List<Step>? steps;

  final keyOne = GlobalKey();
  final keyTwo = GlobalKey();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0), // here the desired height
          child: AppBar(
            backgroundColor: blue,
            leading: Container(),
            title: Text('Form C'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushNamed(context, "/homeScreen");
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
        body: _formScreen(),
        bottomNavigationBar: Container(
          color: blue,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
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
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
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
        ),
      ),
    );
  }

  Widget _formScreen() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: FormBuilder(
        key: _fbKey,
        autovalidateMode: AutovalidateMode.disabled,
        //    initialValue: {"country": userNationality},
        child: AbsorbPointer(
          absorbing: isPageDisabled() ? true : false,
          child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  1, 15, 8, MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  // SelectableText('${givenName} ${surName}   (applicationId})',
                  //     style: TextStyle(
                  //       color: blue,
                  //       fontSize: 16,
                  //       //letterSpacing: 1,
                  //       fontWeight: FontWeight.bold,
                  //     )),
                  SelectableText(
                    'Application Id: $formCApplicationId',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(' Reference,Other Details ',
                      style: TextStyle(
                          //   decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: blue)),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Reference Details',
                      style: TextStyle(color: blue, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: FIELDPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Address Of Reference *',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(FIELDPADDING),
                    child: Container(
                      child: FormBuilderTextField(
                        initialValue: referenceOtherObj.addrofrefinind,
                        name: "addrOfRef",
                        maxLines: 1,
                        maxLength: MAX_LENGTH_ADDRESS,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(alphaNumericSpace))
                        ],
                        onChanged: (field) {
                          referenceOtherObj.addrofrefinind =
                              field!.toUpperCase();
                        },
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: CONTENTPADDING),
                          prefixIcon:
                              Icon(FontAwesomeIcons.locationArrow, color: blue),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                          // border: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(10.0)),

                          //labelText: 'Address Of Reference',
                        ),
                        validator: FormBuilderValidators.compose(
                          [
                            // ignore: missing_return
                            (value) {
                              //print('inside validator pptno');
                              //print('value ppt $value');

                              if (value == null || value.isEmpty) {
                                return 'Required';
                              } else {
                                return null;
                              }
                            },
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: FIELDPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Pincode *',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(FIELDPADDING),
                    child: FormBuilderTextField(
                      initialValue: referenceOtherObj.pincodeofref,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(numbers))
                      ],
                      maxLength: MAX_LENGTH_PINCODE,
                      onChanged: (value) {
                        referenceOtherObj.pincodeofref = value;
                      },
                      name: "pincode",
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(FontAwesomeIcons.phone, color: blue),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        //    labelText: 'Pincode',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: 1),
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.numeric(),
                          (val) {
                            if (val!.length < 6) {
                              return 'Must be 6 digit';
                            }
                          }
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: FIELDPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Phone Number Outside India*',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(FIELDPADDING),
                    child: FormBuilderTextField(
                      initialValue: referenceOtherObj.phnnum,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        referenceOtherObj.phnnum = value;
                      },
                      maxLength: MAX_LENGTH_MBL_PHN_NUM,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(phnNumbers))
                      ],
                      name: "phnNum",
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(FontAwesomeIcons.phone, color: blue),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        //     labelText: 'Phone Number',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: 1),
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          // FormBuilderValidators.numeric(),
                          if (referenceOtherObj.mblnum == null ||
                              referenceOtherObj.mblnum == "")
                            FormBuilderValidators.required(
                                errorText: 'Required')
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: FIELDPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Mobile Number Outside India*',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(FIELDPADDING),
                    child: FormBuilderTextField(
                      initialValue: referenceOtherObj.mblnum,
                      keyboardType: TextInputType.number,
                      maxLength: 15,
                      onChanged: (value) {
                        referenceOtherObj.mblnum = value;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(phnNumbers))
                      ],
                      name: "mblNum",
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(FontAwesomeIcons.mobile, color: blue),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        //      labelText: 'Mobile Number',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: 1),
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          // FormBuilderValidators.numeric(),
                          if (referenceOtherObj.phnnum == null ||
                              referenceOtherObj.phnnum == "")
                            FormBuilderValidators.required(
                              errorText: 'Required',
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: FIELDPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Phone Number In India *',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(FIELDPADDING),
                    child: FormBuilderTextField(
                      initialValue: referenceOtherObj.phnnuminind,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        referenceOtherObj.phnnuminind = value;
                      },
                      maxLength: 15,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(phnNumbers))
                      ],
                      name: "phnNumInInd",
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(FontAwesomeIcons.phone, color: blue),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        // labelText: 'Phone Number In India',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: 1),
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          // FormBuilderValidators.numeric(),
                          if (referenceOtherObj.mblnuminind == null ||
                              referenceOtherObj.mblnuminind == "")
                            FormBuilderValidators.required(
                              errorText: 'Required',
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: FIELDPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Mobile Number In India *',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(FIELDPADDING),
                    child: FormBuilderTextField(
                      initialValue: referenceOtherObj.mblnuminind,
                      keyboardType: TextInputType.number,
                      maxLength: 15,
                      onChanged: (value) {
                        referenceOtherObj.mblnuminind = value;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(phnNumbers))
                      ],
                      name: "mblNumInInd",
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(FontAwesomeIcons.mobile, color: blue),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        //      labelText: 'Mobile Number In India',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: 1),
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          // FormBuilderValidators.numeric(),
                          if (referenceOtherObj.phnnuminind == null ||
                              referenceOtherObj.phnnuminind == "")
                            FormBuilderValidators.required(
                              errorText: 'Required',
                            ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Other Details',
                      style: TextStyle(color: blue, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Employed In India ',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  FormBuilderRadioGroup(
                    //     attribute: page1.newlyBornFlag,
                    initialValue: referenceOtherObj.employedinind,
                    onChanged: (val) {
                      setState(() {
                        referenceOtherObj.employedinind = val;
                      });

                      //  //print('newly : ${page1.newlyB
                      // ornFlag}');
                    },

                    options: [
                      FormBuilderFieldOption(
                          value: 'Y',
                          child: Text(
                            'Yes',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 16,
                                letterSpacing: 1),
                          )),
                      FormBuilderFieldOption(
                          value: 'N',
                          child: Text(
                            "No",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 16,
                                letterSpacing: 1),
                          )),
                    ],
                    name: 'employedInInd',
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: FIELDPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Purpose Of Visit *',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(FIELDPADDING),
                    child: TypeAheadFormField(
                      getImmediateSuggestions: false,
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _purposeController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: CONTENTPADDING),
                          prefixIcon: Icon(FontAwesomeIcons.eye, color: blue),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          //   contentPadding: EdgeInsets.all(15.0),
                          suffixIcon: IconButton(
                              icon: (referenceOtherObj.purposeofvisit != null)
                                  ? Icon(Icons.remove_circle)
                                  : Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  referenceOtherObj.purposeofvisit = null;
                                  _purposeController.clear();
                                });
                              }),
                          //  contentPadding: EdgeInsets.all(10),
                          //    labelText: 'Purpose Of Visit',
                          // border: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),

                      //    attribute: 'purposeOfVisit',

                      // selectionToTextTransformer: (PurposeModel purposeModel) {
                      //   return purposeModel.purposedesc;
                      // },
                      // initialValue: new PurposeModel(),
                      itemBuilder: (context, purposeModel) {
                        return ListTile(
                          title: Text(
                            purposeModel.purposedesc!,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          tileColor: blue,
                        );
                      },

                      validator: FormBuilderValidators.compose(
                        [
                          // ignore: missing_return
                          (value) {
                            //print('inside validator pptno');
                            //print('value ppt $value');

                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (referenceOtherObj.purposeofvisit == null ||
                                referenceOtherObj.purposeofvisit == "") {
                              return "Select from suggestions only";
                            } else {
                              return null;
                            }
                          },
                        ],
                      ),
                      suggestionsCallback: (query) {
                        if (query.isNotEmpty) {
                          var lowercaseQuery = query.toLowerCase();
                          return povList.where((pov) {
                            return pov.purposedesc!
                                .toLowerCase()
                                .contains(query.toLowerCase());
                          }).toList(growable: false)
                            ..sort((a, b) => a.purposedesc!
                                .toLowerCase()
                                .indexOf(lowercaseQuery)
                                .compareTo(b.purposedesc!
                                    .toLowerCase()
                                    .indexOf(lowercaseQuery)));
                        } else {
                          return povList
                            ..sort((a, b) => a.purposedesc!
                                .toLowerCase()
                                .compareTo(b.purposedesc!.toLowerCase()));
                        }
                      },
                      onSuggestionSelected: (PurposeModel suggestion) {
                        referenceOtherObj.purposeofvisit =
                            suggestion.purposeCode;
                        _purposeController.text = suggestion.purposedesc!;
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
