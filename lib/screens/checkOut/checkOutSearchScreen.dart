import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/models/masters/countryModel.dart';
import 'package:formc_showcase/services/formC_commonServices.dart';
import 'package:formc_showcase/util/validations.dart';
import 'package:intl/intl.dart';
import 'package:formc_showcase/screens/checkOut/checkOutList.dart';

class CheckOutSearchScreen extends StatefulWidget {
  // const CheckOutSearchScreen({ Key? key }) : super(key: key);

  @override
  _CheckOutSearchScreenState createState() => _CheckOutSearchScreenState();
}

class _CheckOutSearchScreenState extends State<CheckOutSearchScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<CountryModel> countryList = [];
  String? applId, passportNumber, visaNumber, nationality;
  var dateOfArrival;
  TextEditingController _nationalityController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    FormCCommonServices.getCountry().then((result) {
      countryList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          ),
        ),
        body: SingleChildScrollView(
          child: FormBuilder(
            key: _fbKey,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(' Search Checkout Details ',
                      style: TextStyle(
                          //   decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: blue)),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: FIELDPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Application Id',
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
                        initialValue: applId,
                        name: "applicationId",
                        maxLines: 1,
                        maxLength: 50,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(alphaNumeric))
                        ],
                        onChanged: (field) {
                          applId = field!.toUpperCase();
                        },
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: CONTENTPADDING),
                          prefixIcon:
                              Icon(FontAwesomeIcons.idBadge, color: blue),
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
                          //    labelText: 'Application Id',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        ),
                        // validators: [
                        //   FormBuilderValidators.required(
                        //     errorText: 'Required',
                        //   ),
                        // ],
                      ),
                    ),
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
                        initialValue: passportNumber,
                        name: "passportNumber",
                        maxLines: 1,
                        maxLength: 20,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(alphaNumeric))
                        ],
                        onChanged: (field) {
                          passportNumber = field!.toUpperCase();
                        },
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: CONTENTPADDING),
                          prefixIcon:
                              Icon(FontAwesomeIcons.idCard, color: blue),
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
                          //  labelText: 'Passport Number',
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: FIELDPADDING),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Visa Number ',
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
                        initialValue: visaNumber,
                        name: "visaNumber",
                        maxLines: 1,
                        maxLength: 20,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(alphaNumeric))
                        ],
                        onChanged: (field) {
                          visaNumber = field!.toUpperCase();
                        },
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: CONTENTPADDING),
                          prefixIcon:
                              Icon(FontAwesomeIcons.idCardClip, color: blue),
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
                          //   labelText: 'visa Number',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1),
                        ),
                        // validators: [
                        //   FormBuilderValidators.required(
                        //     errorText: 'Required',
                        //   ),
                        // ],
                      ),
                    ),
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
                      getImmediateSuggestions: false,
                      textFieldConfiguration: TextFieldConfiguration(
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
                          //       labelText: 'Nationality',
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

                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            errorText: 'Required',
                          ),
                          // (value) {
                          //   if (userNationality == null || userNationality == "") {
                          //     return "Hello";
                          //   }
                          //   return null;
                          //  }
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
                        nationality = suggestion.countrycode;
                        _nationalityController.text = suggestion.countryname!;
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
                          'Date of arrival in India',
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
                        dateOfArrival = '$val';
                      },
                      // initialValue:
                      //     (DateFormat("dd/MM/yyyy")
                      //         .parse(dateOfArrival)),

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
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: BORDERWIDTH, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        //labelText: 'Date of arrival in India',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: 1),
                        /*   suffixIcon: IconButton(
                        icon: new Icon(Icons.help),
                        tooltip: 'Date of birth as in Passport in DD/MM/YYYY format',
                        onPressed: () {},
                      ),*/
                      ),
                      // validators: [
                      //   FormBuilderValidators.required(
                      //     errorText: 'Required',
                      //   ),
                      //   // ignore: missing_return
                      //   (val) {}
                      // ],
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
                  Center(
                    child: GestureDetector(
                        onTap: () {
                          if (_fbKey.currentState!.saveAndValidate())
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckOutListScreen(
                                      applId,
                                      nationality,
                                      visaNumber,
                                      passportNumber,
                                      _fbKey
                                          .currentState!
                                          .fields['dateOfArrivalInIndia']!
                                          .value)),
                            );
                        },
                        child: Container(
                          height: 40.0,
                          width: 250.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: blue,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Center(
                              child: Text('Search',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15))),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
