import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formc_showcase/services/formC_commonServices.dart';
import 'dart:ui' as ui;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:formc_showcase/screens/homeScreen.dart';

class FormCDetailsConfirmationScreen extends StatefulWidget {
  // const FormCDetailsConfirmationScreen({ Key? key }) : super(key: key);
  String formCApplicationId;
  FormCDetailsConfirmationScreen(this.formCApplicationId);
  @override
  _FormCDetailsConfirmationScreenState createState() =>
      _FormCDetailsConfirmationScreenState();
}

class _FormCDetailsConfirmationScreenState
    extends State<FormCDetailsConfirmationScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  var _formCPendingDetails;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getTempSavedFormCDetails();
  }

  var responseJson;
  finalSubmitFormCData() async {
    EasyLoading.show(status: 'Please Wait...');
    var token = await HttpUtils().getToken();
    var newApplicationId = await HttpUtils().getNewApplicationId();
    print(FINAL_SUBMIT_URL + "$newApplicationId");
    print('Token $token');
    try {
      await http.post(
        Uri.parse(FINAL_SUBMIT_URL + "$newApplicationId"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $token'
        },
      ).then((response) async {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        responseJson = json.decode(json.encode(response.body));
        //  print(responseJson);
        if (response.statusCode == 200) {
          // stepsWizard.createState().moveToScreen(
          //     passportNumberFromSearch, nationalityFromSearch, "6", context);
          //print('200 Success');
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    actions: [
                      TextButton(
                        child: new Text('Ok', style: TextStyle(color: blue)),
                        onPressed: () {
                          //print('navigate to home');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FormCHomeScreen()));
                        },
                      ),
                    ],
                    title: Text(
                        "Your application $newApplicationId submitted successfully"),
                  ));

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
      // print('final excep:$e');
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

  var dobFormatDesc;
  getTempSavedFormCDetails() async {
    _formCPendingDetails = await FormCCommonServices.getPendingDetailsByApplId(
        widget.formCApplicationId);

    setState(() {
      _formCPendingDetails = _formCPendingDetails;
    });
    //print(_formCPendingDetails[0].dobFormat);
    final index = DOBFORMATLIST.indexWhere((element) =>
        element['dobFormat_code'] == _formCPendingDetails[0].dobFormat);
    //print(-index);

    //print('Using indexWhere: ${DOBFORMATLIST[-index]['dobFormat_desc']}');
    dobFormatDesc = DOBFORMATLIST[-index]['dobFormat_desc'];
    //print('in conf scr : ${_formCPendingDetails[0].givenName}');
    if (_formCPendingDetails[0].nextDestCountryFlag == 'I') {
      _formCPendingDetails[0].nextDestCountryFlag = 'Inside India';
    } else {
      _formCPendingDetails[0].nextDestCountryFlag = 'Outside India';
    }
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
          body: FormBuilder(
              key: _fbKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: (_formCPendingDetails != null &&
                      _formCPendingDetails.length > 0)
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Column(
                        children: [
                          // Text('Application Details',
                          //     style: TextStyle(
                          //         decoration: TextDecoration.underline,
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 18,
                          //         color: blue)),
                          Text(' Application Details ',
                              style: TextStyle(
                                  //   decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: blue)),
                          Center(
                            child: InkWell(
                              // onTap: getImage,

                              child: CircleAvatar(
                                minRadius: 80.0,
                                maxRadius: 80,
                                child: ClipOval(
                                  child: (_formCPendingDetails[0].image !=
                                              null &&
                                          _formCPendingDetails[0].image != "")
                                      ? Image.memory(Base64Decoder().convert(
                                          _formCPendingDetails[0].image))
                                      : Icon(
                                          Icons.person,
                                          color: blue,
                                          size: 50,
                                        ),
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                          Table(
                            columnWidths: {0: FractionColumnWidth(.4)},
                            textDirection: ui.TextDirection.ltr,
                            // border:
                            //     TableBorder.all(width: 1.5, color: Colors.black),
                            children: [
                              TableRow(children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Application Id',
                                    style: TextStyle(
                                      //   color: blue,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    '${widget.formCApplicationId}',
                                    style: TextStyle(
                                      color: blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ]),
                              if (_formCPendingDetails[0].givenName != null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Name',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].givenName} ' +
                                          '${_formCPendingDetails[0].surname}',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].genderDesc != null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Gender',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].genderDesc} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].dobFormat != null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'DOB Format',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${dobFormatDesc} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].dob != null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'DOB',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].dob} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].nationalityDesc !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Nationality',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].nationalityDesc} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].addrOutsideIndia !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Address Outside India',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].addrOutsideIndia} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].cityOutsideIndia !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'City Outside India',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].cityOutsideIndia} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0]
                                      .countryOutsideIndiaDesc !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Country Outside India',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].countryOutsideIndiaDesc} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].passportNumber !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Passport Number',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].passportNumber} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0]
                                      .passportPlaceOfIssue !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Passport Issued Place',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].passportPlaceOfIssue} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0]
                                      .passportIssuedCountryDesc !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Passport Issued Country',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].passportIssuedCountryDesc} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].passportIssuedDate !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Passport Issued Date',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].passportIssuedDate}',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].passportExpiryDate !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Passport Expiry Date',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].passportExpiryDate}',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].visaNumber != null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Visa Number',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].visaNumber} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].visaIssuedPlace !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Visa Issued Place',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].visaIssuedPlace} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0]
                                      .visaIssuedCountryDesc !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Visa Issued Country',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].visaIssuedCountryDesc} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].visaIssuedDate !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Visa Issued Date',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].visaIssuedDate} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].visaExpiryDate !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Visa Expiry Date',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].visaExpiryDate} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].visatypeDesc != null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Visatype',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].visatypeDesc} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              // if (_formCPendingDetails[0].dualNatFlag != null)
                              //   TableRow(children: [
                              //     Padding(
                              //       padding: EdgeInsets.all(8.0),
                              //       child: Text(
                              //         'Holding Dual Nationality ?',
                              //         style: TextStyle(
                              //           fontSize: 15,
                              //         ),
                              //       ),
                              //     ),
                              //     Padding(
                              //       padding: EdgeInsets.all(8.0),
                              //       child: Text(
                              //         ' ${_formCPendingDetails[0].dualNatFlag} ',
                              //         style: TextStyle(
                              //           color: blue,
                              //           fontSize: 16,
                              //         ),
                              //       ),
                              //     ),
                              //   ]),
                              if (_formCPendingDetails[0].visaSubtypeDesc !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Visa Subtype',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].visaSubtypeDesc} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].arrivedFromPlace !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Arrived From Place',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].arrivedFromPlace} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].arrivedFromCity !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Arrived From City',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].arrivedFromCity} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0]
                                      .arrivedFromCountryDesc !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Arrived From Country',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].arrivedFromCountryDesc} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              // if (_formCPendingDetails[0].earindtravl != null)
                              //   TableRow(children: [
                              //     Padding(
                              //       padding: EdgeInsets.all(8.0),
                              //       child: Text(
                              //         'Earlier in India?',
                              //         style: TextStyle(
                              //           fontSize: 15,
                              //         ),
                              //       ),
                              //     ),
                              //     Padding(
                              //       padding: EdgeInsets.all(8.0),
                              //       child: Text(
                              //         ' ${_formCPendingDetails[0].earindtravl} ',
                              //         style: TextStyle(
                              //           color: blue,
                              //           fontSize: 16,
                              //         ),
                              //       ),
                              //     ),
                              //   ]),
                              // if (_formCPendingDetails[0].wheindorg != null)
                              //   TableRow(children: [
                              //     Padding(
                              //       padding: EdgeInsets.all(8.0),
                              //       child: Text(
                              //         'Indian Origin ?',
                              //         style: TextStyle(
                              //           fontSize: 15,
                              //         ),
                              //       ),
                              //     ),
                              //     Padding(
                              //       padding: EdgeInsets.all(8.0),
                              //       child: Text(
                              //         ' ${_formCPendingDetails[0].wheindorg} ',
                              //         style: TextStyle(
                              //           color: blue,
                              //           fontSize: 16,
                              //         ),
                              //       ),
                              //     ),
                              //   ]),
                              if (_formCPendingDetails[0].arrivalDateInIndia !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Arrival Date In India',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].arrivalDateInIndia} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              // if (_formCPendingDetails[0].servedmilitaryFlag != null)
                              //   TableRow(children: [
                              //     Padding(
                              //       padding: EdgeInsets.all(8.0),
                              //       child: Text(
                              //         'Served In Military?',
                              //         style: TextStyle(
                              //           fontSize: 15,
                              //         ),
                              //       ),
                              //     ),
                              //     Padding(
                              //       padding: EdgeInsets.all(8.0),
                              //       child: Text(
                              //         ' ${_formCPendingDetails[0].servedmilitaryFlag} ',
                              //         style: TextStyle(
                              //           color: blue,
                              //           fontSize: 16,
                              //         ),
                              //       ),
                              //     ),
                              //   ]),
                              if (_formCPendingDetails[0].arrivalDateInHotel !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Arrival Date In Hotel',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].arrivalDateInHotel} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].arrivalTimeInHotel !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Arrival Time In Hotel',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].arrivalTimeInHotel} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].durationOfStay !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Duration Of Stay',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].durationOfStay} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].nextDestCountryFlag !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Next Destination',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].nextDestCountryFlag} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0]
                                      .nextDestPlaceInIndia !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Next Destination Place In India',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].nextDestPlaceInIndia} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0]
                                      .nextDestDistInIndiaDesc !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Next Destination District In India',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].nextDestDistInIndiaDesc} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0]
                                      .nextDestStateInIndiaDesc !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Next Destination State In India',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].nextDestStateInIndiaDesc} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),

                              if (_formCPendingDetails[0]
                                      .nextDestPlaceOutsideIndia !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Next Destination Place Outside India',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].nextDestPlaceOutsideIndia} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0]
                                      .nextDestCityOutsideIndia !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Next Destination City Outside India',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].nextDestCityOutsideIndia} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0]
                                      .nextDestCountryOutsideIndia !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Next Destination Country',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].nextDestCountryOutsideIndia} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].addrOfReference !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Address Of Reference',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].addrOfReference} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0]
                                      .stateOfReferenceDesc !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'State Of Reference',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].stateOfReferenceDesc} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].cityOfReferenceDesc !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'City Of Reference',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].cityOfReferenceDesc} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].pincodeOfReference !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Pincode Of Reference',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].pincodeOfReference} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].mobileNumberInIndia !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Mobile Number In India',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].mobileNumberInIndia} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].phoneNumberInIndia !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Phone Number In India',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].phoneNumberInIndia} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].mobileNumber != null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Mobile Number',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].mobileNumber} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].phoneNumber != null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Phone Number',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].phoneNumber} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].employedInIndia !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Employed In India',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].employedInIndia} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].splCategoryCodeDesc !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Special Category',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].splCategoryCodeDesc} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              if (_formCPendingDetails[0].purposeOfVisitDesc !=
                                  null)
                                TableRow(children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Purpose Of Visit',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ' ${_formCPendingDetails[0].purposeOfVisitDesc} ',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),

                              // if (_formCPendingDetails[0].carrierCode != null)
                              //   TableRow(children: [
                              //     Padding(
                              //       padding: EdgeInsets.all(8.0),
                              //       child: Text(
                              //         'Carrier Code',
                              //         style: TextStyle(
                              //           fontSize: 15,
                              //         ),
                              //       ),
                              //     ),
                              //     Padding(
                              //       padding: EdgeInsets.all(8.0),
                              //       child: Text(
                              //         ' ${_formCPendingDetails[0].carrierCode} ',
                              //         style: TextStyle(
                              //           color: blue,
                              //           fontSize: 16,
                              //         ),
                              //       ),
                              //     ),
                              //   ]),
                            ],
                          ),
                          //           FormBuilderCheckbox(
                          //             name: 'confirmationField',
                          //               initialValue: false,

                          //             title: Text(
                          //                 'I hereby declare that the information given above is true to the best of my knowledge and belief'),
                          //             validator: FormBuilderValidators.equal(
                          //   context,

                          //   errorText: 'You must accept terms and conditions to continue',
                          // ),
                          //           ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: 250,
                            height: 40,
                            child: ElevatedButton(
                              // hoverColor: Colors.blue,
                              // focusColor: Colors.blue,
                              style: ElevatedButton.styleFrom(
                                // highlightColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                ),
                                primary: blue,
                              ),

                              child: Text(
                                'Submit Application',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                if (_fbKey.currentState!.saveAndValidate()) {
                                  // Navigator.of(context)
                                  //     .pushReplacementNamed("/loginScreen");
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            actions: [
                                              TextButton(
                                                child: new Text('No',
                                                    style:
                                                        TextStyle(color: blue)),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: new Text('Yes',
                                                    style:
                                                        TextStyle(color: blue)),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  finalSubmitFormCData();
                                                },
                                              ),
                                            ],
                                            title: Column(children: [
                                              Text(
                                                  'Do you want to submit the application?'),
                                            ]));
                                      });
                                  //print('true');
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            actions: [
                                              TextButton(
                                                child: new Text('Ok',
                                                    style:
                                                        TextStyle(color: blue)),
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
                        ],
                      ),
                    )
                  : Center(child: CircularProgressIndicator()))),
    );
  }
}
