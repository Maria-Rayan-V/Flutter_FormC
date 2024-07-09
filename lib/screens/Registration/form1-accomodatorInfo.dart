import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart ';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formc_showcase/screens/Others/editUserProfile.dart';
import 'package:formc_showcase/screens/regn_wizard.dart';
import 'package:formc_showcase/util/spUtil.dart';
import 'package:intl/intl.dart';
import '../../constants/formC_constants.dart';
import '../../models/Registration/AccoProfileModel.dart';
import '../../models/Registration/UpdateProfile.dart';
import '../../models/Registration/editUsrProfModel.dart';
import '../../models/masters/countryModel.dart';
import '../../services/formC_commonServices.dart';
import '../../services/globals.dart';
import '../../util/httpUtil.dart';
import '../../util/validations.dart';
import 'package:http/http.dart' as http;

import '../splashScreen.dart';

class AccomodatorInformation extends StatefulWidget {
  // const AccomodatorInformation({Key key}) : super(key: key);
  AccomodatorModel? data = AccomodatorModel();
  AccomodatorInformation({Key? key, @required this.data}) : super(key: key);
  @override
  State<AccomodatorInformation> createState() => _AccomodatorInformationState();
}

class _AccomodatorInformationState extends State<AccomodatorInformation> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController _nationalityController = new TextEditingController();
  AccomodatorModel? existingAccoDts = AccomodatorModel();
  EditUsrProfileModel usrProfObj = EditUsrProfileModel();
  var nationality;
  UpdateProfile updateUsrObj = UpdateProfile();
  bool buttonEnabled = true;
  List<CountryModel> countryList = [];
  List<CountryModel> editCountryList = [];
  bool dobFromOnchanged = false;
  RegnWizard? stepsWizard;
  var isRegAppFinalSubmit;
  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      // hotelAndOwnerDetails = widget.data;
      isRegAppFinalSubmit = SpUtil.getString('isRegAppFinalSubmit');
      print('Is Reg App Final Submit $isRegAppFinalSubmit');
      existingAccoDts = widget.data;
      updateUsrObj.gender = existingAccoDts!.gender;
      updateUsrObj.dob = dateParseFormatter(existingAccoDts!.dob);
      updateUsrObj.phoneNo = existingAccoDts!.phoneNo;
      updateUsrObj.nationality = existingAccoDts!.nationality;
      updateUsrObj.designation = existingAccoDts!.designation;
      _nationalityController.text = existingAccoDts!.nationality!;
      if (updateUsrObj.nationality != null) {
        FormCCommonServices.getSpecificCountry(updateUsrObj.nationality!)
            .then((result) {
          editCountryList = result;
          if (editCountryList != null && editCountryList.length > 0) {
            _nationalityController.text = editCountryList[0].countryname!;
            updateUsrObj.nationality = editCountryList[0].countrycode;
          }
        });
      }
      print('Existing Acco details ${existingAccoDts!.ownerDetails}');
    }
    setState(() {
      //  page1 = widget.data;
      stepsWizard = new RegnWizard(currentPageNo: "1");
    });
    FormCCommonServices.getCountry().then((result) {
      countryList = result;
    });
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

  submitUserDetails() async {
    EasyLoading.show(status: 'Please Wait...');
    var token = await HttpUtils().getToken();
    //print('token: $token');
    updateUsrObj.userid = await HttpUtils().getUsername();
    try {
      var data = json.encode({
        "userid": updateUsrObj.userid,
        "gender": updateUsrObj.gender,
        "dob": updateUsrObj.dob,
        "designation": updateUsrObj.designation,
        "phoneNo": updateUsrObj.phoneNo,
        "nationality": updateUsrObj.nationality
      });
      // print('Inside Gen app id $data');
      //print(GENERATE_APPLID);
      await http.post(
        Uri.parse(POST_USR_PROF),
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

        // //print(chkuser);
        if (response.statusCode == 200) {
          stepsWizard!
              .createState()
              .moveToRegnScreen("2", context, existingAccoDts);

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

  next() {
    // stepsWizard.createState().moveToRegnScreen("2", context);
    if (_fbKey.currentState!.saveAndValidate()) {
      if (isRegAppFinalSubmit == 'Y') {
        final SnackBar snackBar = SnackBar(
            content: Text("Application already submitted for approval"));
        snackbarKey.currentState?.showSnackBar(snackBar);
        stepsWizard!
            .createState()
            .moveToRegnScreen("2", context, existingAccoDts);
      } else {
        submitUserDetails();
      }
      // stepsWizard.createState().moveToRegnScreen("2", context);
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
                    padding: const EdgeInsets.only(left: LABELPADDING),
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
                    padding: const EdgeInsets.only(
                        left: LABELPADDING,
                        right: LABELPADDING,
                        top: TOPPADDING),
                    child: TypeAheadFormField(
                      // enabled: isPptNatEditable,
                      // hideKeyboard: isPptNatNonEditable,
                      getImmediateSuggestions: false,
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: CONTENTPADDING),
                          prefixIcon: Icon(Icons.location_on, color: blue),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: blue),
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
                            if (updateUsrObj.nationality == null ||
                                updateUsrObj.nationality == "") {
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
                        _nationalityController.text = suggestion.countryname!;
                        nationality = suggestion.countrycode;
                        updateUsrObj.nationality = suggestion.countrycode;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                      initialValue: updateUsrObj.gender,
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
                            borderSide: BorderSide(width: 2, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: blue),
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
                        updateUsrObj.gender = value;
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
                    padding: const EdgeInsets.only(
                        left: LABELPADDING,
                        right: LABELPADDING,
                        top: TOPPADDING),
                    child: FormBuilderDateTimePicker(
                      firstDate: DateTime(DateTime.now().year - 100,
                          DateTime.now().month, DateTime.now().day),
                      lastDate: DateTime.now(),
                      name: "dob",
                      onChanged: (val) {
                        setState(() {
                          dobFromOnchanged = true;
                        });
                        if (val != null)
                          updateUsrObj.dob =
                              DateFormat("dd/MM/yyyy").format(val);
                      },
                      initialValue: (updateUsrObj.dob != null)
                          ? (DateFormat("dd/MM/yyyy").parse(updateUsrObj.dob!))
                          : null,
                      valueTransformer: (value) => (value != null)
                          ? DateFormat("dd/MM/yyyy").format(value)
                          : null,
                      inputType: InputType.date,
                      format: DateFormat("dd/MM/yyyy"),
                      //  readOnly:  page1.dateOfBirth !=null ? true : false ,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon:
                            Icon(FontAwesomeIcons.calendar, color: blue),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      validator: FormBuilderValidators.compose(
                        [
                          // ignore: missing_return
                          (val) {
                            if ((val == null || val == "")) {
                              return 'Required';
                            } else {
                              return null;
                            }
                          }
                        ],
                      ),
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
                          'Designation *',
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
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(alphabetSpace))
                        ],
                        initialValue: updateUsrObj.designation,
                        //name: "Name",
                        maxLines: 1,
                        maxLength: MAX_LENGTH_TEXTFIELD,
                        onChanged: (field) {
                          //print('inside username onchanges');
                          updateUsrObj.designation = field;
                          //print('Name ${updateUsrObj.accomName}');
                        },
                        //       textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10.0),
                          prefixIcon: Icon(Icons.person, color: blue),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          // labelText: 'Username',
                          // hintText: 'Username',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        ),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                              errorText: 'Required',
                            ),
                          ],
                        ),
                        cursorColor: blue,
                        name: 'design',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: LABELPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Phone Number *',
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
                    child: FormBuilderTextField(
                      initialValue: updateUsrObj.phoneNo,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        updateUsrObj.phoneNo = value;
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
                            borderSide: BorderSide(width: 2, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: blue),
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
                          if (updateUsrObj.phoneNo == null ||
                              updateUsrObj.phoneNo == "")
                            FormBuilderValidators.required(
                                errorText: 'Required')
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: blue,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // TextButton(
                //   padding: EdgeInsets.all(10.0),
                //   onPressed: back,
                //   child: Row(
                //     children: <Widget>[
                //       Icon(Icons.arrow_back_ios, color: Colors.white),
                //       Text("Prev",
                //           style: TextStyle(color: Colors.white, fontSize: 18)),
                //     ],
                //   ),
                // ),
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
