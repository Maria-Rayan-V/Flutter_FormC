import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/util/utility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:formc_showcase/models/applicationModel.dart';
import 'package:formc_showcase/models/masters/districtModel.dart';
import 'package:formc_showcase/models/masters/stateModel.dart';
import 'package:formc_showcase/services/formC_commonServices.dart';
import 'package:formc_showcase/util/validations.dart';
import 'package:flutter/services.dart';
import 'package:formc_showcase/models/masters/countryModel.dart';
import 'package:formc_showcase/util/spUtil.dart';
import 'package:http/http.dart' as http;
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:formc_showcase/screens/formC_wizard.dart';
import 'package:intl/intl.dart';

class ApplicationGeneration extends StatefulWidget {
//  const ApplicationGeneration({ Key? key }) : super(key: key);
  dynamic data;
  var passportNumber, nationality;
  ApplicationGeneration.freshAppl();
  ApplicationGeneration({Key? key, @required this.data, String? appId})
      : super(key: key);

  @override
  _ApplicationGenerationState createState() => _ApplicationGenerationState();
}

class _ApplicationGenerationState extends State<ApplicationGeneration> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController _stateOfReferenceController =
      new TextEditingController();
  List<CountryModel> editCountryOutsideList = [];
  List<StateModel> editStateList = [];
  FormCWizardMenuItem? stepsWizard;
  FormCWizardMenuItem? stepsWizardForPendingAppl;
  //List<DistrictModel> districtList = [];
  TextEditingController _countryController = new TextEditingController();
  ApplicationModel temporaryApplicationIdGeneration = ApplicationModel();
  List<DistrictModel> distInIndList = [];
  List<StateModel> stateList = [];
  var passportNumberFromSearch, nationalityFromSearch, formCApplicationId;
  var userCountry, accoCode, frroFroCode, enteredBy, pendingApplicationId;
  List? formCExistingData;
  List<CountryModel> countries = [];
  String? img;
  double photoSize = 0.0;
  bool buttonEnabled = true;
  bool? isPendingApplication;
  bool isCtryNonEditable = false;
  bool isDataFromQR = false;
  var dataFromQR;
  enableButton(bool flag) {
    setState(() {
      buttonEnabled = flag;
    });
  }

  isEnabled() {
    return buttonEnabled;
  }

  next() {
    if (_fbKey.currentState!.saveAndValidate()) {
      print('Inside valid func if');
      print('///////////////////////////');
      generateApplicationId();
      // Navigator.of(context)xxxxx/
      //     .pushReplacementNamed("/loginScreen");
      //  validateUser(getuserName);
      //print('true');
    } else {
      (isPendingApplication == true)
          ? temporaryApplicationIdGeneration.applicationId =
              temporaryApplicationIdGeneration.applicationId
          : temporaryApplicationIdGeneration.applicationId = null;
      var data = json.encode({
        'form_c_appl_id': temporaryApplicationIdGeneration.applicationId,
        "given_name": temporaryApplicationIdGeneration.givenName!.toUpperCase(),
        "surname": temporaryApplicationIdGeneration.surName!.toUpperCase(),
        "gender": temporaryApplicationIdGeneration.gender,
        "country_outside_india":
            temporaryApplicationIdGeneration.countryOfPermanentResidence,
        "acco_code": accoCode,
        "entered_by": enteredBy,
        "stateofrefinind": temporaryApplicationIdGeneration.stateOfReference,
        "cityofrefinind": temporaryApplicationIdGeneration.cityOfReference,
        "frro_fro_code": frroFroCode
      });
      // print('Inside Gen app id $data');
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white),
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

  back() {
    //print('Previous Page: P0');
    Navigator.pop(context);
  }

  generateApplicationId() async {
    print('Inside genappid func ....');
    print('///////////////////////////');
    EasyLoading.show(status: 'Please Wait...');
    var token = await HttpUtils().getToken();
    //print('token: $token');
    (isPendingApplication == true)
        ? temporaryApplicationIdGeneration.applicationId =
            temporaryApplicationIdGeneration.applicationId
        : temporaryApplicationIdGeneration.applicationId = null;
    try {
      var data = json.encode({
        'form_c_appl_id': temporaryApplicationIdGeneration.applicationId,
        "given_name": temporaryApplicationIdGeneration.givenName!.toUpperCase(),
        "surname": temporaryApplicationIdGeneration.surName?.toUpperCase(),
        "gender": temporaryApplicationIdGeneration.gender,
        "country_outside_india":
            temporaryApplicationIdGeneration.countryOfPermanentResidence,
        "acco_code": accoCode,
        "entered_by": enteredBy,
        "stateofrefinind": temporaryApplicationIdGeneration.stateOfReference,
        "cityofrefinind": temporaryApplicationIdGeneration.cityOfReference,
        "frro_fro_code": frroFroCode
      });
      print('Inside Gen app id $data');
      print(GENERATE_APPLID);
      await http.post(
        Uri.parse(GENERATE_APPLID),
        body: data,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $token'
        },
      ).then((response) async {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        var responseJson = json.decode(response.body);
        //print('ResponseJson :$responseJson');
        var newApplicationId = responseJson['form_c_appl_id'];
        var countryOutsideIndia = responseJson['country_outside_india'];
        var givenName = responseJson['given_name'];
        var stateOfRef = responseJson['stateofrefinind'];
        var cityOfRef = responseJson['cityofrefinind'];
        var surname = responseJson['surname'];

        await HttpUtils().saveNewApplicationId(newApplicationId);

        await HttpUtils().saveApplicantCountryOutsideIndia(countryOutsideIndia);

        await HttpUtils().saveApplicantGivenName(givenName);

        await HttpUtils().saveApplicantSurname(surname);

        await HttpUtils().saveApplicantStateOfReference(stateOfRef);

        await HttpUtils().saveApplicantCityOfReference(cityOfRef);

        // //print(chkuser);
        if (response.statusCode == 200) {
          await HttpUtils().saveNewApplicationId(newApplicationId);
          (isPendingApplication == true)
              ? stepsWizardForPendingAppl!
                  .createState()
                  .moveToPendingDataScreen(newApplicationId, "2", context)
              : stepsWizard!.createState().moveToScreen(
                  passportNumberFromSearch,
                  nationalityFromSearch,
                  "2",
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
                  Text('Something went wrong, Please try again later'),
                ]));
          });
    }

    EasyLoading.dismiss();
  }

  getFlutterSecureStorageData() async {
    passportNumberFromSearch = await HttpUtils().getExistingFormCPptNo();
    nationalityFromSearch = await HttpUtils().getExistingFormCNationality();
    enteredBy = await HttpUtils().getUsername();

    accoCode = await HttpUtils().getAccocode();
    frroFroCode = await HttpUtils().getFrrocode();
    setState(() {
      passportNumberFromSearch = passportNumberFromSearch;
      nationalityFromSearch = nationalityFromSearch;
      enteredBy = enteredBy;
      accoCode = accoCode;
      frroFroCode = frroFroCode;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getFlutterSecureStorageData();
    isDataFromQR = SpUtil.getBool('isDataFromQR');
    print('isDataFromQR $isDataFromQR');
    if (widget.data != null) {
      if (isDataFromQR == true) {
        dataFromQR = widget.data;
        if (dataFromQR.containsKey('first_name')) {
          print('contains key ${dataFromQR.containsKey('first_name')}');

          temporaryApplicationIdGeneration.surName = dataFromQR['last_name'];
          temporaryApplicationIdGeneration.givenName = dataFromQR['first_name'];
          // temporaryApplicationIdGeneration.
        }
      } else {
        formCExistingData = widget.data;
      }

      // formCExistingData = widget.data;
    }

    isPendingApplication = SpUtil.getBool('isPendingApplication');
    //print('isPending : $isPendingApplication');
    setState(() {
      //  page1 = widget.data;
      stepsWizard = new FormCWizardMenuItem(
          passportNumberInWizard: passportNumberFromSearch,
          nationalityInWizard: nationalityFromSearch,
          currentPageNo: "1");
    });
    setState(() {
      stepsWizardForPendingAppl =
          new FormCWizardMenuItem.editFormCTempApplication(
        applicationId: formCApplicationId,
        currentPageNo: "1",
      );
    });
    //// print('Form C Existing ${formCExistingData[0].countryOutsideIndia}');
    if (formCExistingData != null && formCExistingData!.length > 0) {
      temporaryApplicationIdGeneration.applicationId =
          formCExistingData![0].formCApplicationId;
      temporaryApplicationIdGeneration.givenName =
          formCExistingData![0].givenName;
      temporaryApplicationIdGeneration.surName = formCExistingData![0].surname;
      temporaryApplicationIdGeneration.gender = formCExistingData![0].gender;
      temporaryApplicationIdGeneration.countryOfPermanentResidence =
          formCExistingData![0].countryOutsideIndia;
      if (isPendingApplication == false &&
          temporaryApplicationIdGeneration.countryOfPermanentResidence !=
              null &&
          temporaryApplicationIdGeneration.countryOfPermanentResidence != "") {
        setState(() {
          isCtryNonEditable = true;
        });
      }
      if (temporaryApplicationIdGeneration.countryOfPermanentResidence !=
          null) {
        FormCCommonServices.getSpecificCountry(
                temporaryApplicationIdGeneration.countryOfPermanentResidence!)
            .then((result) {
          editCountryOutsideList = result;
          if (editCountryOutsideList != null &&
              editCountryOutsideList.length > 0) {
            _countryController.text = editCountryOutsideList[0].countryname!;
            temporaryApplicationIdGeneration.countryOfPermanentResidence =
                editCountryOutsideList[0].countrycode;
            // print(
            // 'valueinit ${temporaryApplicationIdGeneration.countryOfPermanentResidence}');
          }
        });
      }
      temporaryApplicationIdGeneration.stateOfReference =
          formCExistingData![0].stateOfReference;
      if (temporaryApplicationIdGeneration.stateOfReference != null) {
        FormCCommonServices.getSpecificState(
                temporaryApplicationIdGeneration.stateOfReference!)
            .then((result) {
          editStateList = result;
          //print('Single state:$editStateList');
          if (editStateList != null && editStateList.length > 0) {
            _stateOfReferenceController.text = editStateList[0].statename!;
            temporaryApplicationIdGeneration.stateOfReference =
                editStateList[0].statecode;
          }
        });
        FormCCommonServices.getDistrict(
                temporaryApplicationIdGeneration.stateOfReference!)
            .then((result) {
          setState(() {
            distInIndList = result;
            //print('distInInd :$distInIndList');
          });
        });
      }
      temporaryApplicationIdGeneration.cityOfReference =
          formCExistingData![0].cityOfReference;
      //print('gender : ${temporaryApplicationIdGeneration.cityOfReference}');
    }
    //print('formCexis :$formCExistingData');
    FormCCommonServices.getState().then((result) {
      stateList = result;
      //print('state $stateList');
    });
    FormCCommonServices.getCountry().then((result) {
      countries = result;
      //print('countries $countries');
    });
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
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
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
          body: SingleChildScrollView(
            child: FormBuilder(
              key: _fbKey,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  // Card(
                  //   elevation: 5,
                  //   child: Container(
                  //     width: 300,
                  //     height: 300,
                  //     child: Stack(
                  //       children: <Widget>[
                  //         (img != null)
                  //             ? Image.memory(base64Decode(img))
                  //             : Image.asset(
                  //                 "assets/images/image-placeholder-500x500.jpg"),
                  //         Positioned(
                  //           bottom: 0.0,
                  //           left: 0.0,
                  //           right: 0.0,
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //               gradient: LinearGradient(
                  //                 colors: [
                  //                   Color.fromARGB(200, 0, 0, 0),
                  //                   Color.fromARGB(0, 0, 0, 0)
                  //                 ],
                  //                 begin: Alignment.bottomCenter,
                  //                 end: Alignment.topCenter,
                  //               ),
                  //             ),
                  //             padding: EdgeInsets.symmetric(
                  //                 vertical: 10.0, horizontal: 20.0),
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 IconButton(
                  //                   onPressed: () {
                  //                     _settingModalBottomSheet();
                  //                   },
                  //                   icon: Icon(
                  //                     Icons.photo_camera,
                  //                     color: Colors.white,
                  //                   ),
                  //                   iconSize: 35.0,
                  //                 ),
                  //                 IconButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       img = null;
                  //                       photoSize = 0.0;
                  //                     });
                  //                   },
                  //                   icon: Icon(
                  //                     Icons.clear_rounded,
                  //                     color: Colors.red,
                  //                   ),
                  //                   iconSize: 35.0,
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  /* Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _settingModalBottomSheet();
                                    },
                                    icon: Icon(
                                      Icons.photo_camera,
                                      color: Colors.white,
                                    ),
                                    iconSize: 35.0,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        img = null;
                                        photoSize = 0.0;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.clear_rounded,
                                      color: Colors.red,
                                    ),
                                    iconSize: 35.0,
                                  ),
                                ],
                              ),
                  //           ), */
                  //       ],
                  //     ),
                  //   ),
                  // ),

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
                    padding: const EdgeInsets.only(left: LABELPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Given Name *',
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
                    padding: const EdgeInsets.only(
                        left: LABELPADDING,
                        right: LABELPADDING,
                        top: TOPPADDING),
                    child: Container(
                      child: FormBuilderTextField(
                        //     autocorrect: false,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        initialValue:
                            temporaryApplicationIdGeneration.givenName,
                        name: "givenName",
                        maxLines: 1,
                        maxLength: MAX_LENGTH_TEXTFIELD,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                          FilteringTextInputFormatter.allow(
                              RegExp(alphabetsSpaceDot))
                        ],
                        onChanged: (value) {
                          temporaryApplicationIdGeneration.givenName = value;

                          //print('gnname $value');
                          // FocusScope.of(context).nextFocus();
                        },
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: CONTENTPADDING),
                          prefixIcon: Icon(Icons.person, color: blue),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          //labelText: 'Given Name *',
                        ),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                              errorText: 'Required',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: LABELPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Surname ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        )),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: LABELPADDING,
                        right: LABELPADDING,
                        top: TOPPADDING),
                    child: Container(
                      child: FormBuilderTextField(
                        //     autocorrect: false,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        initialValue: temporaryApplicationIdGeneration.surName,
                        name: "surname",
                        maxLines: 1,
                        maxLength: MAX_LENGTH_TEXTFIELD,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                          FilteringTextInputFormatter.allow(
                              RegExp(alphabetsSpaceDot))
                        ],
                        onChanged: (value) {
                          temporaryApplicationIdGeneration.surName = value;

                          //print('surname $value');
                          // FocusScope.of(context).nextFocus();
                        },
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: CONTENTPADDING),
                          prefixIcon: Icon(Icons.person, color: blue),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          //    labelText: 'Surname *',
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: LABELPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Gender *',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        )),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: LABELPADDING,
                        right: LABELPADDING,
                        top: TOPPADDING),
                    child: FormBuilderDropdown(
                      initialValue: temporaryApplicationIdGeneration.gender,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon:
                            Icon(Icons.location_history_sharp, color: blue),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: 1),
                        //    labelText: 'Gender *',
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      // initialValue: 'Male',
                      // allowClear: true,
                      //   hint: Text('Select Gender'),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            errorText: 'Required',
                          )
                        ],
                      ),
                      items: GENDERLIST
                          .map((gender) => DropdownMenuItem(
                                child: new Text(gender['gender_desc']),
                                value: gender['gender_code'].toString(),
                              ))
                          .toList(),

                      onChanged: (value) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        temporaryApplicationIdGeneration.gender = value;
                      },
                      name: 'gender',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: LABELPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Country Outside India *',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        )),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: LABELPADDING,
                        right: LABELPADDING,
                        top: TOPPADDING),
                    child: TypeAheadFormField(
                      hideSuggestionsOnKeyboardHide: isCtryNonEditable,
                      hideKeyboard: isCtryNonEditable,

                      getImmediateSuggestions: false,
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _countryController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: CONTENTPADDING),
                          prefixIcon: Icon(FontAwesomeIcons.globe, color: blue),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                          //   contentPadding: EdgeInsets.all(15.0),
                          suffixIcon: IconButton(
                              icon: (userCountry != null)
                                  ? Icon(Icons.remove_circle)
                                  : Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  userCountry = null;
                                  _countryController.clear();
                                });
                              }),
                          //  contentPadding: EdgeInsets.all(10),
                          //     labelText: 'Country Outside India *',
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),

                      // attribute: 'country',

                      // selectionToTextTransformer: (CountryModel countryModel) {
                      //   return countryModel.countryname;
                      // },

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
                            if (temporaryApplicationIdGeneration
                                        .countryOfPermanentResidence ==
                                    null ||
                                temporaryApplicationIdGeneration
                                        .countryOfPermanentResidence ==
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
                          return countries.where((country) {
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
                          return countries
                            ..sort((a, b) => a.countryname!
                                .toLowerCase()
                                .compareTo(b.countryname!.toLowerCase()));
                        }
                      },
                      onSuggestionSelected: (CountryModel suggestion) {
                        temporaryApplicationIdGeneration.stateOfReference =
                            null;
                        temporaryApplicationIdGeneration.cityOfReference = null;
                        _stateOfReferenceController.text = "";
                        _countryController.text = suggestion.countryname!;
                        userCountry = suggestion.countrycode;
                        temporaryApplicationIdGeneration
                                .countryOfPermanentResidence =
                            suggestion.countrycode;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: LABELPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'State Of Reference *',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        )),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: LABELPADDING,
                        right: LABELPADDING,
                        top: TOPPADDING),
                    child: TypeAheadFormField(
                      getImmediateSuggestions: false,
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _stateOfReferenceController,
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
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                          //   contentPadding: EdgeInsets.all(15.0),
                          suffixIcon: IconButton(
                              icon: (temporaryApplicationIdGeneration
                                          .stateOfReference !=
                                      null)
                                  ? Icon(Icons.remove_circle)
                                  : Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  _stateOfReferenceController.text = "";
                                  temporaryApplicationIdGeneration
                                      .stateOfReference = null;
                                });
                              }),

                          // contentPadding: EdgeInsets.all(10),
                          // labelText: 'State Of Reference *',
                          // border: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            errorText: 'Required',
                          ),
                          (value) {
                            if (temporaryApplicationIdGeneration
                                        .stateOfReference ==
                                    null ||
                                temporaryApplicationIdGeneration
                                        .stateOfReference ==
                                    "") {
                              return "Select from suggestions only";
                            } else {
                              return null;
                            }
                          }
                        ],
                      ),

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
                        setState(() {
                          //  page1.froState = newVal.statecode;
                          temporaryApplicationIdGeneration.cityOfReference =
                              null;
                          _stateOfReferenceController.text =
                              suggestion.statename!;

                          temporaryApplicationIdGeneration.stateOfReference =
                              suggestion.statecode;

                          FormCCommonServices.getDistrict(
                                  temporaryApplicationIdGeneration
                                      .stateOfReference!)
                              .then((result) {
                            setState(() {
                              print('District Response ${result[0]}');
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
                    padding: const EdgeInsets.only(left: LABELPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'City Of Reference *',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        )),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: LABELPADDING,
                        right: LABELPADDING,
                        top: TOPPADDING),
                    child: FormBuilderDropdown(
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            errorText: 'Required',
                          ),
                          (value) {
                            if (temporaryApplicationIdGeneration
                                        .cityOfReference ==
                                    null ||
                                temporaryApplicationIdGeneration
                                        .cityOfReference ==
                                    "") {
                              return "Select from suggestions only";
                            } else {
                              return null;
                            }
                          }
                        ],
                      ),
                      initialValue:
                          temporaryApplicationIdGeneration.cityOfReference,

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
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: 1),
                        // labelText: "City Of Reference *",
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

                      name: 'cityOfRef',
                      onChanged: (value) {
                        temporaryApplicationIdGeneration.cityOfReference =
                            value;

                        FocusScope.of(context).requestFocus(FocusNode());
                        //     tempIdGeneration.gender = value;
                      },
                    ),
                  )

                  // RaisedButton(
                  //   color: blue,
                  //   child: Text(
                  //     'Save',
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  //   onPressed: () {
                  //     if (_fbKey.currentState.saveAndValidate()) {
                  //       generateApplicationId();
                  //       // Navigator.of(context)
                  //       //     .pushReplacementNamed("/loginScreen");
                  //       //  validateUser(getuserName);
                  //       //print('true');
                  //     } else {
                  //       showDialog(
                  //           context: context,
                  //           builder: (BuildContext context) => AlertDialog(
                  //                 actions: [
                  //                   TextButton(
                  //                     child: new Text('Ok',
                  //                         style: TextStyle(
                  //                             color: blue)),
                  //                     onPressed: () {
                  //                       Navigator.of(context).pop();
                  //                     },
                  //                   ),
                  //                 ],
                  //                 title:
                  //                     Text(" Please enter the mandatory field "),
                  //               ));
                  //     }
                  //   },
                  //),
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10.0), primary: blue),
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: blue,
                    padding: EdgeInsets.all(10.0),
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
