import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formc_showcase/Widgets/CustomShowCaseWidget.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/models/arrivalNxtDestinationModel.dart';
import 'package:formc_showcase/models/masters/countryModel.dart';
import 'package:formc_showcase/models/masters/districtModel.dart';
import 'package:formc_showcase/models/masters/purposeModel.dart';
import 'package:formc_showcase/models/masters/stateModel.dart';
import 'package:formc_showcase/models/masters/visaSubtypeModel.dart';
import 'package:formc_showcase/models/masters/visatypeModel.dart';
import 'package:formc_showcase/services/formC_commonServices.dart';
import 'package:formc_showcase/util/validations.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';
import 'dart:convert';
import 'package:formc_showcase/util/httpUtil.dart';
import '../formC_wizard.dart';
import 'package:http/http.dart' as http;
import 'package:formc_showcase/util/spUtil.dart';

class ArrivalNxtDestScreen extends StatefulWidget {
  final dynamic data;
  ArrivalNxtDestScreen({Key? key, @required this.data, String? appId})
      : super(key: key);
  @override
  _ArrivalNxtDestScreenState createState() => _ArrivalNxtDestScreenState();
}

class _ArrivalNxtDestScreenState extends State<ArrivalNxtDestScreen> {
  FormCWizardMenuItem? stepsWizard;
  FormCWizardMenuItem? stepsWizardForPendingAppl;
  String? givenName, surName, nextDestCoun;
  ArrivalNxtDestModel arrivalNextObj = new ArrivalNxtDestModel();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  //TextEditingController _controller;
  TextEditingController _arrivedFromCounController =
      new TextEditingController();
  TextEditingController _nextDestStateInInd = new TextEditingController();
  TextEditingController _nextDestCountry = new TextEditingController();
  dynamic pendingData;
  String? selectedArrivalPort;
  bool pptIssueFromInit = false;
  bool visaIssueFromInit = false;
  bool isDisablePage = false;
  bool buttonEnabled = true;
  bool? isPendingApplication;
  List? formCExistingData;
  List<CountryModel> editNxtDestCounlist = [];
  List<VisatypeModel> visatypeList = [];
  List<StateModel> editStateList = [];
  List<CountryModel> countryList = [];
  List<CountryModel> editCountryList = [];
  List<DistrictModel> distInIndList = [];
  List<VisaSubtypeModel> visasubtypeList = [];
  List<StateModel> stateList = [];
  List<PurposeModel> povList = [];
  var passportNumberFromSearch, nationalityFromSearch;

  var dob, page1newlyBornFlag, page1refugeeFlag, page1SurrenderPassportFlag;
  postArrivalNextDetailsData() async {
    EasyLoading.show(status: 'Please Wait...');
    var token = await HttpUtils().getToken();
    var newApplicationId = await HttpUtils().getNewApplicationId();
    //print('token: $token');
    if (_fbKey.currentState!.fields['dateOfArrivalInIndia']!.value != null)
      arrivalNextObj.dateOfArrivalInIndia = DateFormat("dd/MM/yyyy")
          .format(_fbKey.currentState!.fields['dateOfArrivalInIndia']!.value);
    if (_fbKey.currentState!.fields['dateOfArrivalInHotel']!.value != null)
      arrivalNextObj.dateOfArrivalInHotel = DateFormat("dd/MM/yyyy")
          .format(_fbKey.currentState!.fields['dateOfArrivalInHotel']!.value);
    if (_fbKey.currentState!.fields['timeOfArrivalInHotel']!.value != null)
      arrivalNextObj.timeOfArrivalInHotel = DateFormat("Hm")
          .format(_fbKey.currentState!.fields['timeOfArrivalInHotel']!.value);

    try {
      var data = json.encode({
        "form_c_appl_id": newApplicationId,
        "arriplace": arrivalNextObj.arrivedFromPlace,
        "arricit": arrivalNextObj.arrivedFromCity,
        "arricoun": arrivalNextObj.arrivedFromCountry,
        "arridateind": arrivalNextObj.dateOfArrivalInIndia,
        "arridatehotel": arrivalNextObj.dateOfArrivalInHotel,
        "arritimehotel": arrivalNextObj.timeOfArrivalInHotel,
        "durationofstay": arrivalNextObj.durationOfStay,
        "nextdestplaceinind": arrivalNextObj.nextDestPlaceInIndia,
        "nextdestdistinind": arrivalNextObj.nextDestDistInIndia,
        "nextdeststateinind": arrivalNextObj.nextDeststateInIndia,
        "nextdestcounflag": arrivalNextObj.nextDestCountryFlag,
        "nextdestplaceoutind": arrivalNextObj.nextDestPlaceOutIndia,
        "nextdestcityoutind": arrivalNextObj.nextDestCityOutIndia,
        "nextdestcounoutind": arrivalNextObj.nextDestCountryOutIndia
      });
      //print(data);
      //print(POST_ARRIVALNXTDEST_DETAILS);
      await http.post(
        Uri.parse(POST_ARRIVALNXTDEST_DETAILS),
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
          (isPendingApplication == true)
              ? stepsWizardForPendingAppl!
                  .createState()
                  .moveToPendingDataScreen(newApplicationId!, "6", context)
              : stepsWizard!.createState().moveToScreen(
                  passportNumberFromSearch,
                  nationalityFromSearch,
                  "6",
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
  bool isArrivalMandatory = false;
  getFlutterSecureStorageData() async {
    passportNumberFromSearch = await HttpUtils().getExistingFormCPptNo();
    nationalityFromSearch = await HttpUtils().getExistingFormCNationality();
    formCApplicationId = await HttpUtils().getNewApplicationId();
    splcatcode = await HttpUtils().getSplcatCode();

    setState(() {
      passportNumberFromSearch = passportNumberFromSearch;
      nationalityFromSearch = nationalityFromSearch;
      formCApplicationId = formCApplicationId;
      splcatcode = splcatcode;
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
        // print('inside arri mandatory');
        this.isArrivalMandatory = true;
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
    isPendingApplication = SpUtil.getBool('isPendingApplication');
    print('ispending in arrival $isPendingApplication');
    setState(() {
      //print('Inside Init ');
      pptIssueFromInit = false;
      visaIssueFromInit = false;
    });
    if (widget.data != null && isPendingApplication == true) {
      formCExistingData = widget.data;
    }
    if (formCExistingData != null && formCExistingData!.length > 0) {
      arrivalNextObj.arrivedFromPlace = formCExistingData![0].arrivedFromPlace;
      arrivalNextObj.arrivedFromCity = formCExistingData![0].arrivedFromCity;
      //print('init arrived fron cty ${arrivalNextObj.arrivedFromCity}');
      arrivalNextObj.arrivedFromCountry =
          formCExistingData![0].arrivedFromCountry;
      if (arrivalNextObj.arrivedFromCountry != null) {
        FormCCommonServices.getSpecificCountry(
                arrivalNextObj.arrivedFromCountry!)
            .then((result) {
          editCountryList = result;
          if (editCountryList != null && editCountryList.length > 0) {
            _arrivedFromCounController.text = editCountryList[0].countryname!;
            arrivalNextObj.arrivedFromCountry = editCountryList[0].countrycode;
          }
        });
      }
      arrivalNextObj.dateOfArrivalInIndia =
          formCExistingData![0].arrivalDateInIndia;
      arrivalNextObj.dateOfArrivalInHotel =
          formCExistingData![0].arrivalDateInHotel;
      arrivalNextObj.timeOfArrivalInHotel =
          formCExistingData![0].arrivalTimeInHotel;
      arrivalNextObj.durationOfStay = formCExistingData![0].durationOfStay;
      arrivalNextObj.nextDestPlaceInIndia =
          formCExistingData![0].nextDestPlaceInIndia;
      arrivalNextObj.nextDeststateInIndia =
          formCExistingData![0].nextDestStateInIndia;
      if (arrivalNextObj.nextDeststateInIndia != null) {
        FormCCommonServices.getSpecificState(
                arrivalNextObj.nextDeststateInIndia!)
            .then((result) {
          editStateList = result;
          //print('Single state:$editStateList');
          if (editStateList != null && editStateList.length > 0) {
            _nextDestStateInInd.text = editStateList[0].statename!;
            arrivalNextObj.nextDeststateInIndia = editStateList[0].statecode;
          }
        });
        FormCCommonServices.getDistrict(arrivalNextObj.nextDeststateInIndia!)
            .then((result) {
          setState(() {
            distInIndList = result;
            //print('distInInd :$distInIndList');
          });
        });
      }
      arrivalNextObj.nextDestDistInIndia =
          formCExistingData![0].nextDestDistInIndia;
      arrivalNextObj.nextDestCountryFlag =
          formCExistingData![0].nextDestCountryFlag;
      arrivalNextObj.nextDestPlaceOutIndia =
          formCExistingData![0].nextDestPlaceOutsideIndia;
      arrivalNextObj.nextDestCityOutIndia =
          formCExistingData![0].nextDestCityOutsideIndia;
      arrivalNextObj.nextDestCountryOutIndia =
          formCExistingData![0].nextDestCountryOutsideIndia;
      if (arrivalNextObj.nextDestCountryOutIndia != null) {
        FormCCommonServices.getSpecificCountry(
                arrivalNextObj.nextDestCountryOutIndia!)
            .then((result) {
          editNxtDestCounlist = result;
          if (editNxtDestCounlist != null && editNxtDestCounlist.length > 0) {
            _nextDestCountry.text = editNxtDestCounlist[0].countryname!;
            arrivalNextObj.nextDestCountryOutIndia =
                editNxtDestCounlist[0].countrycode;
          }
        });
      }
    }
    FormCCommonServices.getState().then((result) {
      stateList = result;
      //print('state $stateList');
    });
    FormCCommonServices.getPurposeOfVisit().then((result) {
      povList = result;
      //print('');
    });
    FormCCommonServices.getCountry().then((result) {
      countryList = result;
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) =>
    //     ShowCaseWidget.of(_scaffoldKey.currentContext).startShowCase([keyOne]));

    setState(() {
      //  page1 = widget.data;
      stepsWizard = new FormCWizardMenuItem(
          passportNumberInWizard: passportNumberFromSearch,
          nationalityInWizard: nationalityFromSearch,
          currentPageNo: "5");

      stepsWizardForPendingAppl =
          new FormCWizardMenuItem.editFormCTempApplication(
        applicationId: formCApplicationId,
        currentPageNo: "5",
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
      // _moveToStep3(arrivalNextObj);
      postArrivalNextDetailsData();
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
                Text(' Arrival,Next Destination Details ',
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
                    'Arrival Details',
                    style: TextStyle(color: blue, fontSize: 16),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: FIELDPADDING),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Arrived From Place *',
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
                      initialValue: arrivalNextObj.arrivedFromPlace,
                      name: "arrivedFromPlace",
                      maxLines: 1,
                      maxLength: MAX_LENGTH_TEXTFIELD,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(alphabetSpace))
                      ],
                      onChanged: (field) {
                        arrivalNextObj.arrivedFromPlace = field!.toUpperCase();
                      },
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon:
                            Icon(Icons.location_on_outlined, color: blue),
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

                        //  labelText: 'Arrived From Place',
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          // ignore: missing_return
                          (value) {
                            //print('inside validator pptno');
                            //print('value ppt $value');

                            if ((value == null || value.isEmpty) &&
                                isArrivalMandatory) {
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
                        'Arrived From City *',
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
                      initialValue: arrivalNextObj.arrivedFromCity,
                      name: "arrivedFromCity",
                      maxLines: 1,
                      maxLength: MAX_LENGTH_TEXTFIELD,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(alphaNumericSpace))
                      ],
                      onChanged: (field) {
                        arrivalNextObj.arrivedFromCity = field!.toUpperCase();
                      },
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(Icons.location_city, color: blue),
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

                        //     labelText: 'Arrived From City'
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          // ignore: missing_return
                          (value) {
                            //print('inside validator pptno');
                            //print('value ppt $value');

                            if ((value == null || value.isEmpty) &&
                                isArrivalMandatory) {
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
                        'Arrived From Country *',
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
                      controller: _arrivedFromCounController,
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
                            icon: (arrivalNextObj.arrivedFromCountry != null)
                                ? Icon(Icons.remove_circle)
                                : Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                arrivalNextObj.arrivedFromCountry = null;
                                _arrivedFromCounController.clear();
                              });
                            }),
                        //  contentPadding: EdgeInsets.all(10),
                        //  labelText: 'Arrived From Country',
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    // attribute: 'arrivedFromCountry',

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
                          if (arrivalNextObj.arrivedFromCountry == null ||
                              arrivalNextObj.arrivedFromCountry ==
                                  "") if ((value == null || value.isEmpty) &&
                              isArrivalMandatory) {
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
                      arrivalNextObj.arrivedFromCountry =
                          suggestion.countrycode;
                      _arrivedFromCounController.text = suggestion.countryname!;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: FIELDPADDING),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Date Of Arrival In India *',
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
                    name: "dateOfArrivalInIndia",
                    onChanged: (val) {
                      if (val != null)
                        arrivalNextObj.dateOfArrivalInIndia =
                            DateFormat("dd/MM/yyyy").format(val);
                    },
                    initialValue: (arrivalNextObj.dateOfArrivalInIndia != null)
                        ? (DateFormat("dd/MM/yyyy")
                            .parse(arrivalNextObj.dateOfArrivalInIndia!))
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
                      prefixIcon: Icon(Icons.date_range_outlined, color: blue),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: BORDERWIDTH, color: blue),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: BORDERWIDTH, color: blue),
                          borderRadius: BorderRadius.circular(10.0)),
                      //      labelText: 'Date of arrival in India'

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
                          if ((val == null || val == "") &&
                              isArrivalMandatory) {
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
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: FIELDPADDING),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Date Of Arrival In Hotel *',
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
                    name: "dateOfArrivalInHotel",
                    onChanged: (val) {
                      setState(() {
                        visaIssueFromInit = true;
                      });
                      if (val != null)
                        arrivalNextObj.dateOfArrivalInHotel =
                            DateFormat("dd/MM/yyyy").format(val);
                    },
                    initialValue: (arrivalNextObj.dateOfArrivalInHotel != null)
                        ? (DateFormat("dd/MM/yyyy")
                            .parse(arrivalNextObj.dateOfArrivalInHotel!))
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
                      prefixIcon: Icon(Icons.date_range_rounded, color: blue),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: BORDERWIDTH, color: blue),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: BORDERWIDTH, color: blue),
                          borderRadius: BorderRadius.circular(10.0)),
                      //   labelText: 'Date of arrival in hotel'

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
                          if ((val == null || val == "") &&
                              isArrivalMandatory) {
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
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: FIELDPADDING),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Time Of Arrival In Hotel (24hrs format)*',
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
                    name: "timeOfArrivalInHotel",
                    onChanged: (val) {
                      if (val != null)
                        arrivalNextObj.timeOfArrivalInHotel =
                            DateFormat("Hm").format(val);
                    },
                    initialValue: (arrivalNextObj.timeOfArrivalInHotel != null)
                        ? (DateFormat("Hm")
                            .parse(arrivalNextObj.timeOfArrivalInHotel!))
                        : null,
                    valueTransformer: (value) =>
                        (value != null) ? DateFormat("Hm").format(value) : null,
                    inputType: InputType.time,
                    format: DateFormat("Hm"),
                    //  readOnly:  page1.dateOfBirth !=null ? true : false ,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: CONTENTPADDING),
                      prefixIcon: Icon(Icons.timelapse, color: blue),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: BORDERWIDTH, color: blue),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: BORDERWIDTH, color: blue),
                          borderRadius: BorderRadius.circular(10.0)),
                      //      labelText: 'Time of arrival in hotel'

                      /*   suffixIcon: IconButton(
                    icon: new Icon(Icons.help),
                    tooltip: 'Date of birth as in Passport in DD/MM/YYYY format',
                    onPressed: () {},
                  ),*/
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        (value) {
                          if ((value == null || value == "") &&
                              isArrivalMandatory) {
                            return 'Required';
                          } else {
                            return null;
                          }
                        }
                        // ignore: missing_return
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
                    // firstDate: DateTime(DateTime.now().year - 100,
                    //     DateTime.now().month, DateTime.now().day),
                    // lastDate: DateTime.now(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: FIELDPADDING),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Duration Of Stay (in days)*',
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
                      initialValue: arrivalNextObj.durationOfStay,
                      name: "intendedDurationOfStay",
                      maxLines: 1,
                      maxLength: 20,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(alphaNumericSpace))
                      ],
                      onChanged: (field) {
                        arrivalNextObj.durationOfStay = field!.toUpperCase();
                      },
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(Icons.calendar_today, color: blue),
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

                        //    labelText: 'Intended duration of stay'
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          // ignore: missing_return
                          (value) {
                            //print('value ppt $value');

                            if ((value == null || value.isEmpty) &&
                                isArrivalMandatory) {
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
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Next Destination Details',
                    style: TextStyle(color: blue, fontSize: 16),
                  ),
                ),
                FormBuilderRadioGroup(
                  //     attribute: page1.newlyBornFlag,
                  initialValue: arrivalNextObj.nextDestCountryFlag,
                  onChanged: (val) {
                    setState(() {
                      arrivalNextObj.nextDestCountryFlag = val;
                    });

                    //  //print('newly : ${page1.newlyB
                    // ornFlag}');
                  },
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                        errorText: 'Required',
                      ),
                    ],
                  ),
                  options: [
                    FormBuilderFieldOption(
                        value: 'I',
                        child: Text(
                          'Inside India',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        )),
                    FormBuilderFieldOption(
                        value: 'O',
                        child: Text(
                          "Outside India",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        )),
                  ],
                  name: 'nextDestCounFlag',
                ),
                if (arrivalNextObj.nextDestCountryFlag == 'I')
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: FIELDPADDING),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Next Destination Place *',
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
                            initialValue: arrivalNextObj.nextDestPlaceInIndia,
                            name: "nextDestPlaceInInd",
                            maxLines: 1,
                            maxLength: MAX_LENGTH_TEXTFIELD,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(alphabetSpace))
                            ],
                            onChanged: (field) {
                              arrivalNextObj.nextDestPlaceInIndia =
                                  field!.toUpperCase();
                            },
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: CONTENTPADDING),
                              prefixIcon: Icon(Icons.location_on, color: blue),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: BORDERWIDTH, color: blue),
                                  borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: BORDERWIDTH, color: blue),
                                  borderRadius: BorderRadius.circular(10.0)),
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(10.0)),

//                                labelText: 'Next destination place '
                            ),
                            validator: FormBuilderValidators.compose(
                              [
                                // ignore: missing_return
                                (value) {
                                  //print('inside validator pptno');

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
                              'Next Destination State *',
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
                            controller: _nextDestStateInInd,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: CONTENTPADDING),
                              prefixIcon: Icon(Icons.location_city_rounded,
                                  color: blue),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: BORDERWIDTH, color: blue),
                                  borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: BORDERWIDTH, color: blue),
                                  borderRadius: BorderRadius.circular(10.0)),
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 16,
                                  letterSpacing: 1),
                              //   contentPadding: EdgeInsets.all(15.0),
                              suffixIcon: IconButton(
                                  icon: (arrivalNextObj.nextDeststateInIndia !=
                                          null)
                                      ? Icon(Icons.remove_circle)
                                      : Icon(Icons.search),
                                  onPressed: () {
                                    setState(() {
                                      //    page1.froState = null;
                                      arrivalNextObj.nextDeststateInIndia =
                                          null;
                                    });
                                  }),
                              // contentPadding: EdgeInsets.all(10),
                              //    labelText: 'Next Destination State',
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),

                          //   attribute: 'nextDestStateInInd',

                          // selectionToTextTransformer: (StateModel stateModel) {
                          //   return stateModel.statename;
                          // },
                          // initialValue: new StateModel(),
                          itemBuilder: (context, stateModel) {
                            return ListTile(
                              title: Text(
                                stateModel.statename!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              tileColor: blue,
                            );
                          },

                          suggestionsCallback: (query) {
                            if (query.isNotEmpty) {
                              var lowercaseQuery = query.toLowerCase();
                              return stateList.where((state) {
                                return state.statename!
                                    .toLowerCase()
                                    .contains(query.toLowerCase());
                              }).toList(growable: false)
                                ..sort((a, b) => a.statename!
                                    .toLowerCase()
                                    .indexOf(lowercaseQuery)
                                    .compareTo(b.statename!
                                        .toLowerCase()
                                        .indexOf(lowercaseQuery)));
                            } else {
                              return stateList
                                ..sort((a, b) => a.statename!
                                    .toLowerCase()
                                    .compareTo(b.statename!.toLowerCase()));
                            }
                          },
                          onSuggestionSelected: (StateModel suggestion) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            //page1.froState = newVal.statecode;

                            setState(() {
                              //  page1.froState = newVal.statecode;
                              arrivalNextObj.nextDestDistInIndia = null;

                              arrivalNextObj.nextDeststateInIndia =
                                  suggestion.statecode;
                              _nextDestStateInInd.text = suggestion.statename!;
                              FormCCommonServices.getDistrict(
                                      arrivalNextObj.nextDeststateInIndia!)
                                  .then((result) {
                                setState(() {
                                  distInIndList = result;
                                });
                              });
                              //  _controller.text = country;

                              //  //print(newVal.countrycode);
                              // final index = country.indexWhere(
                              //     (element) => element['country_name'] == newVal);
                              // //print(-index);

                              // //print(
                              //     'Using indexWhere: ${country[-index]['country_code']}');
                            });
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
                              'Next Destination District *',
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
                        child: FormBuilderDropdown(
                          initialValue: arrivalNextObj.nextDestDistInIndia,

                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: CONTENTPADDING),
                            prefixIcon: Icon(Icons.location_city, color: blue),
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
                            labelText: 'Next Destination District',
                            // border: OutlineInputBorder(
                            //     borderRadius: BorderRadius.circular(12),
                            //     borderSide: BorderSide(color: Colors.red)),
                          ),
                          // initialValue: 'Male',
                          // allowClear: true,

                          //   hint: Text('Select Gender'),

                          items: distInIndList
                              .map((district) => DropdownMenuItem(
                                    child: new Text(district.districtname!),
                                    value: district.districtcode.toString(),
                                  ))
                              .toList(),
                          name: 'anyOtherDist',
                          onChanged: (value) {
                            arrivalNextObj.nextDestDistInIndia = value;

                            FocusScope.of(context).requestFocus(FocusNode());
                            //     tempIdGeneration.gender = value;
                          },
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 15,
                ),
                if (arrivalNextObj.nextDestCountryFlag == "O")
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: FIELDPADDING),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Next Destination Place *',
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
                            initialValue: arrivalNextObj.nextDestCityOutIndia,
                            name: "nextDestPlaceOutInd",
                            maxLines: 1,
                            maxLength: MAX_LENGTH_TEXTFIELD,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(alphaNumericSpace))
                            ],
                            onChanged: (field) {
                              arrivalNextObj.nextDestPlaceOutIndia =
                                  field!.toUpperCase();
                            },
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: CONTENTPADDING),
                              prefixIcon: Icon(Icons.location_on, color: blue),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: BORDERWIDTH, color: blue),
                                  borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: BORDERWIDTH, color: blue),
                                  borderRadius: BorderRadius.circular(10.0)),
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(10.0)),

                              //  labelText: 'Next Destination Place',
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
                              'Next Destination City *',
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
                            initialValue: arrivalNextObj.nextDestCityOutIndia,
                            name: "nextDestCityOut",
                            maxLines: 1,
                            maxLength: MAX_LENGTH_TEXTFIELD,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(alphabetSpace))
                            ],
                            onChanged: (field) {
                              arrivalNextObj.nextDestCityOutIndia =
                                  field!.toUpperCase();
                            },
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: CONTENTPADDING),
                              prefixIcon:
                                  Icon(FontAwesomeIcons.location, color: blue),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: BORDERWIDTH, color: blue),
                                  borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: BORDERWIDTH, color: blue),
                                  borderRadius: BorderRadius.circular(10.0)),
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(10.0)),

                              //    labelText: 'Next Destination City',
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
                              'Next Destination Country *',
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
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: CONTENTPADDING),
                              prefixIcon:
                                  Icon(FontAwesomeIcons.globe, color: blue),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: BORDERWIDTH, color: blue),
                                  borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: BORDERWIDTH, color: blue),
                                  borderRadius: BorderRadius.circular(10.0)),
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 16,
                                  letterSpacing: 1),
                              //   contentPadding: EdgeInsets.all(15.0),
                              suffixIcon: IconButton(
                                  icon: (nextDestCoun != null)
                                      ? Icon(Icons.remove_circle)
                                      : Icon(Icons.search),
                                  onPressed: () {
                                    setState(() {
                                      nextDestCoun = null;
                                      _nextDestCountry.clear();
                                    });
                                  }),
                              //  contentPadding: EdgeInsets.all(10),
                              //    labelText: 'Next Destination Country',
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(10.0)),
                            ),
                            controller: _nextDestCountry,
                          ),

                          // attribute: 'nextDestCoun',

                          // selectionToTextTransformer:
                          //     (CountryModel countryModel) {
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
                              FormBuilderValidators.required(
                                errorText: 'Required',
                              ),
                              (value) {
                                if (arrivalNextObj.nextDestCountryOutIndia ==
                                        null ||
                                    arrivalNextObj.nextDestCountryOutIndia ==
                                        "") {
                                  return "Select from suggestions only";
                                } else {
                                  return null;
                                }
                              }
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
                            arrivalNextObj.nextDestCountryOutIndia =
                                suggestion.countrycode;
                            nextDestCoun = suggestion.countrycode;
                            _nextDestCountry.text = suggestion.countryname!;
                          },
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
