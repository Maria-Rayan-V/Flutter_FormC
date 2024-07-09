import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formc_showcase/models/Registration/AccoProfileModel.dart';
import 'package:formc_showcase/models/masters/AccogradeModel.dart';
import 'package:formc_showcase/screens/splashScreen.dart';
import 'package:intl/intl.dart';
import '../../constants/formC_constants.dart';
import '../../models/masters/accotypeModel.dart';
import '../../models/masters/countryModel.dart';
import '../../models/masters/districtModel.dart';
import '../../models/masters/frroModel.dart';
import '../../models/masters/stateModel.dart';
import '../../services/formC_commonServices.dart';
import '../../util/httpUtil.dart';
import '../../util/validations.dart';
import '../regn_wizard.dart';

class HotelInfo extends StatefulWidget {
  AccomodatorModel? data = AccomodatorModel();
  HotelInfo({Key? key, @required this.data}) : super(key: key);
  @override
  State<HotelInfo> createState() => _HotelInfoState();
}

class _HotelInfoState extends State<HotelInfo> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController _nationalityController = new TextEditingController();
  TextEditingController _accoState = new TextEditingController();
  TextEditingController _accoType = new TextEditingController();
  TextEditingController _accoGrade = new TextEditingController();
  var nationality;
  AccomodatorModel accodataObj = AccomodatorModel();
  AccomodatorModel? existingAccoDts = AccomodatorModel();
  bool buttonEnabled = true;
  List<CountryModel> countryList = [];
  bool dobFromOnchanged = false;
  List<StateModel> stateList = [];
  List<StateModel> editStateList = [];
  List<AccoGradeModel> accogradeList = [];
  List<AccotypeModel> accotypeList = [];
  List<AccoGradeModel> editAccogradeList = [];
  List<AccotypeModel> editAccotypeList = [];
  List<DistrictModel> distInIndList = [];
  List<FrroModel> frroList = [];
  RegnWizard? stepsWizard;
  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      existingAccoDts = widget.data;
      print('existing acco in 2nd ${existingAccoDts!.ownerDetails!}');
      accodataObj.accomName = existingAccoDts!.accomName;
      accodataObj.accomCapacity = existingAccoDts!.accomCapacity;
      accodataObj.accomAddress = existingAccoDts!.accomAddress;
      accodataObj.accomState = existingAccoDts!.accomState;
      accodataObj.accomCityDist = existingAccoDts!.accomCityDist;
      if (accodataObj.accomState != null) {
        FormCCommonServices.getSpecificState(accodataObj.accomState!)
            .then((result) {
          editStateList = result;
          //print('Single state:$editStateList');
          if (editStateList != null && editStateList.length > 0) {
            _accoState.text = editStateList[0].statename!;
            accodataObj.accomState = editStateList[0].statecode;
          }
        });
        FormCCommonServices.getDistrict(accodataObj.accomState!).then((result) {
          setState(() {
            distInIndList = result;
            //print('distInInd :$distInIndList');
          });
        });

        FormCCommonServices.getFrro(
                accodataObj.accomState!, accodataObj.accomCityDist!)
            .then((result) {
          print('Frro list $result');
          setState(() {
            frroList = result;
          });
        });
      }
      accodataObj.accomCityDist = existingAccoDts!.accomCityDist;
      accodataObj.frroTypeCode = existingAccoDts!.frroTypeCode;
      accodataObj.accomodationType = existingAccoDts!.accomodationType;
      if (accodataObj.accomodationType != null) {
        FormCCommonServices.getAccotype().then((result) {
          accotypeList = result;
          ////print('state $stateList');
        });
      }
      accodataObj.accomodationGrade = existingAccoDts!.accomodationGrade;
      if (accodataObj.accomodationGrade != null) {
        FormCCommonServices.getAccoGrade().then((result) {
          accogradeList = result;
          ////print('state $stateList');
        });
      }
      accodataObj.accomMobile = existingAccoDts!.accomMobile;
      accodataObj.accomPhoneNum = existingAccoDts!.accomPhoneNum;
      accodataObj.accomEmail = existingAccoDts!.accomEmail;
    }
    setState(() {
      //  page1 = widget.data;
      stepsWizard = new RegnWizard(currentPageNo: "2");
    });
    FormCCommonServices.getCountry().then((result) {
      countryList = result;
    });
    FormCCommonServices.getAccotype().then((result) {
      accotypeList = result;
      ////print('state $stateList');
    });
    FormCCommonServices.getState().then((result) {
      stateList = result;
      ////print('state $stateList');
    });
    FormCCommonServices.getAccoGrade().then((result) {
      accogradeList = result;
      ////print('state $stateList');
    });
  }

  back() {
    //print('Previous Page: P0');
    Navigator.pop(context);
  }

  next() {
    // stepsWizard.createState().moveToRegnScreen("3", context, accodataObj);
    if (_fbKey.currentState!.saveAndValidate()) {
      stepsWizard!
          .createState()
          .moveToRegnScreen("3", context, existingAccoDts);
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
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Name *',
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
                        initialValue: accodataObj.accomName,
                        //name: "Name",
                        maxLines: 1,
                        maxLength: MAX_LENGTH_TEXTFIELD,
                        onChanged: (field) {
                          //print('inside username onchanges');
                          accodataObj.accomName = field;
                          //print('Name ${accodataObj.accomName}');
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
                        name: 'name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Capacity *',
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
                          FilteringTextInputFormatter.allow(RegExp(numbers))
                        ],
                        initialValue: accodataObj.accomCapacity,
                        //name: "Name",
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        maxLength: 3,
                        onChanged: (field) {
                          //print('inside username onchanges');
                          accodataObj.accomCapacity = field;
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
                        name: 'capacity',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Address *',
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
                        initialValue: accodataObj.accomAddress,
                        cursorColor: blue,
                        name: "addressOutsideIndia",
                        maxLines: 1,
                        maxLength: MAX_LENGTH_ADDRESS,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(alphaNumSpaceSpecial))
                        ],
                        onChanged: (field) {
                          accodataObj.accomAddress = field;
                          //   FocusScope.of(context).nextFocus();
                        },
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: CONTENTPADDING),
                          prefixIcon: Icon(Icons.location_city, color: blue),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: blue),
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
                            FormBuilderValidators.required(
                              errorText: 'Required',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'State *',
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
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            errorText: 'Required',
                          ),
                        ],
                      ),
                      getImmediateSuggestions: false,
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _accoState,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: CONTENTPADDING),
                          prefixIcon:
                              Icon(Icons.location_city_rounded, color: blue),
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
                              icon: (accodataObj.accomState != null)
                                  ? Icon(Icons.remove_circle)
                                  : Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  //    page1.froState = null;
                                  accodataObj.accomState = null;
                                });
                              }),
                          // contentPadding: EdgeInsets.all(10),
                          //    labelText: 'Next Destination State',
                          // border: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),

                      //cursorColor: blue,
                      // name: 'nextDestStateInInd',

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
                          accodataObj.accomCityDist = null;

                          accodataObj.accomState = suggestion.statecode;
                          _accoState.text = suggestion.statename!;
                          FormCCommonServices.getDistrict(
                                  accodataObj.accomState!)
                              .then((result) {
                            setState(() {
                              distInIndList = result;
                            });
                          });
                          //  _controller.text = country;

                          //  ////print(newVal.countrycode);
                          // final index = country.indexWhere(
                          //     (element) => element['country_name'] == newVal);
                          // ////print(-index);

                          // ////print(
                          //     'Using indexWhere: ${country[-index]['country_code']}');
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'City *',
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
                    child: FormBuilderDropdown(
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            errorText: 'Required',
                          ),
                        ],
                      ),
                      initialValue: accodataObj.accomCityDist,

                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(Icons.location_city, color: blue),
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
                        // labelText: 'District',
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
                        accodataObj.accomCityDist = value;
                        accodataObj.frroTypeCode = null;
                        FormCCommonServices.getFrro(accodataObj.accomState!,
                                accodataObj.accomCityDist!)
                            .then((result) {
                          setState(() {
                            frroList = result;
                          });
                        });
                        FocusScope.of(context).requestFocus(FocusNode());
                        //     tempIdGeneration.gender = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Frro/Fro Description *',
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
                    child: FormBuilderDropdown(
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            errorText: 'Required',
                          ),
                        ],
                      ),
                      initialValue: accodataObj.frroTypeCode,

                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(Icons.location_city, color: blue),
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
                        // labelText: 'Frro/Fro',
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(12),
                        //     borderSide: BorderSide(color: Colors.red)),
                      ),
                      // initialValue: 'Male',
                      // allowClear: true,

                      //   hint: Text('Select Gender'),

                      items: frroList
                          .map((frro) => DropdownMenuItem(
                                child: new Text(frro.frroFroDesc!),
                                value: frro.frroFroCode.toString(),
                              ))
                          .toList(),

                      name: 'frrodesc',
                      onChanged: (value) {
                        accodataObj.frroTypeCode = value;

                        FocusScope.of(context).requestFocus(FocusNode());
                        //     tempIdGeneration.gender = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Accomodation Type *',
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
                    child: FormBuilderDropdown(
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            errorText: 'Required',
                          ),
                        ],
                      ),
                      initialValue: accodataObj.accomodationType,

                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(Icons.location_city, color: blue),
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
                        // labelText: 'Accomodationtype',
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(12),
                        //     borderSide: BorderSide(color: Colors.red)),
                      ),
                      // initialValue: 'Male',
                      // allowClear: true,

                      //   hint: Text('Select Gender'),

                      items: accotypeList
                          .map((accotype) => DropdownMenuItem(
                                child: new Text(accotype.accTypeName!),
                                value: accotype.accTypeCode.toString(),
                              ))
                          .toList(),

                      name: 'accotype',
                      onChanged: (value) {
                        accodataObj.accomodationType = value;

                        FocusScope.of(context).requestFocus(FocusNode());
                        //     tempIdGeneration.gender = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Accomodation Grade *',
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
                    child: FormBuilderDropdown(
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            errorText: 'Required',
                          ),
                        ],
                      ),
                      initialValue: accodataObj.accomodationGrade,

                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(Icons.location_city, color: blue),
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
                        // labelText: 'Accomodation Grade',
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(12),
                        //     borderSide: BorderSide(color: Colors.red)),
                      ),
                      // initialValue: 'Male',
                      // allowClear: true,

                      //   hint: Text('Select Gender'),

                      items: accogradeList
                          .map((district) => DropdownMenuItem(
                                child: new Text(district.accoGradeDesc!),
                                value: district.accoGrade.toString(),
                              ))
                          .toList(),

                      name: 'accograde',
                      onChanged: (value) {
                        accodataObj.accomodationGrade = value;

                        FocusScope.of(context).requestFocus(FocusNode());
                        //     tempIdGeneration.gender = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Mobile Number *',
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
                      initialValue: accodataObj.accomMobile,
                      keyboardType: TextInputType.number,
                      maxLength: 15,
                      onChanged: (value) {
                        accodataObj.accomMobile = value;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(phnNumbers))
                      ],
                      cursorColor: blue,
                      name: "mblNum",
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: CONTENTPADDING),
                        prefixIcon: Icon(FontAwesomeIcons.mobile, color: blue),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: blue),
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: blue),
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
                          FormBuilderValidators.required(
                            errorText: 'Required',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
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
                      initialValue: accodataObj.accomPhoneNum,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        accodataObj.accomPhoneNum = value;
                      },
                      maxLength: 15,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(phnNumbers))
                      ],
                      cursorColor: blue,
                      name: "phnNumInInd",
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
                          FormBuilderValidators.required(
                            errorText: 'Required',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Email Id *',
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
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(RegExp(alphabetSpace))
                        // ],
                        initialValue: accodataObj.accomEmail,
                        //name: "Name",
                        maxLines: 1,
                        maxLength: MAX_LENGTH_TEXTFIELD,
                        onChanged: (field) {
                          //print('inside username onchanges');
                          accodataObj.accomEmail = field;
                          //print('Name ${accodataObj.accomName}');
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
                        name: 'name',
                      ),
                    ),
                  ),
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
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(10)),
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
