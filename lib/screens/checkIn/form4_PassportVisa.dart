import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formc_showcase/Widgets/CustomShowCaseWidget.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/models/masters/countryModel.dart';
import 'package:formc_showcase/models/masters/visaSubtypeModel.dart';
import 'package:formc_showcase/models/masters/visatypeModel.dart';
import 'package:formc_showcase/models/passportVisaModel.dart';
import 'package:formc_showcase/services/formC_commonServices.dart';
import 'package:formc_showcase/util/validations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';
import '../formC_wizard.dart';
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:formc_showcase/util/spUtil.dart';

class PassportVisaArrivalForm extends StatefulWidget {
  final dynamic data;
  PassportVisaArrivalForm({Key? key, @required this.data, String? appId})
      : super(key: key);
  @override
  _PassportVisaArrivalFormState createState() =>
      _PassportVisaArrivalFormState();
}

class _PassportVisaArrivalFormState extends State<PassportVisaArrivalForm> {
  FormCWizardMenuItem? stepsWizard;
  FormCWizardMenuItem? stepsWizardPendingAppl;
  String? visatype, visasubtype, givenName, surName;
  PassportVisaModel passportVisaDataObj = new PassportVisaModel();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  var passportNumberFromSearch, nationalityFromSearch;
  //TextEditingController _controller;
  TextEditingController _pptCounController = new TextEditingController();
  TextEditingController _pptIssueDateController = new TextEditingController();
  TextEditingController _visatypeController = new TextEditingController();
  TextEditingController _visaCounController = new TextEditingController();
  TextEditingController _visasubtypeController = new TextEditingController();
  dynamic pendingData;
  bool isPptNatNonEditable = false;
  bool pptIssueFromOnchanged = false;
  bool visaIssueFromOnchanged = false;
  bool isDisablePage = false;
  bool buttonEnabled = true;
  bool? isPendingApplication;
  List<VisatypeModel> visatypeList = [];
  List<CountryModel> countryList = [];
  List<CountryModel> editPPtCountryList = [];
  List<CountryModel> editVisaCountryList = [];
  List<VisatypeModel> editVisatypeList = [];
  List<VisaSubtypeModel> editsubtypeList = [];
  var dob;
  List<VisaSubtypeModel> visasubtypeList = [];
  List? formCExistingData;
  postPassportVisaDetailsData() async {
    EasyLoading.show(status: 'Please Wait...');
    var token = await HttpUtils().getToken();
    var newApplicationId = await HttpUtils().getNewApplicationId();
    //print('token: $token');
    if (_fbKey.currentState!.fields['passportIssueDate']!.value != null)
      passportVisaDataObj.passportDateOfIssue = DateFormat("dd/MM/yyyy")
          .format(_fbKey.currentState!.fields['passportIssueDate']!.value);
    if (_fbKey.currentState!.fields['passportExpiryDate']!.value != null)
      passportVisaDataObj.passportExpiryDate = DateFormat("dd/MM/yyyy")
          .format(_fbKey.currentState!.fields['passportExpiryDate']!.value);
    if (_fbKey.currentState!.fields['visaIssueDate']!.value != null)
      passportVisaDataObj.visaDateOfIssue = DateFormat("dd/MM/yyyy")
          .format(_fbKey.currentState!.fields['visaIssueDate']!.value);
    if (_fbKey.currentState!.fields['visaExpiryDate']!.value != null)
      passportVisaDataObj.visaExpiryDate = DateFormat("dd/MM/yyyy")
          .format(_fbKey.currentState!.fields['visaExpiryDate']!.value);
    try {
      var data = json.encode({
        "form_c_appl_id": newApplicationId,
        "passnum": passportVisaDataObj.passportNumber,
        "passplace": passportVisaDataObj.passportPlaceOfIssue,
        "passcoun": passportVisaDataObj.passportCountryOfIssue,
        "passdate": passportVisaDataObj.passportDateOfIssue,
        "passexpdate": passportVisaDataObj.passportExpiryDate,
        "visanum": passportVisaDataObj.visaNumber,
        "visaplace": passportVisaDataObj.visaPlaceOfIssue,
        "visacoun": passportVisaDataObj.visaCountryOfIssue,
        "visadate": passportVisaDataObj.visaDateOfIssue,
        "visaexpdate": passportVisaDataObj.visaExpiryDate,
        "visatype": passportVisaDataObj.visatype,
        "visasubtype": passportVisaDataObj.visasubtype
      });
      //print(data);
      //print(POST_PASSPORTVISA_DETAILS);
      await http.post(
        Uri.parse(POST_PASSPORTVISA_DETAILS),
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
          pptIssueFromOnchanged = false;
          visaIssueFromOnchanged = false;
          (isPendingApplication == true)
              ? stepsWizardPendingAppl!
                  .createState()
                  .moveToPendingDataScreen(formCApplicationId, "5", context)
              : stepsWizard!.createState().moveToScreen(
                  passportNumberFromSearch,
                  nationalityFromSearch,
                  "5",
                  context);
          // Navigator.of(context).pushReplacementNamed("/photoUploadScreen");
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Home()));
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

  var formCApplicationId, splcatcode;
  bool isVisaMandatory = false;
  bool isPassportMandatory = false;
  getFlutterSecureStorageData() async {
    passportNumberFromSearch = await HttpUtils().getExistingFormCPptNo();
    nationalityFromSearch = await HttpUtils().getExistingFormCNationality();
    formCApplicationId = await HttpUtils().getNewApplicationId();
    dob = await HttpUtils().getApplicantDOB();
    splcatcode = await HttpUtils().getSplcatCode();
    setState(() {
      passportNumberFromSearch = passportNumberFromSearch;
      nationalityFromSearch = nationalityFromSearch;
      formCApplicationId = formCApplicationId;
      dob = dob;
      splcatcode = splcatcode;
      print('splcat code $splcatcode');
      if (this.splcatcode == '3' ||
          this.splcatcode == '10' ||
          this.splcatcode == '9' ||
          this.splcatcode == '11' ||
          this.splcatcode == '5') {
        this.isVisaMandatory = true;
      }
      if (this.splcatcode == '3' ||
          this.splcatcode == '10' ||
          this.splcatcode == '9' ||
          this.splcatcode == '11' ||
          this.splcatcode == '5' ||
          this.splcatcode == '7' ||
          this.splcatcode == '4' ||
          this.splcatcode == '12' ||
          this.splcatcode == '6' ||
          this.splcatcode == '8' ||
          this.splcatcode == '2') {
        this.isPassportMandatory = true;
      }
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
    // setState(() {
    //   pptIssueFromInit = true;
    //   visaIssueFromInit = true;
    // });

    //print('formcexi in init $formCExistingData');
    //print('dob in pptvisa :$dob');

    isPendingApplication = SpUtil.getBool('isPendingApplication');
    if (widget.data != null && widget.data.length > 0) {
      formCExistingData = widget.data;

      //print('data present ${formCExistingData}');
    } else {
      formCExistingData = null;
      //print('formc in else :$formCExistingData');
      //print('no data');
    }
    if (formCExistingData != null && formCExistingData!.length > 0) {
      //print('inside not null if');
      passportVisaDataObj.passportNumber = formCExistingData![0].passportNumber;
      if (isPendingApplication == false &&
          passportVisaDataObj.passportNumber != null &&
          passportVisaDataObj.passportNumber != "") {
        setState(() {
          isPptNatNonEditable = true;
        });
      }
      passportVisaDataObj.passportPlaceOfIssue =
          formCExistingData![0].passportPlaceOfIssue;
      passportVisaDataObj.passportCountryOfIssue =
          formCExistingData![0].passportIssuedCountry;
      if (passportVisaDataObj.passportCountryOfIssue != null) {
        FormCCommonServices.getSpecificCountry(
                passportVisaDataObj.passportCountryOfIssue!)
            .then((result) {
          editPPtCountryList = result;
          if (editPPtCountryList != null && editPPtCountryList.length > 0) {
            _pptCounController.text = editPPtCountryList[0].countryname!;
            passportVisaDataObj.passportCountryOfIssue =
                editPPtCountryList[0].countrycode;
          }
        });
      }
      passportVisaDataObj.passportDateOfIssue =
          formCExistingData![0].passportIssuedDate;
      //print('pptissuedate:${formCExistingData[0].passportIssuedDate}');

      passportVisaDataObj.passportExpiryDate =
          formCExistingData![0].passportExpiryDate;
      passportVisaDataObj.visaNumber = formCExistingData![0].visaNumber;
      passportVisaDataObj.visaPlaceOfIssue =
          formCExistingData![0].visaIssuedPlace;
      passportVisaDataObj.visaCountryOfIssue =
          formCExistingData![0].visaIssuedCountry;
      if (formCExistingData![0].visaIssuedCountry != null) {
        FormCCommonServices.getSpecificCountry(
                formCExistingData![0].visaIssuedCountry)
            .then((result) {
          editVisaCountryList = result;
          if (editVisaCountryList != null && editVisaCountryList.length > 0) {
            _visaCounController.text = editVisaCountryList[0].countryname!;
            formCExistingData![0].visaIssuedCountry =
                editVisaCountryList[0].countrycode;
          }
        });
      }
      passportVisaDataObj.visaDateOfIssue =
          formCExistingData![0].visaIssuedDate;
      passportVisaDataObj.visaExpiryDate = formCExistingData![0].visaExpiryDate;
      passportVisaDataObj.visatype = formCExistingData![0].visatype;
      if (passportVisaDataObj.visatype != null) {
        FormCCommonServices.getSpecificVisatype(passportVisaDataObj.visatype!)
            .then((result) {
          editVisatypeList = result;

          if (editVisatypeList != null && editVisatypeList.length > 0) {
            _visatypeController.text = editVisatypeList[0].visatypedesc!;
            passportVisaDataObj.visatype = editVisatypeList[0].visatypecode;
          }
        });
        FormCCommonServices.getVisaSubtype(passportVisaDataObj.visatype!)
            .then((result) {
          setState(() {
            visasubtypeList = result;
            if (editVisatypeList != null && editVisatypeList.length > 0) {
              _visasubtypeController.text =
                  visasubtypeList[0].visasubtype! + visasubtypeList[0].purpose!;
              passportVisaDataObj.visasubtype = visasubtypeList[0].purposecode;
            }
          });
        });
      }
      // passportVisaDataObj.visasubtype = formCExistingData[0].visaSubtype;
      // _visasubtypeController.text = formCExistingData[0].visaSubtype;
      //print('subtype: ${_visasubtypeController.text}');
      //passportVisaDataObj.passportNumber = formCExistingData[0].passportNumber;
    } else {
      //print('null data');
    }

    setState(() {
      //print('Inside Init ');
      pptIssueFromOnchanged = false;
      visaIssueFromOnchanged = false;
    });
    FormCCommonServices.getCountry().then((result) {
      countryList = result;
    });
    FormCCommonServices.getVisatype().then((result) {
      visatypeList = result;

      //print('visatype $visatypeList');
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) =>
    //     ShowCaseWidget.of(_scaffoldKey.currentContext).startShowCase([keyOne]));

    setState(() {
      //  page1 = widget.data;
      stepsWizard = new FormCWizardMenuItem(
          passportNumberInWizard: passportNumberFromSearch,
          nationalityInWizard: nationalityFromSearch,
          currentPageNo: "4");
      stepsWizardPendingAppl = new FormCWizardMenuItem.editFormCTempApplication(
          applicationId: formCApplicationId, currentPageNo: "4");
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
      // _moveToStep3(passportVisaDataObj);
      postPassportVisaDetailsData();
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
                Text(' Passport, Visa Details ',
                    style: TextStyle(
                        // decoration: TextDecoration.underline,
                        fontSize: 18,
                        color: blue,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Passport Details',
                    style: TextStyle(color: blue, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: FIELDPADDING),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Passport Number *',
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
                      readOnly: isPptNatNonEditable,
                      initialValue: passportVisaDataObj.passportNumber,
                      name: "passportNo",
                      maxLines: 1,
                      maxLength: MAX_LENGTH_PASSPORT_VISA,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(alphaNumeric))
                      ],
                      onChanged: (field) {
                        passportVisaDataObj.passportNumber =
                            field!.toUpperCase();
                      },
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(FontAwesomeIcons.idCard, color: blue),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        //    labelText: 'Passport number',
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          // ignore: missing_return
                          (value) {
                            //print('inside validator pptno');
                            //print('value ppt $value');

                            //print('inside loop');

                            if ((value == null || value.isEmpty) &&
                                isPassportMandatory) {
                              return 'Required';
                            } else {
                              return null;
                            }
                          }
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
                        'Country Of Issue *',
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
                      controller: _pptCounController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(FontAwesomeIcons.globe, color: blue),
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
                            icon: (passportVisaDataObj.passportCountryOfIssue !=
                                    null)
                                ? Icon(Icons.remove_circle)
                                : Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                passportVisaDataObj.passportCountryOfIssue =
                                    null;
                                _pptCounController.clear();
                              });
                            }),
                        //  contentPadding: EdgeInsets.all(10),
                        //  labelText: 'Country',
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),

                    //   attribute: 'passportCountryOfIssue',

                    // selectionToTextTransformer: (CountryModel countryModel) {
                    //   return countryModel.countryname;
                    // },
                    // initialValue: new CountryModel(),
                    itemBuilder: (context, countryModel) {
                      return ListTile(
                        title: Text(
                          countryModel.countryname!,
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
                          if (passportVisaDataObj.passportCountryOfIssue ==
                                  null ||
                              passportVisaDataObj.passportCountryOfIssue ==
                                  "") {
                            return "Select from suggestions only";
                          }
                          if ((value == null || value.isEmpty) &&
                              isPassportMandatory) {
                            return 'Required';
                          } else {
                            return null;
                          }
                        },
                      ],
                    ),
                    suggestionsCallback: (query) {
                      if (query.isNotEmpty) {
                        var lowercaseQuery = query.toLowerCase();
                        return countryList.where((country) {
                          return country.countryname!
                              .toLowerCase()
                              .contains(query.toLowerCase());
                        }).toList(growable: false)
                          ..sort((a, b) => a.countryname!
                              .toLowerCase()
                              .indexOf(lowercaseQuery)
                              .compareTo(b.countryname!
                                  .toLowerCase()
                                  .indexOf(lowercaseQuery)));
                      } else {
                        return countryList
                          ..sort((a, b) => a.countryname!
                              .toLowerCase()
                              .compareTo(b.countryname!.toLowerCase()));
                      }
                    },
                    onSuggestionSelected: (CountryModel suggestion) {
                      _pptCounController.text = suggestion.countryname!;

                      passportVisaDataObj.passportCountryOfIssue =
                          suggestion.countrycode;
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: FIELDPADDING),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Place Of Issue *',
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
                      initialValue: passportVisaDataObj.passportPlaceOfIssue,
                      name: "passportIssuePlace",
                      maxLines: 1,
                      maxLength: MAX_LENGTH_TEXTFIELD,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(alphabetSpace))
                      ],
                      onChanged: (field) {
                        passportVisaDataObj.passportPlaceOfIssue =
                            field!.toUpperCase();
                      },
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(Icons.location_on, color: blue),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10.0)),
                        //       labelText: 'Place of issue',
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          // ignore: missing_return
                          (value) {
                            //print('inside validator pptno');
                            //print('value ppt $value');

                            if ((value == null || value.isEmpty) &&
                                isPassportMandatory) {
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
                        'Date Of Issue *',
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
                  child: FormBuilderDateTimePicker(
                    //       controller: _pptIssueDateController,
                    initialValue: (passportVisaDataObj.passportDateOfIssue !=
                            null)
                        ? (DateFormat("dd/MM/yyyy")
                            .parse(passportVisaDataObj.passportDateOfIssue!))
                        : null,
                    name: "passportIssueDate",

                    valueTransformer: (value) => (value != null)
                        ? DateFormat("dd/MM/yyyy").format(value)
                        : null,
                    inputType: InputType.date,
                    format: DateFormat("dd/MM/yyyy"),
                    //  readOnly:  page1.dateOfBirth !=null ? true : false ,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: CONTENTPADDING),
                      prefixIcon: Icon(FontAwesomeIcons.calendar, color: blue),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: BORDERWIDTH, color: blue),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: BORDERWIDTH, color: blue),
                          borderRadius: BorderRadius.circular(10.0)),
                      //labelText: 'Date Of Issue',
                      /*   suffixIcon: IconButton(
                    icon: new Icon(Icons.help),
                    tooltip: 'Date of birth as in Passport in DD/MM/YYYY format',
                    onPressed: () {},
                  ),*/
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value != null)
                          passportVisaDataObj.passportDateOfIssue =
                              DateFormat("dd/MM/yyyy").format(value);
                        //print(
                        //  'passportvalye in fn :${passportVisaDataObj.passportDateOfIssue}');
                        pptIssueFromOnchanged = true;
                      });
                    },
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(
                          errorText: 'Required',
                        ),
                        // ignore: missing_return
                        (val) {
                          if (val != null && dob != null) {
                            dynamic issueDateFormatted =
                                dateParseFormatter(val);

                            dynamic dobFormatted = '$dob';
                            var df1 = DateFormat('dd/MM/yyyy')
                                .parse(issueDateFormatted);
                            var df2 =
                                DateFormat('dd/MM/yyyy').parse(dobFormatted);
                            if ((df1.isBefore(df2)) ||
                                df1.isAtSameMomentAs(df2)) {
                              return "Date must be later than Date Of Birth";
                            }
                          }
                          if ((val == null || val == "") &&
                              isPassportMandatory) {
                            return 'Required';
                          } else {
                            return null;
                          }
                        }
                      ],
                    ),
                    // initialValue: (widget.data.dateOfBirth != null)
                    //     ? (DateFormat("dd/MM/yyyy")
                    //         .parse(widget.data.dateOfBirth))
                    //     : null,
/*            initialValue: (widget.data.dateOfBirth != null)
                    ? (DateFormat("dd/MM/yyyy").parse(widget.data.dateOfBirth))
                    : (registerdUserInDevice != null &&
                            registerdUserInDevice['dateOfBirth'] != null)
                        ? DateFormat('dd-MM-yyyy')
                                .parse(registerdUserInDevice['dateOfBirth']) ??
                            null
                        : null,*/
                    firstDate: DateTime(DateTime.now().year - 100,
                        DateTime.now().month, DateTime.now().day),
                    lastDate: DateTime.now(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: FIELDPADDING),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Date Of Expiry *',
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
                  child: FormBuilderDateTimePicker(
                    name: "passportExpiryDate",
                    onChanged: (value) {
                      if (value != null)
                        passportVisaDataObj.passportExpiryDate =
                            DateFormat("dd/MM/yyyy").format(value);
                    },
                    initialValue:
                        (passportVisaDataObj.passportExpiryDate != null)
                            ? (DateFormat("dd/MM/yyyy")
                                .parse(passportVisaDataObj.passportExpiryDate!))
                            : null,
                    valueTransformer: (value) => (value != null)
                        ? DateFormat("dd/MM/yyyy").format(value)
                        : null,
                    inputType: InputType.date,
                    format: DateFormat("dd/MM/yyyy"),
                    //  readOnly:  page1.dateOfBirth !=null ? true : false ,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: CONTENTPADDING),
                      prefixIcon:
                          Icon(FontAwesomeIcons.calendarDay, color: blue),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: BORDERWIDTH, color: blue),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: BORDERWIDTH, color: blue),
                          borderRadius: BorderRadius.circular(10.0)),
                      //    labelText: 'Expiry Date',
                      /*   suffixIcon: IconButton(
                    icon: new Icon(Icons.help),
                    tooltip: 'Date of birth as in Passport in DD/MM/YYYY format',
                    onPressed: () {},
                  ),*/
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        // ignore: missing_return
                        (val) {
                          dynamic issueDtateFormated;
                          if (val != null &&
                              passportVisaDataObj.passportDateOfIssue != null) {
                            //print('passissuedate ${pptIssueFromOnchanged}');
                            dynamic expiryDateFormatted =
                                dateParseFormatter(val);
                            // (pptIssueFromOnchanged == true)
                            //     ? issueDtateFormated = dateParseFormatter(
                            //         passportVisaDataObj.passportDateOfIssue)
                            issueDtateFormated =
                                (passportVisaDataObj.passportDateOfIssue);
                            var df1 = DateFormat('dd/MM/yyyy')
                                .parse(expiryDateFormatted);
                            var df2 = DateFormat('dd/MM/yyyy')
                                .parse(issueDtateFormated);
                            if ((df1.isBefore(df2)) ||
                                df1.isAtSameMomentAs(df2)) {
                              return "Date must be later than issue date";
                            }
                          }
                          if ((val == null || val == "") &&
                              isPassportMandatory) {
                            return 'Required';
                          } else {
                            return null;
                          }
                        }
                      ],
                    ),
                    // initialValue: (widget.data.dateOfBirth != null)
                    //     ? (DateFormat("dd/MM/yyyy")
                    //         .parse(widget.data.dateOfBirth))
                    //     : null,
/*            initialValue: (widget.data.dateOfBirth != null)
                    ? (DateFormat("dd/MM/yyyy").parse(widget.data.dateOfBirth))
                    : (registerdUserInDevice != null &&
                            registerdUserInDevice['dateOfBirth'] != null)
                        ? DateFormat('dd-MM-yyyy')
                                .parse(registerdUserInDevice['dateOfBirth']) ??
                            null
                        : null,*/
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 100,
                        DateTime.now().month, DateTime.now().day),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Visa Details',
                    style: TextStyle(
                      color: blue,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: FIELDPADDING),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Visa Number *',
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
                      initialValue: passportVisaDataObj.visaNumber,
                      name: "visaNumber",
                      maxLines: 1,
                      maxLength: MAX_LENGTH_PASSPORT_VISA,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(alphaNumeric))
                      ],
                      onChanged: (field) {
                        passportVisaDataObj.visaNumber = field!.toUpperCase();
                      },
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon:
                            Icon(FontAwesomeIcons.addressCard, color: blue),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10.0)),
                        //      labelText: 'Visa Number',
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          // ignore: missing_return
                          (value) {
                            //print('inside validator pptno');
                            //print('value ppt $value');

                            if ((value == null || value.isEmpty) &&
                                isVisaMandatory) {
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
                        'Country Of Issue *',
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
                      controller: _visaCounController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(FontAwesomeIcons.globe, color: blue),
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
                            icon:
                                (passportVisaDataObj.visaCountryOfIssue != null)
                                    ? Icon(Icons.remove_circle)
                                    : Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                passportVisaDataObj.visaCountryOfIssue = null;
                                _visaCounController.clear();
                              });
                            }),
                        //  contentPadding: EdgeInsets.all(10),
                        //    labelText: 'Country Of Issue',
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),

                    //    attribute: 'visaCountryOfIssue',
                    // onSaved: (newVal) async {
                    //   //print('onchanged');
                    //   FocusScope.of(context).requestFocus(FocusNode());

                    //   setState(() {
                    //     passportVisaDataObj.visaCountryOfIssue =
                    //         newVal;
                    //     // tempIdGeneration.nationality = newVal.countrycode;
                    //     //  _controller.text = country;

                    //     //  //print(newVal.countrycode);
                    //     // final index = country.indexWhere(
                    //     //     (element) => element['country_name'] == newVal);
                    //     // //print(-index);

                    //     // //print(
                    //     //     'Using indexWhere: ${country[-index]['country_code']}');
                    //   });
                    // },
                    // selectionToTextTransformer: (CountryModel countryModel) {
                    //   return countryModel.countryname;
                    // },
                    // initialValue: new CountryModel(),
                    itemBuilder: (context, countryModel) {
                      return ListTile(
                        title: Text(
                          countryModel.countryname!,
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
                          if (passportVisaDataObj.visaCountryOfIssue == null ||
                              passportVisaDataObj.visaCountryOfIssue == "") {
                            return "Select from suggestions only";
                          }
                          if ((value == null || value.isEmpty) &&
                              isVisaMandatory) {
                            return 'Required';
                          } else {
                            return null;
                          }
                        },
                      ],
                    ),
                    suggestionsCallback: (query) {
                      if (query.isNotEmpty) {
                        var lowercaseQuery = query.toLowerCase();
                        return countryList.where((country) {
                          return country.countryname!
                              .toLowerCase()
                              .contains(query.toLowerCase());
                        }).toList(growable: false)
                          ..sort((a, b) => a.countryname!
                              .toLowerCase()
                              .indexOf(lowercaseQuery)
                              .compareTo(b.countryname!
                                  .toLowerCase()
                                  .indexOf(lowercaseQuery)));
                      } else {
                        return countryList
                          ..sort((a, b) => a.countryname!
                              .toLowerCase()
                              .compareTo(b.countryname!.toLowerCase()));
                      }
                    },
                    onSuggestionSelected: (CountryModel suggestion) {
                      _visaCounController.text = suggestion.countryname!;

                      passportVisaDataObj.visaCountryOfIssue =
                          suggestion.countrycode;
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: FIELDPADDING),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Place Of Issue *',
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
                      initialValue: passportVisaDataObj.visaPlaceOfIssue,
                      name: "visaIssuePlace",
                      maxLines: 1,
                      maxLength: MAX_LENGTH_TEXTFIELD,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(alphabetSpace))
                      ],
                      onChanged: (field) {
                        passportVisaDataObj.visaPlaceOfIssue =
                            field!.toUpperCase();
                      },
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(FontAwesomeIcons.compass, color: blue),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10.0)),
                        //    labelText: 'Place Of Issue',
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          // ignore: missing_return
                          (value) {
                            //print('inside validator pptno');
                            //print('value ppt $value');

                            if ((value == null || value.isEmpty) &&
                                isVisaMandatory) {
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
                        'Date Of Issue *',
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
                  child: FormBuilderDateTimePicker(
                    firstDate: DateTime(DateTime.now().year - 100,
                        DateTime.now().month, DateTime.now().day),
                    lastDate: DateTime.now(),
                    name: "visaIssueDate",
                    onChanged: (val) {
                      setState(() {
                        visaIssueFromOnchanged = true;
                      });
                      if (val != null)
                        passportVisaDataObj.visaDateOfIssue =
                            DateFormat("dd/MM/yyyy").format(val);
                    },
                    initialValue: (passportVisaDataObj.visaDateOfIssue != null)
                        ? (DateFormat("dd/MM/yyyy")
                            .parse(passportVisaDataObj.visaDateOfIssue!))
                        : null,
                    valueTransformer: (value) => (value != null)
                        ? DateFormat("dd/MM/yyyy").format(value)
                        : null,
                    inputType: InputType.date,
                    format: DateFormat("dd/MM/yyyy"),
                    //  readOnly:  page1.dateOfBirth !=null ? true : false ,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: CONTENTPADDING),
                      prefixIcon: Icon(FontAwesomeIcons.calendar, color: blue),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: BORDERWIDTH, color: blue),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: BORDERWIDTH, color: blue),
                          borderRadius: BorderRadius.circular(10.0)),
                      //    labelText: 'Date Of Issue',
                      /*   suffixIcon: IconButton(
                    icon: new Icon(Icons.help),
                    tooltip: 'Date of birth as in Passport in DD/MM/YYYY format',
                    onPressed: () {},
                  ),*/
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        // ignore: missing_return
                        (val) {
                          if (val != null && dob != null) {
                            dynamic issueDateFormatted =
                                dateParseFormatter(val);

                            dynamic dobFormatted = '$dob';
                            var df1 = DateFormat('dd/MM/yyyy')
                                .parse(issueDateFormatted);
                            var df2 =
                                DateFormat('dd/MM/yyyy').parse(dobFormatted);
                            if ((df1.isBefore(df2)) ||
                                df1.isAtSameMomentAs(df2)) {
                              return "Date must be later than Date Of Birth";
                            }
                          }
                          if (val != null &&
                              passportVisaDataObj.passportDateOfIssue != null) {
                            dynamic visaissueDateFormatted =
                                dateParseFormatter(val);

                            dynamic pptIssuedateFormatted =
                                '${passportVisaDataObj.passportDateOfIssue}';
                            var df1 = DateFormat('dd/MM/yyyy')
                                .parse(visaissueDateFormatted);
                            var df2 = DateFormat('dd/MM/yyyy')
                                .parse(pptIssuedateFormatted);
                            // print('df1 $df1 df2 $df2');
                            if ((df1.isBefore(df2))) {
                              return "Date must be later than Passport issue date";
                            }
                          }
                          if ((val == null || val == "") && isVisaMandatory) {
                            return 'Required';
                          } else {
                            return null;
                          }
                        }
                      ],
                    ),
                    // initialValue: (widget.data.dateOfBirth != null)
                    //     ? (DateFormat("dd/MM/yyyy")
                    //         .parse(widget.data.dateOfBirth))
                    //     : null,
/*            initialValue: (widget.data.dateOfBirth != null)
                    ? (DateFormat("dd/MM/yyyy").parse(widget.data.dateOfBirth))
                    : (registerdUserInDevice != null &&
                            registerdUserInDevice['dateOfBirth'] != null)
                        ? DateFormat('dd-MM-yyyy')
                                .parse(registerdUserInDevice['dateOfBirth']) ??
                            null
                        : null,*/
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: FIELDPADDING),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Date Of Expiry *',
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
                  child: FormBuilderDateTimePicker(
                    name: "visaExpiryDate",
                    onChanged: (value) {
                      if (value != null)
                        passportVisaDataObj.visaExpiryDate =
                            DateFormat("dd/MM/yyyy").format(value);
                    },
                    initialValue: (passportVisaDataObj.visaExpiryDate != null)
                        ? (DateFormat("dd/MM/yyyy")
                            .parse(passportVisaDataObj.visaExpiryDate!))
                        : null,
                    valueTransformer: (value) => (value != null)
                        ? DateFormat("dd/MM/yyyy").format(value)
                        : null,
                    inputType: InputType.date,
                    format: DateFormat("dd/MM/yyyy"),
                    //  readOnly:  page1.dateOfBirth !=null ? true : false ,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: CONTENTPADDING),
                      prefixIcon: Icon(FontAwesomeIcons.calendar, color: blue),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: BORDERWIDTH, color: blue),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: BORDERWIDTH, color: blue),
                          borderRadius: BorderRadius.circular(10.0)),
                      //  labelText: 'Date Of Expiry',
                      /*   suffixIcon: IconButton(
                    icon: new Icon(Icons.help),
                    tooltip: 'Date of birth as in Passport in DD/MM/YYYY format',
                    onPressed: () {},
                  ),*/
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        // ignore: missing_return
                        (val) {
                          dynamic issueDtateFormated;
                          if (val != null &&
                              passportVisaDataObj.visaDateOfIssue != null) {
                            dynamic expiryDateFormatted =
                                dateParseFormatter(val);

                            // (visaIssueFromOnchanged == true)
                            //     ? issueDtateFormated = dateParseFormatter(
                            //         passportVisaDataObj.visaDateOfIssue)
                            issueDtateFormated =
                                (passportVisaDataObj.visaDateOfIssue);
                            var df1 = DateFormat('dd/MM/yyyy')
                                .parse(expiryDateFormatted);
                            var df2 = DateFormat('dd/MM/yyyy')
                                .parse(issueDtateFormated);
                            if ((df1.isBefore(df2)) ||
                                df1.isAtSameMomentAs(df2)) {
                              return "Date must be later than issue date";
                            }
                          }
                          if ((val == null || val == "") && isVisaMandatory) {
                            return 'Required';
                          } else {
                            return null;
                          }
                        }
                        // (value) {
                        //   if (serviceDetailsModel.newlyBornFlag != '1' &&
                        //       serviceDetailsModel.questionId != '18' &&
                        //       serviceDetailsModel.questionId != '19' &&
                        //       serviceDetailsModel.questionId != '20' &&
                        //       serviceDetailsModel.refugeeFlag != '1' &&
                        //       serviceDetailsModel.surrenderedPassportFlag !=
                        //           '1') {
                        //     if (value == null) {
                        //       return 'Required';
                        //     }
                        //     if (value != null && passportVisaDataObj.visaDateOfIssue != null) {
                        //       var df1 = DateFormat('dd/MM/yyyy')
                        //           .parse(passportVisaDataObj.visaDateOfIssue);
                        //       var df2 = DateFormat('dd/MM/yyyy').parse(value);
                        //       //print(df2.isBefore(df1).toString());

                        //       if ((df2.isBefore(df1)) ||
                        //           df2.isAtSameMomentAs(df1)) {
                        //         return "Date must be later than Visa Date Of Issue";
                        //       }
                        //     }
                        //     if (value != null &&
                        //         passportVisaDataObj.passportExpiryDate != null) {
                        //       var df1 = DateFormat('dd/MM/yyyy')
                        //           .parse(passportVisaDataObj.passportExpiryDate);
                        //       var df2 = DateFormat('dd/MM/yyyy').parse(value);
                        //       //print(df2.isAfter(df1).toString());

                        //       if ((df2.isAfter(df1))) {
                        //         return "Date must be earlier than Passport Expiry Date";
                        //       }
                        //     }
                        //   }
                        // },
                      ],
                    ),
                    // initialValue: (widget.data.dateOfBirth != null)
                    //     ? (DateFormat("dd/MM/yyyy")
                    //         .parse(widget.data.dateOfBirth))
                    //     : null,
/*            initialValue: (widget.data.dateOfBirth != null)
                    ? (DateFormat("dd/MM/yyyy").parse(widget.data.dateOfBirth))
                    : (registerdUserInDevice != null &&
                            registerdUserInDevice['dateOfBirth'] != null)
                        ? DateFormat('dd-MM-yyyy')
                                .parse(registerdUserInDevice['dateOfBirth']) ??
                            null
                        : null,*/
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 100,
                        DateTime.now().month, DateTime.now().day),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: FIELDPADDING),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Visatype *',
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
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TypeAheadFormField(
                    getImmediateSuggestions: false,
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _visatypeController,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(FontAwesomeIcons.addressCard, color: blue),
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
                            icon: (visatype != null)
                                ? Icon(Icons.remove_circle)
                                : Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                _visatypeController.clear();
                                //    _controller.text=null;
                                passportVisaDataObj.visatype = null;
                                visatype = null;
                              });
                            }),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        //   labelText: 'Visatype',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),

                    //  attribute: 'visatype',

                    // selectionToTextTransformer: (VisatypeModel visatypeModel) {
                    //   return visatypeModel.visatypedesc;
                    // },
                    // initialValue: new VisatypeModel(),
                    itemBuilder: (context, visatypeModel) {
                      return ListTile(
                        title: Text(
                          visatypeModel.visatypedesc!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        tileColor: blue,
                      );
                    },
                    // controller: _controller,
                    validator: FormBuilderValidators.compose(
                      [
                        (value) {
                          if (passportVisaDataObj.visatype == null ||
                              passportVisaDataObj.visatype == "") {
                            return "Select from suggestions only";
                          }
                          if ((value == null || value.isEmpty) &&
                              isVisaMandatory) {
                            return 'Required';
                          } else {
                            return null;
                          }
                        }
                      ],
                    ),
                    suggestionsCallback: (query) {
                      if (query.isNotEmpty) {
                        var lowercaseQuery = query.toLowerCase();
                        return visatypeList.where((visatype) {
                          return visatype.visatypedesc!
                              .toLowerCase()
                              .contains(query.toLowerCase());
                        }).toList(growable: false)
                          ..sort((a, b) => a.visatypedesc!
                              .toLowerCase()
                              .indexOf(lowercaseQuery)
                              .compareTo(b.visatypedesc!
                                  .toLowerCase()
                                  .indexOf(lowercaseQuery)));
                      } else {
                        return visatypeList
                          ..sort((a, b) => a.visatypedesc!
                              .toLowerCase()
                              .compareTo(b.visatypedesc!.toLowerCase()));
                      }
                    },
                    onSuggestionSelected: (VisatypeModel suggestion) {
                      setState(() {
                        passportVisaDataObj.visatype = suggestion.visatypecode;
                        visatype = suggestion.visatypecode;
                        passportVisaDataObj.visasubtype = null;
                        visasubtype = null;
                        _visasubtypeController.clear();
                        passportVisaDataObj.visasubtype = null;
                        //desc here
                        _visatypeController.text = suggestion.visatypedesc!;
                        FormCCommonServices.getVisaSubtype(visatype!)
                            .then((result) {
                          visasubtypeList = result;
                          //print('visasubtype $visasubtypeList');
                        });
                        //     //print(_controller.text);
                        // final index = country.indexWhere(
                        //     (element) => element['country_name'] == newVal);
                        // //print(-index);

                        // //print(
                        //     'Using indexWhere: ${country[-index]['country_code']}');
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: FIELDPADDING),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Visa Subtype *',
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
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TypeAheadFormField(
                    getImmediateSuggestions: false,
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _visasubtypeController,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(FontAwesomeIcons.addressCard, color: blue),
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
                            icon: (visasubtype != null)
                                ? Icon(Icons.remove_circle)
                                : Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                _visasubtypeController.clear();
                                //    _controller.text=null;
                                passportVisaDataObj.visasubtype = null;
                                visasubtype = null;
                              });
                            }),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        //    labelText: ' Visasubtype',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),

                    // attribute: 'visasubtype',

                    // selectionToTextTransformer:
                    //     (VisaSubtypeModel visasubtypeModel) {
                    //   return visasubtypeModel.purpose;
                    // },
                    // initialValue: new VisaSubtypeModel(),
                    itemBuilder: (context, visaSubtypeModel) {
                      return ListTile(
                        title: Text(
                          visaSubtypeModel.visasubtype! +
                              '-' +
                              visaSubtypeModel.purpose!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        tileColor: blue,
                      );
                    },
                    // controller: _controller,
                    validator: FormBuilderValidators.compose(
                      [
                        (value) {
                          if (passportVisaDataObj.visasubtype == null ||
                              passportVisaDataObj.visasubtype == "") {
                            return "Select from suggestions only";
                          }
                          if ((value == null || value.isEmpty) &&
                              isVisaMandatory) {
                            return 'Required';
                          } else {
                            return null;
                          }
                        }
                      ],
                    ),
                    suggestionsCallback: (query) {
                      if (query.isNotEmpty) {
                        var lowercaseQuery = query.toLowerCase();
                        return visasubtypeList.where((visasubtype) {
                          return visasubtype.purpose!
                              .toLowerCase()
                              .contains(query.toLowerCase());
                        }).toList(growable: false)
                          ..sort((a, b) => a.purpose!
                              .toLowerCase()
                              .indexOf(lowercaseQuery)
                              .compareTo(b.purpose!
                                  .toLowerCase()
                                  .indexOf(lowercaseQuery)));
                      } else {
                        return visasubtypeList
                          ..sort((a, b) => a.purpose!
                              .toLowerCase()
                              .compareTo(b.purpose!.toLowerCase()));
                      }
                    },
                    onSuggestionSelected: (VisaSubtypeModel suggestion) {
                      passportVisaDataObj.visasubtype = suggestion.purposecode;

                      visasubtype = suggestion.purposecode;
                      _visasubtypeController.text =
                          suggestion.visasubtype! + suggestion.purpose!;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
