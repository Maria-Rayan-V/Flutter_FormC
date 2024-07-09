import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/models/Registration/editUsrProfModel.dart';
import 'package:formc_showcase/util/validations.dart';
import 'package:intl/intl.dart';

import '../../models/masters/countryModel.dart';

class EditUserProdile extends StatefulWidget {
  const EditUserProdile({Key? key}) : super(key: key);

  @override
  State<EditUserProdile> createState() => _EditUserProdileState();
}

class _EditUserProdileState extends State<EditUserProdile> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  EditUsrProfileModel editUsrProfObj = new EditUsrProfileModel();
  TextEditingController _nationalityController = new TextEditingController();
  List<CountryModel> countryList = [];
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
            )),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Center(
              child: Form(
                key: _fbKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'UserId *',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 16,
                                letterSpacing: 1),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        child: FormBuilderTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(alphaNumericSpace))
                          ],
                          initialValue: editUsrProfObj.userid,
                          //attribute: "Name",
                          maxLines: 1,
                          maxLength: MAX_LENGTH_TEXTFIELD,
                          onChanged: (field) {
                            editUsrProfObj.userid = field;
                            //      //print('Name ${enteredCaptcha}');c
                          },
                          //       textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10.0),
                            prefixIcon: Icon(Icons.person, color: blue),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: BORDERWIDTH, color: blue),
                                borderRadius: BorderRadius.circular(10.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: BORDERWIDTH, color: blue),
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
                          name: 'name',
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
                        initialValue: editUsrProfObj.gender,
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
                          editUsrProfObj.gender = value;
                        },
                        name: 'gender',
                      ),
                    ),
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
                      child: FormBuilderDateTimePicker(
                        name: "dob",
                        onChanged: (value) {
                          if (value != null)
                            editUsrProfObj.dob =
                                DateFormat("dd/MM/yyyy").format(value);
                        },
                        initialValue: (editUsrProfObj.dob != null)
                            ? (DateFormat("dd/MM/yyyy")
                                .parse(editUsrProfObj.dob!))
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
                              Icon(FontAwesomeIcons.calendarCheck, color: blue),
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
                              if ((val == null || val == "")) {
                                return 'Required';
                              } else {
                                return null;
                              }
                            }
                          ],
                        ),

                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 100,
                            DateTime.now().month, DateTime.now().day),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
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
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        child: FormBuilderTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(alphaNumericSpace))
                          ],
                          initialValue: editUsrProfObj.designation,
                          //attribute: "Name",
                          maxLines: 1,
                          maxLength: MAX_LENGTH_TEXTFIELD,
                          onChanged: (field) {
                            editUsrProfObj.designation = field;
                            //      //print('Name ${enteredCaptcha}');c
                          },
                          //       textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10.0),
                            prefixIcon: Icon(Icons.person, color: blue),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: BORDERWIDTH, color: blue),
                                borderRadius: BorderRadius.circular(10.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: BORDERWIDTH, color: blue),
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
                          name: 'designation',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: FIELDPADDING),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Phone Number*',
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
                        initialValue: editUsrProfObj.phoneNo,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          editUsrProfObj.phoneNo = value;
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
                            if (editUsrProfObj.phoneNo == null ||
                                editUsrProfObj.phoneNo == "")
                              FormBuilderValidators.required(
                                  errorText: 'Required')
                          ],
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
                        // validators: [
                        //   FormBuilderValidators.required(
                        //     errorText: 'Required',
                        //   ),
                        // ],
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
                            //   contentPadding: EdgeInsets.all(15.0),
                            suffixIcon: IconButton(
                                icon: (editUsrProfObj.nationality != null)
                                    ? Icon(Icons.remove_circle)
                                    : Icon(Icons.search),
                                onPressed: () {
                                  setState(() {
                                    editUsrProfObj.nationality = null;
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
                          controller: _nationalityController,
                        ),

                        // attribute: 'nationality',

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
                          editUsrProfObj.nationality = suggestion.countrycode;
                          _nationalityController.text = suggestion.countryname!;
                        },
                      ),
                    ),
                    //  if (isMailOtpGenerated)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Enter OTP sent in mobile *',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 16,
                                    letterSpacing: 1),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            child: FormBuilderTextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(alphaNumeric))
                              ],
                              initialValue: editUsrProfObj.otp,
                              //attribute: "Name",
                              maxLines: 1, cursorColor: blue,
                              maxLength: 4,
                              onChanged: (field) {
                                editUsrProfObj.otp = field;
                                //      //print('Name ${enteredCaptcha}');
                              },
                              //       textCapitalization: TextCapitalization.characters,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                prefixIcon: Icon(Icons.person, color: blue),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: BORDERWIDTH, color: blue),
                                    borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: BORDERWIDTH, color: blue),
                                    borderRadius: BorderRadius.circular(10.0)),
                                // labelText: 'Username',
                                // hintText: 'emailOtp',
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
                              name: 'emailOtp',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
