import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../constants/formC_constants.dart';
import '../../models/Registration/AccoProfileModel.dart';
import '../../models/masters/countryModel.dart';
import '../../models/masters/districtModel.dart';
import '../../models/masters/stateModel.dart';
import '../../services/formC_commonServices.dart';
import '../../util/httpUtil.dart';
import '../../util/spUtil.dart';
import '../../util/validations.dart';
import '../regn_wizard.dart';
import '../splashScreen.dart';

class OwnerDetails extends StatefulWidget {
  dynamic hotelDetails;
  AccomodatorModel? data = AccomodatorModel();
  OwnerDetails({Key? key, @required this.data, this.hotelDetails})
      : super(key: key);
  @override
  State<OwnerDetails> createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController _nationalityController = new TextEditingController();
  TextEditingController _ownerState = new TextEditingController();
  TextEditingController _ownerCity = new TextEditingController();
  var nationality;
  OwnerDetail multipleOwnerObj = new OwnerDetail();
  AccomodatorModel hotelAndOwnerDetails = new AccomodatorModel();
  AccomodatorModel? existingAccoDts = new AccomodatorModel();
  List<StateModel> stateList = [];
  bool buttonEnabled = true;
  List<DistrictModel> distInIndList = [];
  List<CountryModel> countryList = [];
  List<OwnerDetail> ownerDetList = [];
  bool dobFromOnchanged = false;
  var ownerNameCtrlr = TextEditingController();
  var ownerAddrCtrlr = TextEditingController();
  var ownerPhnCtrlr = TextEditingController();
  var ownerMblCtrlr = TextEditingController();
  var ownerEmailCtrlr = TextEditingController();
  RegnWizard? stepsWizard;
  var isRegAppFinalSubmit;
  @override
  void initState() {
    super.initState();
    isRegAppFinalSubmit = SpUtil.getString('isRegAppFinalSubmit');
    if (widget.data != null) {
      existingAccoDts = widget.data;
      ownerDetList = existingAccoDts!.ownerDetails!;
      hotelAndOwnerDetails = existingAccoDts!;
      print('owners existing ${existingAccoDts!.ownerDetails!}');
      // print('OwnerDetails length ${existingAccoDts.ownerDetails.length}');
      // for (int i = 0; i < existingAccoDts.ownerDetails.length; i++) {
      //   ownerDetList.add(OwnerDetail(
      //     name: existingAccoDts.ownerDetails[i].name,
      //     address: existingAccoDts.ownerDetails[i].address,
      //   ));
      // }
    }
    if (widget.hotelDetails != null) {
      hotelAndOwnerDetails = widget.hotelDetails;
      print('Hotel details ${hotelAndOwnerDetails.accomName}');
    }
    setState(() {
      //  page1 = widget.data;
      stepsWizard = new RegnWizard(currentPageNo: "3");
    });
    FormCCommonServices.getState().then((result) {
      stateList = result;
      ////print('state $stateList');
    });
  }

  postHtlAndOwnerDts() async {
    EasyLoading.show(status: 'Please Wait...');
    var token = await HttpUtils().getToken();
    //print('token: $token');
    hotelAndOwnerDetails.userName = await HttpUtils().getUsername();
    try {
      var data = json.encode({
        "userId": hotelAndOwnerDetails.userName,
        "accomName": hotelAndOwnerDetails.accomName,
        "accomCapacity": hotelAndOwnerDetails.accomCapacity,
        "accomAddress": hotelAndOwnerDetails.accomAddress,
        "accomState": hotelAndOwnerDetails.accomState,
        "accomCityDist": hotelAndOwnerDetails.accomCityDist,
        "frroTypeCode": hotelAndOwnerDetails.frroTypeCode,
        "accomodationType": hotelAndOwnerDetails.accomodationType,
        "accomodationGrade": hotelAndOwnerDetails.accomodationGrade,
        "accomMobile": hotelAndOwnerDetails.accomMobile,
        "accomPhoneNum": hotelAndOwnerDetails.accomPhoneNum,
        "accomEmail": hotelAndOwnerDetails.accomEmail,
        "ownerDetails": ownerDetList
      });
      print('Inside Accom post $data');
      //print(GENERATE_APPLID);
      await http.post(
        Uri.parse(POST_ACCOM_DTS),
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
          stepsWizard!.createState().moveToRegnScreen("4", context);

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

  back() {
    //print('Previous Page: P0');
    Navigator.pop(context);
  }

  next() {
    if (_fbKey.currentState!.saveAndValidate()) {
      if (ownerDetList.length > 0) {
        if (isRegAppFinalSubmit == 'Y') {
          stepsWizard!
              .createState()
              .moveToRegnScreen("4", context, existingAccoDts);
        } else {
          postHtlAndOwnerDts();
        }
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
                        //                   context, "/homeScreen");
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  title: Column(children: [
                    Text('Add atleast one owner detail'),
                  ]));
            });
      }
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
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
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
                                  //  initialValue: multipleOwnerObj.name,
                                  controller: ownerNameCtrlr,
                                  //name: "Name",
                                  maxLines: 1,
                                  maxLength: MAX_LENGTH_TEXTFIELD,

                                  onSubmitted: (field) {
                                    multipleOwnerObj.name = field;
                                    //print('name owner ${multipleOwnerObj.name}');
                                    ownerNameCtrlr.text = field!;
                                  },
                                  //       textCapitalization: TextCapitalization.characters,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    // prefixIcon: Icon(Icons.person, color: blue),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(width: 2, color: blue),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(width: 2, color: blue),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
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
                                      // FormBuilderValidators.required(
                                      //   errorText: 'Required',
                                      // ),
                                    ],
                                  ),
                                  cursorColor: blue,
                                  name: 'ownerName',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
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
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(alphaNumSpaceSpecial))
                                  ],
                                  // initialValue: multipleOwnerObj.address,
                                  controller: ownerAddrCtrlr,
                                  //name: "Name",
                                  maxLines: 1,
                                  maxLength: MAX_LENGTH_TEXTFIELD,
                                  onSubmitted: (field) {
                                    multipleOwnerObj.address = field;
                                    ownerAddrCtrlr.text = field!;
                                  },
                                  //       textCapitalization: TextCapitalization.characters,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    // prefixIcon: Icon(Icons.person, color: blue),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(width: 2, color: blue),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(width: 2, color: blue),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
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
                                      // FormBuilderValidators.required(
                                      //   errorText: 'Required',
                                      // ),
                                    ],
                                  ),
                                  cursorColor: blue,
                                  name: 'ownerAddr',
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
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
                                    // FormBuilderValidators.required(
                                    //   errorText: 'Required',
                                    // ),
                                  ],
                                ),
                                getImmediateSuggestions: false,
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: _ownerState,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: CONTENTPADDING),
                                    // prefixIcon: Icon(
                                    //     Icons.location_city_rounded,
                                    //     color: blue),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(width: 2, color: blue),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(width: 2, color: blue),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 16,
                                        letterSpacing: 1),
                                    //   contentPadding: EdgeInsets.all(15.0),
                                    suffixIcon: IconButton(
                                        icon: (multipleOwnerObj.state != null)
                                            ? Icon(Icons.remove_circle)
                                            : Icon(Icons.search),
                                        onPressed: () {
                                          setState(() {
                                            //    page1.froState = null;
                                            multipleOwnerObj.state = null;
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
                                          .compareTo(
                                              b.statename!.toLowerCase()));
                                  }
                                },
                                onSuggestionSelected: (StateModel suggestion) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  //page1.froState = newVal.statecode;

                                  setState(() {
                                    //  page1.froState = newVal.statecode;
                                    multipleOwnerObj.cityDist = null;

                                    multipleOwnerObj.state =
                                        suggestion.statecode;
                                    _ownerState.text = suggestion.statename!;
                                    FormCCommonServices.getDistrict(
                                            multipleOwnerObj.state!)
                                        .then((result) {
                                      setState(() {
                                        distInIndList = result;
                                        //print('dist to load $distInIndList');
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
                          ],
                        ),
                      ),
                      Expanded(
                          child: Column(
                        children: [
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
                            child: TypeAheadFormField(
                              validator: FormBuilderValidators.compose(
                                [
                                  // FormBuilderValidators.required(
                                  //   errorText: 'Required',
                                  // ),
                                ],
                              ),
                              getImmediateSuggestions: false,
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: _ownerCity,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: CONTENTPADDING),
                                  // prefixIcon: Icon(Icons.location_city_rounded,
                                  // color: blue),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(width: 2, color: blue),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(width: 2, color: blue),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 16,
                                      letterSpacing: 1),
                                  //   contentPadding: EdgeInsets.all(15.0),
                                  suffixIcon: IconButton(
                                      icon: (multipleOwnerObj.cityDist != null)
                                          ? Icon(Icons.remove_circle)
                                          : Icon(Icons.search),
                                      onPressed: () {
                                        setState(() {
                                          //    page1.froState = null;
                                          multipleOwnerObj.cityDist = null;
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
                              itemBuilder: (context, districtModel) {
                                return ListTile(
                                  title: Text(
                                    districtModel.districtname!,
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
                                  return distInIndList.where((district) {
                                    return district.districtname!
                                        .toLowerCase()
                                        .contains(query.toLowerCase());
                                  }).toList(growable: false)
                                    ..sort((a, b) => a.districtname!
                                        .toLowerCase()
                                        .indexOf(lowercaseQuery)
                                        .compareTo(b.districtname!
                                            .toLowerCase()
                                            .indexOf(lowercaseQuery)));
                                } else {
                                  return distInIndList
                                    ..sort((a, b) => a.districtname!
                                        .toLowerCase()
                                        .compareTo(
                                            b.districtname!.toLowerCase()));
                                }
                              },
                              onSuggestionSelected: (DistrictModel suggestion) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                //page1.froState = newVal.statecode;

                                setState(() {
                                  //  page1.froState = newVal.statecode;
                                  multipleOwnerObj.cityDist =
                                      suggestion.districtcode;

                                  _ownerCity.text = suggestion.districtname!;
                                });
                              },
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        children: [
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
                              // initialValue: multipleOwnerObj.phoneNum,
                              controller: ownerPhnCtrlr,
                              keyboardType: TextInputType.number,
                              onSubmitted: (value) {
                                multipleOwnerObj.phoneNum = value;
                              },
                              maxLength: 15,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(phnNumbers))
                              ],
                              cursorColor: blue,
                              name: "ownerPhn",
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: CONTENTPADDING),
                                // prefixIcon: Icon(FontAwesome.phone, color: blue),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2, color: blue),
                                    borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2, color: blue),
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
                                  //     FormBuilderValidators.numeric(),
                                  // FormBuilderValidators.required(
                                  //   errorText: 'Required',
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
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
                          Padding(
                            padding: const EdgeInsets.only(
                                left: LABELPADDING,
                                right: LABELPADDING,
                                top: TOPPADDING),
                            child: FormBuilderTextField(
                              // initialValue: multipleOwnerObj.mobile,
                              controller: ownerMblCtrlr,
                              keyboardType: TextInputType.number,
                              maxLength: 15,
                              onSubmitted: (value) {
                                multipleOwnerObj.mobile = value;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(phnNumbers))
                              ],
                              cursorColor: blue,
                              name: "ownerMblnum",
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: CONTENTPADDING),
                                // prefixIcon:
                                //     Icon(FontAwesome.mobile_phone, color: blue),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2, color: blue),
                                    borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2, color: blue),
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
                                  // FormBuilderValidators.required(
                                  //   errorText: 'Required',
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))
                    ],
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
                        // initialValue: multipleOwnerObj.emailId,
                        controller: ownerEmailCtrlr,
                        //name: "Name",
                        maxLines: 1,
                        maxLength: MAX_LENGTH_TEXTFIELD,
                        onSubmitted: (field) {
                          multipleOwnerObj.emailId = field;
                        },
                        //       textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10.0),
                          // prefixIcon: Icon(Icons.person, color: blue),
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
                            // FormBuilderValidators.required(
                            //   errorText: 'Required',
                            // ),
                          ],
                        ),
                        cursorColor: blue,
                        name: 'ownerEmail',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: ElevatedButton(
                        child: Text('Add'),
                        onPressed: () {
                          //print('inside accept');
                          setState(() {
                            {
                              if (_fbKey.currentState!.validate()) {
                                _fbKey.currentState!.save();
                                ownerDetList.add(OwnerDetail(
                                  name: ownerNameCtrlr.text,
                                  address: ownerAddrCtrlr.text,
                                  state: multipleOwnerObj.state,
                                  cityDist: multipleOwnerObj.cityDist,
                                  emailId: ownerEmailCtrlr.text,
                                  mobile: ownerMblCtrlr.text,
                                  phoneNum: ownerPhnCtrlr.text,
                                ));
                                //print(
                                // 'owner name in list 1 ${ownerDetList[0].name}');

                                ownerNameCtrlr.clear();
                                ownerNameCtrlr.text = "";
                                ownerAddrCtrlr.clear();
                                ownerAddrCtrlr.text = "";
                                ownerEmailCtrlr.clear();
                                ownerEmailCtrlr.text = "";
                                ownerMblCtrlr.clear();
                                ownerMblCtrlr.text = "";
                                ownerPhnCtrlr.clear();
                                ownerPhnCtrlr.text = "";
                                _ownerState.clear();
                                _ownerState.text = "";
                                _ownerCity.clear();
                                _ownerCity.text = "";
                                // multipleOwnerObj.city = '';
                                ////print('details $ownerDetList');
                              } else {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          actions: [
                                            TextButton(
                                              child: new Text('Ok',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .blue.shade500)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                          title: Column(children: [
                                            Text('Enter Owner Details'),
                                          ]));
                                    });
                              }
                            }
                          });
                        }),
                  ),
                  if (ownerDetList.length > 0)
                    ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: ownerDetList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            child: ListTile(
                          title: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Owner Detail ${index + 1}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      'Name: ${ownerDetList[index].name}')),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      'Address: ${ownerDetList[index].address}')),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      'Mobile: ${ownerDetList[index].mobile}'))
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                            ),
                            iconSize: 35,
                            color: blue,
                            splashColor: Colors.red,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Do you want to delete the record ?'),
                                      //    content: Text('Thank You For Submission'),
                                      actions: [
                                        TextButton(
                                          child: new Text('No',
                                              style: TextStyle(
                                                  color: Colors.blue.shade500)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: new Text('Yes',
                                              style: TextStyle(
                                                  color: Colors.blue.shade500)),
                                          onPressed: () {
                                            ////print('i value $index');
                                            Navigator.of(context).pop();
                                            ////print('i value $index');
                                            setState(() {
                                              ownerDetList.removeAt(index);
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ),
                        ));
                      },
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
