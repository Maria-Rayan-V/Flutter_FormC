import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formc_showcase/screens/Edit_FormC_application/temporaryAppl_list.dart';
import 'package:formc_showcase/screens/formC_wizard.dart';
import 'package:formc_showcase/models/masters/countryModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:formc_showcase/services/formC_commonServices.dart';
import 'package:formc_showcase/util/validations.dart';
import 'package:formc_showcase/constants/formC_constants.dart';

class PendingApplicationSearch extends StatefulWidget {
  // const PendingApplicationSearch({ Key? key }) : super(key: key);

  @override
  _PendingApplicationSearchState createState() =>
      _PendingApplicationSearchState();
}

class _PendingApplicationSearchState extends State<PendingApplicationSearch> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  var passportNumber, nationality, searchDetails;
  FormCWizardMenuItem? stepsWizard;
  List<CountryModel> countryList = [];
  TextEditingController _nationalityController = new TextEditingController();
  Future processPartialData(
      String passportNumber, String nationality, BuildContext context) async {
    EasyLoading.show(status: 'Please Wait...');

    // print('inside partial data');

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TemporaryFormCApplications.throughSearch(
              passportNumber, nationality)),
    );

    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();

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
        //  resizeToAvoidBottomPadding: false,
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
        body: SingleChildScrollView(
          child: FormBuilder(
            key: _fbKey,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(' Search Pending Details ',
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
                        'Passport Number ',
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
                      // validators: [
                      //   FormBuilderValidators.required(
                      //     errorText: 'Required',
                      //   ),
                      // ],
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
                          FontAwesomeIcons.addressCard,
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
                        'Country Outside India ',
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
                    getImmediateSuggestions: false,
                    textFieldConfiguration: TextFieldConfiguration(
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
                      nationality = suggestion.countrycode;
                      _nationalityController.text = suggestion.countryname!;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
                ButtonTheme(
                  minWidth: RAISEDBUTTON_WIDTH,
                  height: RAISEDBUTTON_HEIGHT,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blue,
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
                        //    print('true');
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  actions: [
                                    ElevatedButton(
                                      child: new Text('Ok',
                                          style: TextStyle(color: blue)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                  title:
                                      Text(" Please check the error message "),
                                ));
                      }
                    },
                  ),
                ),
                // ButtonTheme(
                //    minWidth: RAISEDBUTTON_WIDTH,
                //   height: RAISEDBUTTON_HEIGHT,
                //                 child: RaisedButton(onPressed: ()
                //   {

                //   }

                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
