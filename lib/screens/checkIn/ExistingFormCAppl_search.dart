import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/models/masters/countryModel.dart';
import 'package:formc_showcase/screens/checkIn/scanQrCode.dart';
import 'package:formc_showcase/services/formC_commonServices.dart';
import 'package:formc_showcase/util/validations.dart';
import 'dart:async';
import 'package:formc_showcase/util/utility.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:formc_showcase/screens/checkIn/form1_applicationGeneration.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:formc_showcase/services/formC_commonServices.dart';
import 'package:formc_showcase/util/spUtil.dart';
import 'package:formc_showcase/screens/formC_wizard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:formc_showcase/Widgets/sideDrawer.dart';

class CheckInSearch extends StatefulWidget {
//  const CheckInSearch({ Key? key }) : super(key: key);

  @override
  _CheckInSearchState createState() => _CheckInSearchState();
}

class _CheckInSearchState extends State<CheckInSearch> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  var passportNumber, nationality, searchDetails;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FormCWizardMenuItem? stepsWizard;
  List<CountryModel> countryList = [];
  bool isPendingApplication = false;
  TextEditingController _nationalityController = new TextEditingController();
  Future processPartialData(
      String passportNumber, String nationality, BuildContext context) async {
    EasyLoading.show(status: 'Please Wait...');
    (passportNumber != null && passportNumber != "")
        ? await HttpUtils().saveExistingFormCPptNo(passportNumber)
        : await HttpUtils().saveExistingFormCPptNo(null);
    (nationality != null && nationality != "")
        ? await HttpUtils().saveExistingFormCNationality(nationality)
        : await HttpUtils().saveExistingFormCNationality(null);
    //print('inside partial data');

    FormCCommonServices.getApplicantDetailByPassportNo(
            passportNumber, nationality)
        .then((value) {
      // print('value $passportNumber $nationality $value');
      // //print('givenname ${value[0].surname}');
      if (value.isEmpty) {
        Utility.displaySnackBar(_scaffoldKey, 'No existing FormC found');
      }
      SpUtil.putBool('isDataFromQR', false);
      Timer(Duration(milliseconds: 600), () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ApplicationGeneration(data: value)),
        );
      });

      EasyLoading.dismiss();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isPendingApplication = false;
    SpUtil.putBool('isPendingApplication', isPendingApplication);
    FormCCommonServices.getCountry().then((value) {
      setState(() {
        countryList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        //  resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0), // here the desired height
          child: AppBar(
            backgroundColor: blue,
            // leading: IconButton(
            //   icon: Icon(Icons.menu, size: 40), // change this size and style
            //   onPressed: () => _scaffoldKey.currentState.openDrawer(),
            // ),
            leading: IconButton(
              icon: Icon(FontAwesomeIcons.qrcode),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanQrClass()),
                );
              },
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
        drawer: FormCSideDrawer(),
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
                  height: size.height * 0.1,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Passport Number *',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16,
                          //letterSpacing: 1
                        ),
                      )),
                ),
                SizedBox(
                  height: size.height * 0.006,
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    child: FormBuilderTextField(
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            errorText: 'Required',
                          ),
                        ],
                      ),
                      initialValue: passportNumber,
                      name: "passportNo",
                      maxLines: 1,
                      maxLength: MAX_LENGTH_PASSPORT_VISA,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(alphaNumeric))
                      ],
                      onChanged: (field) {
                        passportNumber = field!.toUpperCase();
                      },
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        //   labelText: 'Passport Number',
                        prefixIcon: Icon(
                          FontAwesomeIcons.addressBook,
                          color: blue,
                        ),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Country of permanent residence *',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16,
                          //letterSpacing: 1
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _nationalityController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
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
                            icon: (nationality != null)
                                ? Icon(Icons.remove_circle)
                                : Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                nationality = null;
                                _nationalityController.clear();
                              });
                            }),
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: blue,
                        ),

                        //  contentPadding: EdgeInsets.all(10),
                        //labelText: 'Nationality',
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
                          if (nationality == null || nationality == "") {
                            return "Select from suggestions only";
                          } else {
                            return null;
                          }
                        }
                      ],
                    ),
                    getImmediateSuggestions: false,
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
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                Container(
                  width: 270,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                    ),
                    child: Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_fbKey.currentState!.saveAndValidate()) {
                        processPartialData(
                            passportNumber, nationality, context);
                        //print('true');
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  actions: [
                                    TextButton(
                                      child: new Text('Ok',
                                          style: TextStyle(color: blue)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                  title: Text(
                                      " Please enter the mandatory field "),
                                ));
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.004,
                ),
                // Center(child: Text('OR')),
                // SizedBox(
                //   height: size.height * 0.004,
                // ),
                // ButtonTheme(
                //   minWidth: 270,
                //   height: 40,
                //   child: RaisedButton(
                //     color: blue,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: new BorderRadius.circular(18.0),
                //     ),
                //     child: Text(
                //       'New Form C Entry',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //     onPressed: () async {
                //       await HttpUtils().saveExistingFormCPptNo(null);
                //       await HttpUtils().saveExistingFormCNationality(null);
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) =>
                //                 ApplicationGeneration.freshAppl()),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
