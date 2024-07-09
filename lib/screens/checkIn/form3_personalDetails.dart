import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formc_showcase/Widgets/CustomShowCaseWidget.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:http/http.dart' as http;
import 'package:formc_showcase/models/formCPersonalModel.dart';
import 'package:formc_showcase/models/masters/countryModel.dart';
import 'package:formc_showcase/models/masters/splCategoryModel.dart';
import 'package:formc_showcase/services/formC_commonServices.dart';
import 'package:formc_showcase/util/validations.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:convert';
import '../formC_wizard.dart';
import 'package:formc_showcase/util/spUtil.dart';

class PersonalDetailsScreen extends StatefulWidget {
  dynamic data;

  PersonalDetailsScreen({Key? key, @required this.data, String? appId})
      : super(key: key);

  @override
  _PersonalDetailsScreenState createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  FormCWizardMenuItem? stepsWizard;
  FormCWizardMenuItem? stepWizardForPendingAppl;
  List? formCExistingData;
  bool isPptNatNonEditable = false;
  FormCPersonalModel personalDetailObj = new FormCPersonalModel();
  String? splCategory, nationality;
  TextEditingController dateOfBirth = TextEditingController();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  //TextEditingController _controller;
  TextEditingController _nationalityController = new TextEditingController();
  TextEditingController _splCategoryController = new TextEditingController();
  bool isDisablePage = false;
  dynamic pendingData;
  bool buttonEnabled = true;
  bool? isPendingApplication;
  String? applID, applName;
  var formCApplicationId;
  List<CountryModel> countryList = [];
  List<CountryModel> editCountryList = [];
  List<SplCategoryModel> splCategoryList = [];
  List<SplCategoryModel> editSplCatList = [];
  dynamic currDt = DateTime.now();
  dynamic curryear, age, birthYear;
  DateTime? _dateTime;
  var passportNumberFromSearch, nationalityFromSearch;
  postPersonalDetailsData() async {
    EasyLoading.show(status: 'Please Wait...');
    var token = await HttpUtils().getToken();
    var newApplicationId = await HttpUtils().getNewApplicationId();

    await HttpUtils().saveApplicantDOB(personalDetailObj.dob!);
    await HttpUtils().saveSplcatCode(personalDetailObj.splcategory!);
    // print('token: $token');
    try {
      var data = json.encode({
        "form_c_appl_id": newApplicationId,
        "name": personalDetailObj.name?.toUpperCase(),
        "surname": personalDetailObj.surname?.toUpperCase(),
        "dobformat": personalDetailObj.dobFormat,
        "dob": personalDetailObj.dob,
        "nationality": personalDetailObj.nationality,
        "addroutind": personalDetailObj.addressOutsideIndia,
        "cityoutind": personalDetailObj.cityOutsideIndia,
        "counoutind": countryOutsideIndia,
        "splcategorycode": personalDetailObj.splcategory,
      });
      // print(data);
      // print(POST_PERSONAL_DETAILS);
      await http.post(
        Uri.parse(POST_PERSONAL_DETAILS),
        body: data,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $token'
        },
      ).then((response) async {
        // print("Response status: ${response.statusCode}");
        // print("Response body: ${response.body}");
        var responseJson = json.decode(response.body);
        //   print('ResponseJson :$responseJson');

        // print(chkuser);
        if (response.statusCode == 200) {
          (isPendingApplication == true)
              ? stepWizardForPendingAppl!
                  .createState()
                  .moveToPendingDataScreen(formCApplicationId, "4", context)
              : stepsWizard!.createState().moveToScreen(
                  passportNumberFromSearch,
                  nationalityFromSearch,
                  "4",
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

  var countryOutsideIndia;
  getFlutterSecureStorageData() async {
    passportNumberFromSearch = await HttpUtils().getExistingFormCPptNo();
    nationalityFromSearch = await HttpUtils().getExistingFormCNationality();
    formCApplicationId = await HttpUtils().getNewApplicationId();
    personalDetailObj.name = await HttpUtils().getApplicantGivenName();
    personalDetailObj.surname = await HttpUtils().getApplicantSurname();
    countryOutsideIndia = await HttpUtils().getApplicantCountryOutsideIndia();
    setState(() {
      passportNumberFromSearch = passportNumberFromSearch;
      nationalityFromSearch = nationalityFromSearch;
      formCApplicationId = formCApplicationId;
      personalDetailObj.name = personalDetailObj.name;
      personalDetailObj.surname = personalDetailObj.surname;
      countryOutsideIndia = countryOutsideIndia;
    });
  }

  dateParseFun(String dateToFormat) {
    String formateddate = dateToFormat;
    final dateList = formateddate.split("/");
    String formattedDob = dateList[2] + '-' + dateList[1] + '-' + dateList[0];
    _dateTime = DateTime.parse(formattedDob);
    //   print('Datedob $_dateTime');
    return _dateTime;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFlutterSecureStorageData();
    isPendingApplication = SpUtil.getBool('isPendingApplication');
    curryear = currDt.year;

    // WidgetsBinding.instance.addPostFrameCallback((_) =>
    //     ShowCaseWidget.of(_scaffoldKey.currentContext).startShowCase([keyOne]));
    FormCCommonServices.getSplCategory().then((result) {
      splCategoryList = result;
    });
    FormCCommonServices.getCountry().then((result) {
      countryList = result;
    });
    if (widget.data != null) {
      formCExistingData = widget.data;

      setState(() {
        isPptNatNonEditable = true;
      });

      //  print('Form C Exis pers:$formCExistingData');
    }
    if (formCExistingData != null && formCExistingData!.length > 0) {
      personalDetailObj.dobFormat = formCExistingData![0].dobFormat;
      personalDetailObj.dob = formCExistingData![0].dob;
      if (personalDetailObj.dob != null) {
        dateParseFun(personalDetailObj.dob!);
        dateOfBirth.text = formCExistingData![0].dob;
      }
      personalDetailObj.nationality = formCExistingData![0].nationality;
      if (personalDetailObj.nationality != null) {
        FormCCommonServices.getSpecificCountry(personalDetailObj.nationality!)
            .then((result) {
          editCountryList = result;
          if (editCountryList != null && editCountryList.length > 0) {
            _nationalityController.text = editCountryList[0].countryname!;
            personalDetailObj.nationality = editCountryList[0].countrycode;
          }
        });
      }

      personalDetailObj.splcategory = formCExistingData![0].splCategoryCode;
      if (personalDetailObj.splcategory != null) {
        FormCCommonServices.getSpecificSplCategory(
                personalDetailObj.splcategory!)
            .then((result) {
          editSplCatList = result;
          if (editSplCatList != null && editSplCatList.length > 0) {
            _splCategoryController.text = editSplCatList[0].splcategoryDesc!;
            personalDetailObj.splcategory = editSplCatList[0].splcategoryCode;
          }
        });
      }
      personalDetailObj.addressOutsideIndia =
          formCExistingData![0].addrOutsideIndia;
      personalDetailObj.cityOutsideIndia =
          formCExistingData![0].cityOutsideIndia;
      personalDetailObj.countryOutsideIndia =
          formCExistingData![0].countryOutsideIndia;
    }
    setState(() {
      //  personalDetailObj = widget.data;
      stepsWizard = new FormCWizardMenuItem(
          passportNumberInWizard: passportNumberFromSearch,
          nationalityInWizard: nationalityFromSearch,
          currentPageNo: "3");
      stepWizardForPendingAppl =
          new FormCWizardMenuItem.editFormCTempApplication(
        applicationId: formCApplicationId,
        currentPageNo: "3",
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  ageCalculator(dynamic birthYear) {
    var age = curryear - birthYear;
    //  print('Age $age');
    return age;
  }

  dateParseFormatter(var beforeParse) {
    var date = DateTime.parse('$beforeParse');
    var dateFormatter = new DateFormat("dd/MM/yyyy");
    String formattedDate = dateFormatter.format(date);
    // print('result $formattedDate');
    return formattedDate;
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

  isEnabled() {
    return buttonEnabled;
  }

  next() {
    if (_fbKey.currentState!.saveAndValidate()) {
      postPersonalDetailsData();
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

  back() {
    //print('Previous Page: P0');
    Navigator.pop(context);
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
            //initialValue: {"country": userNationality},
            child: AbsorbPointer(
                absorbing: isPageDisabled() ? true : false,
                child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                        1, 15, 8, MediaQuery.of(context).viewInsets.bottom),
                    child: Column(children: <Widget>[
                      // SelectableText(
                      //     '${personalDetailObj.name} ${personalDetailObj.surname}   (applid)',
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
                      Text(' Personal Details ',
                          style: TextStyle(
                              //   decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: blue)),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Personal Details',
                            style: TextStyle(
                              color: blue,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(FIELDPADDING),
                      //   child: Container(
                      //     child: FormBuilderTextField(
                      //       initialValue: personalDetailObj.name,
                      //       attribute: "userName",
                      //       maxLines: 1,
                      //       maxLength: MAX_LENGTH_TEXTFIELD,
                      //       inputFormatters: [
                      //         FilteringTextInputFormatter.allow(
                      //             RegExp(alphabetsSpaceDot))
                      //       ],
                      //       onChanged: (field) {
                      //         personalDetailObj.name = field.toUpperCase();
                      //         print('Name ${personalDetailObj.name}');
                      //       },
                      //       textCapitalization: TextCapitalization.characters,
                      //       textInputAction: TextInputAction.next,
                      //       decoration: InputDecoration(
                      //         // border: OutlineInputBorder(
                      //         //     borderRadius: BorderRadius.circular(10.0)),
                      //         labelText: 'Name',
                      //         labelStyle: TextStyle(
                      //             fontWeight: FontWeight.w500,
                      //             color: Colors.black,
                      //             fontSize: 16,
                      //             letterSpacing: 1),
                      //       ),
                      //       // validators: [
                      //       //   FormBuilderValidators.required(
                      //       //     errorText: 'Required',
                      //       //   ),
                      //       // ],
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(FIELDPADDING),
                      //   child: Container(
                      //     child: FormBuilderTextField(
                      //       initialValue: personalDetailObj.surname,
                      //       attribute: "surName",
                      //       maxLines: 1,
                      //       maxLength: MAX_LENGTH_TEXTFIELD,
                      //       inputFormatters: [
                      //         FilteringTextInputFormatter.allow(
                      //             RegExp(alphabetsSpaceDot))
                      //       ],
                      //       onChanged: (field) {
                      //         personalDetailObj.surname = field.toUpperCase();
                      //         print('surname ${personalDetailObj.surname}');
                      //       },
                      //       textCapitalization: TextCapitalization.characters,
                      //       textInputAction: TextInputAction.next,
                      //       decoration: InputDecoration(
                      //         // border: OutlineInputBorder(
                      //         //     borderRadius: BorderRadius.circular(10.0)),
                      //         labelText: 'Surname',
                      //         labelStyle: TextStyle(
                      //             fontWeight: FontWeight.w500,
                      //             color: Colors.black,
                      //             fontSize: 16,
                      //             letterSpacing: 1),
                      //       ),
                      //       // validators: [
                      //       //   FormBuilderValidators.required(
                      //       //     errorText: 'Required',
                      //       //   ),
                      //       // ],
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: FIELDPADDING),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Date Of Birth Format *',
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
                          initialValue: personalDetailObj.dobFormat,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: CONTENTPADDING),
                            prefixIcon:
                                Icon(FontAwesomeIcons.calendar, color: blue),
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 16,
                                letterSpacing: 1),
                            //labelText: 'Date of birth format',
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: BORDERWIDTH, color: blue),
                                borderRadius: BorderRadius.circular(10.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: BORDERWIDTH, color: blue),
                                borderRadius: BorderRadius.circular(10.0)),
                            // border: OutlineInputBorder(
                            //     borderRadius: BorderRadius.circular(12),
                            //     borderSide: BorderSide(color: Colors.red)),
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
                          items: DOBFORMATLIST
                              .map((dobFormat) => DropdownMenuItem(
                                    child:
                                        new Text(dobFormat['dobFormat_desc']),
                                    value:
                                        dobFormat['dobFormat_code'].toString(),
                                  ))
                              .toList(),
                          name: 'dobFormat',
                          onChanged: (value) {
                            personalDetailObj.dobFormat = value;
                            //    print('dobformat ${personalDetailObj.dobFormat}');
                            FocusScope.of(context).requestFocus(FocusNode());
                            //     tempIdGeneration.gender = value;
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: FIELDPADDING),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Date Of Birth *',
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
                            controller: dateOfBirth,
                            name: "dob",
                            //   initialValue: personalDetailObj.dob,
                            maxLines: 1,
                            maxLength: MAX_LENGTH_TEXTFIELD,
                            onTap: () async {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              if (personalDetailObj.dobFormat == "DD") {
                                //  print(personalDetailObj.dobFormat);
                                showDatePicker(
                                        //    initialEntryMode:const DatePickerEntryMode(2),
                                        context: context,
                                        initialDate: _dateTime == null
                                            ? DateTime.now()
                                            : _dateTime!,
                                        firstDate: DateTime(
                                            DateTime.now().year - dobFirstDate,
                                            DateTime.now().month,
                                            DateTime.now().day),
                                        lastDate: DateTime.now())
                                    .then((date) {
                                  if (((date!.day) < 10) &&
                                      ((date.month) < 10)) {
                                    personalDetailObj.dob =
                                        '0${date.day}/0${date.month}/${date.year}';
                                    dateOfBirth.text =
                                        '0${date.day}/0${date.month}/${date.year}';
                                    dateParseFun(personalDetailObj.dob!);
                                    if (date != null)
                                      personalDetailObj.age =
                                          ageCalculator(date.year);
                                    // print(
                                    //     'personalDetailObj age : ${personalDetailObj.age}');
                                  } else if ((date.month) < 10) {
                                    personalDetailObj.dob =
                                        '${date.day}/0${date.month}/${date.year}';
                                    dateOfBirth.text =
                                        '${date.day}/0${date.month}/${date.year}';
                                    dateParseFun(personalDetailObj.dob!);
                                    if (date != null)
                                      personalDetailObj.age =
                                          ageCalculator(date.year);
                                    // print(
                                    //     'personalDetailObj age : ${personalDetailObj.age}');
                                  } else if ((date.day) < 10) {
                                    personalDetailObj.dob =
                                        '0${date.day}/${date.month}/${date.year}';
                                    dateOfBirth.text =
                                        '0${date.day}/${date.month}/${date.year}';
                                    dateParseFun(personalDetailObj.dob!);
                                    if (date != null)
                                      personalDetailObj.age =
                                          ageCalculator(date.year);
                                    // print(
                                    //     'personalDetailObj age : ${personalDetailObj.age}');
                                  } else {
                                    dateOfBirth.text =
                                        '${date.day}/${date.month}/${date.year}';
                                    personalDetailObj.dob =
                                        '${date.day}/${date.month}/${date.year}';
                                    dateParseFun(personalDetailObj.dob!);
                                    setState(() {
                                      if (date != null)
                                        personalDetailObj.age =
                                            ageCalculator(date.year);
                                      // print(
                                      //     'personalDetailObj age : ${personalDetailObj.age}');
                                    });
                                  }
                                  //  print(personalDetailObj.dob);
                                });
                              }
                              if (personalDetailObj.dobFormat == "MM") {
                                //  print(personalDetailObj.dobFormat);
                                showMonthPicker(
                                  context: context,
                                  firstDate: DateTime(
                                      DateTime.now().year - dobFirstDate,
                                      DateTime.now().month,
                                      DateTime.now().day),
                                  lastDate: DateTime.now(),
                                  initialDate: DateTime.now(),
                                  // locale: Locale("es"),
                                ).then((date1) {
                                  if (date1 != null) {
                                    if ((date1.month) < 10) {
                                      personalDetailObj.dob =
                                          '01/0${date1.month}/${date1.year}';

                                      dateOfBirth.text =
                                          '01/0${date1.month}/${date1.year}';

                                      if (date1 != null)
                                        personalDetailObj.age =
                                            ageCalculator(date1.year);
                                      // print(
                                      //     'personalDetailObj age : ${personalDetailObj.age}');
                                    } else {
                                      personalDetailObj.dob =
                                          '01/${date1.month}/${date1.year}';

                                      dateOfBirth.text =
                                          '01/${date1.month}/${date1.year}';

                                      if (date1 != null)
                                        personalDetailObj.age =
                                            ageCalculator(date1.year);
                                      // print(
                                      //     'personalDetailObj age : ${personalDetailObj.age}');
                                    }
                                  }
                                });
                              }
                              if (personalDetailObj.dobFormat == "YY") {
                                //     print(personalDetailObj.dobFormat);

                                showDialog<int>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return new NumberPicker(
                                        value: personalDetailObj.age,
                                        minValue:
                                            DateTime.now().year - dobFirstDate,
                                        maxValue: DateTime.now().year,
                                        onChanged: (value) {
                                          setState(() {
                                            personalDetailObj.dob =
                                                '01/01/$value';
                                            personalDetailObj.age =
                                                curryear - value;
                                            dateOfBirth.text = '01/01/$value';
                                            // print(personalDetailObj.dob);
                                          });
                                        },
                                        // title:
                                        //     new Text("Pick your year of birth"),
                                        // initialIntegerValue: 1950,
                                      );
                                    });
                              }
                              if (personalDetailObj.dobFormat == "XX") {
                                curryear = currDt.year;

                                //   print(currDt.year);
                                showDialog<int>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return new NumberPicker(
                                        minValue: 1,
                                        value: age,
                                        maxValue: dobFirstDate,
                                        onChanged: (value) {
                                          age = value;
                                          birthYear = curryear - age;
                                          personalDetailObj.age = age;
                                          personalDetailObj.dob =
                                              '01/01/$birthYear';

                                          dateOfBirth.text = '01/01/$birthYear';
                                        },

                                        // title: new Text("Pick your age"),
                                        // initialIntegerValue: 20,
                                      );
                                    });
                              }
                            },
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: CONTENTPADDING),
                              prefixIcon: Icon(Icons.calendar_today_outlined,
                                  color: blue),
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 16,
                                  letterSpacing: 1),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: BORDERWIDTH, color: blue),
                                  borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: BORDERWIDTH, color: blue),
                                  borderRadius: BorderRadius.circular(10.0)),
                              // labelText: 'Date of birth',
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
                        padding: const EdgeInsets.only(left: FIELDPADDING),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Special Category *',
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
                        // ignore: missing_required_param
                        child: TypeAheadFormField(
                          getImmediateSuggestions: false,
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: CONTENTPADDING),
                              prefixIcon:
                                  Icon(FontAwesomeIcons.calendar, color: blue),
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
                                  icon: (splCategory != null)
                                      ? Icon(Icons.remove_circle)
                                      : Icon(Icons.search),
                                  onPressed: () {
                                    setState(() {
                                      splCategory = null;
                                      _splCategoryController.clear();
                                    });
                                  }),
                              //  contentPadding: EdgeInsets.all(10),
                              //   labelText: "Special Category",
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(10.0)),
                            ),
                            controller: _splCategoryController,
                          ),

                          //   attribute: 'splCategory',

                          // selectionToTextTransformer:
                          //     (SplCategoryModel splCategoryModel) {
                          //   return splCategoryModel.splcategoryDesc;
                          // },
                          // initialValue: new SplCategoryModel(),
                          itemBuilder: (context, splCategoryModel) {
                            return ListTile(
                              title: Text(
                                splCategoryModel.splcategoryDesc!,
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
                                if (personalDetailObj.splcategory == null ||
                                    personalDetailObj.splcategory == "") {
                                  return "Select from suggestions only";
                                }
                                return null;
                              }
                            ],
                          ),
                          suggestionsCallback: (query) {
                            if (query.isNotEmpty) {
                              var lowercaseQuery = query.toLowerCase();
                              return splCategoryList.where((splCat) {
                                return splCat.splcategoryDesc!
                                    .toLowerCase()
                                    .contains(query.toLowerCase());
                              }).toList(growable: false)
                                ..sort((a, b) => a.splcategoryDesc!
                                    .toLowerCase()
                                    .indexOf(lowercaseQuery)
                                    .compareTo(b.splcategoryDesc!
                                        .toLowerCase()
                                        .indexOf(lowercaseQuery)));
                            } else {
                              return splCategoryList
                                ..sort((a, b) => a.splcategoryDesc!
                                    .toLowerCase()
                                    .compareTo(
                                        b.splcategoryDesc!.toLowerCase()));
                            }
                          },
                          onSuggestionSelected: (SplCategoryModel suggestion) {
                            personalDetailObj.splcategory =
                                suggestion.splcategoryCode;
                            splCategory = suggestion.splcategoryCode;
                            _splCategoryController.text =
                                suggestion.splcategoryDesc!;
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
                              'Nationality *',
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
                          // enabled: isPptNatEditable,
                          hideKeyboard: isPptNatNonEditable,
                          getImmediateSuggestions: false,
                          textFieldConfiguration: TextFieldConfiguration(
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
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 16,
                                  letterSpacing: 1),
                              //   contentPadding: EdgeInsets.all(15.0),
                              suffixIcon: IconButton(
                                  icon: (nationality != null)
                                      ? Icon(Icons.remove_circle)
                                      : Icon(Icons.search),
                                  onPressed: () {
                                    setState(() {
                                      nationality = null;
                                      _nationalityController.clear();
                                    });
                                  }),
                              //  contentPadding: EdgeInsets.all(10),
                              //  labelText: 'Nationality',
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(10.0)),
                            ),
                            controller: _nationalityController,
                          ),

                          // //  attribute: 'nationality',
                          // onSaved: (newVal) async {
                          //   FocusScope.of(context).requestFocus(FocusNode());

                          //   setState(() {
                          //     personalDetailObj.nationality = newVal;
                          //     nationality = newVal;
                          //     // tempIdGeneration.nationality = newVal.countrycode;
                          //     //  _controller.text = country;

                          //     //  print(newVal.countrycode);
                          //     // final index = country.indexWhere(
                          //     //     (element) => element['country_name'] == newVal);
                          //     // print(-index);

                          //     // print(
                          //     //     'Using indexWhere: ${country[-index]['country_code']}');
                          //   });
                          // },
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
                                if (personalDetailObj.nationality == null ||
                                    personalDetailObj.nationality == "") {
                                  return "Select from suggestions only";
                                }
                                return null;
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
                            _nationalityController.text =
                                suggestion.countryname!;
                            nationality = suggestion.countrycode;
                            personalDetailObj.nationality =
                                suggestion.countrycode;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Address in country where residing permanently',
                            style: TextStyle(
                              color: blue,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: FIELDPADDING),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Address ',
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
                            initialValue: personalDetailObj.addressOutsideIndia,
                            name: "addressOutsideIndia",
                            maxLines: 1,
                            maxLength: MAX_LENGTH_ADDRESS,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(alphaNumSpaceSpecial))
                            ],
                            onChanged: (field) {
                              personalDetailObj.addressOutsideIndia =
                                  field!.toUpperCase();
                              //   FocusScope.of(context).nextFocus();
                            },
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: CONTENTPADDING),
                              prefixIcon:
                                  Icon(Icons.location_city, color: blue),
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
                              // labelText:
                              //     'Address *',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 16,
                                  letterSpacing: 1),
                            ),
                            validator: FormBuilderValidators.compose(
                              [
                                // FormBuilderValidators.required(
                                //   errorText: 'Required',
                                // ),
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
                              'City ',
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
                            initialValue: personalDetailObj.cityOutsideIndia,
                            name: "cityOutsideIndia",
                            maxLines: 1,
                            maxLength: MAX_LENGTH_TEXTFIELD,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(alphabetsSpaceDot))
                            ],
                            onChanged: (field) {
                              personalDetailObj.cityOutsideIndia =
                                  field!.toUpperCase();
                            },
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: CONTENTPADDING),
                              prefixIcon:
                                  Icon(Icons.location_on_outlined, color: blue),
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
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(10.0)),
                              // labelText: 'City *',
                            ),
                          ),
                        ),
                      ),
                    ])))));
  }

  //move to applicant details form
}
