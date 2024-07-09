import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/util/validations.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:formc_showcase/util/spUtil.dart';

import 'package:formc_showcase/services/formC_commonServices.dart';
import 'package:formc_showcase/models/formCdataModel.dart';
import 'dart:ui' as ui;
import 'package:formc_showcase/models/getArrivalDetailsModel.dart';

class CheckOutDetails extends StatefulWidget {
  //const CheckOutDetails({ Key? key }) : super(key: key);
  var applicationId, frroFroCode, nationality, passportNumber;
  CheckOutDetails(this.applicationId, this.frroFroCode, this.nationality,
      this.passportNumber);
  @override
  _CheckOutDetailsState createState() => _CheckOutDetailsState();
}

class _CheckOutDetailsState extends State<CheckOutDetails> {
  var checkOutApplId,
      checkOutFroCode,
      dateOfDeparture,
      timeOfDeparture,
      remarks,
      dateOfArrivalInHotel;
  bool isLoadingComplete = false;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  @override
  void initState() {
    super.initState();
    if (widget.applicationId != null) {
      checkOutApplId = widget.applicationId;
      checkOutFroCode = widget.frroFroCode;
    }
    getArrivalDetails();
  }

  List? arrivaldetails;
  dateParseFormatter(var beforeParse) {
    //  print('inside date format fun');
    var date = DateTime.parse('$beforeParse');
    var dateFormatter = new DateFormat("dd/MM/yyyy");
    String formattedDate = dateFormatter.format(date);
    //  print('result $formattedDate');
    return formattedDate;
  }

  Future<List> getArrivalDetails() async {
    var token = await HttpUtils().getToken();

    dynamic dateOfArrival;
    var userName = await HttpUtils().getUsername();
    var frroFroCode = await HttpUtils().getFrrocode();
    var accoCode = await HttpUtils().getAccocode();

    // if (widget.dateofarrival != null) {
    //   widget.dateofarrival =
    //       DateFormat("dd/MM/yyyy").format(dateOfArrival);
    // }

    var data = json.encode({
      "frro_fro_code": frroFroCode,
      "entered_by": userName,
      "form_c_appl_id": widget.applicationId,
      "acco_code": accoCode,
      "nationality": widget.nationality,
      "passport_no": widget.passportNumber,
      "date_of_arrival_in_hotel": "",
      "visa_no": ""
    });
    //  print(GET_ARRIVAL_DETAIL_URL);
    //  print(data);
    await http.post(
      Uri.parse(GET_ARRIVAL_DETAIL_URL),
      body: data,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token'
      },
    ).then((response) {
      //  print("Response status: ${response.statusCode}");
      //  print("Response body: ${response.body}");
      var responseJson = json.decode(response.body);
      setState(() {
        if (response.statusCode == 200)
          arrivaldetails = (responseJson as List)
              .map((i) => new ArrivalDetailsModel.fromJson(i))
              .toList();
        isLoadingComplete = true;
        if (arrivaldetails != null)
          dateOfArrivalInHotel = arrivaldetails![0].dateOfArrivalInHotel;
      });

      // chkuser = responseJson['username'];
      // token = responseJson['token'];
      //// print(chkuser);
      // status = response.statusCode;
      //// print(responseJson);
      //// print('arri $arrivaldetails1');
    });
    return arrivaldetails!;
  }

  postCheckOutDetails() async {
    var token = await HttpUtils().getToken();
    var userName = await HttpUtils().getUsername();

    if (_fbKey.currentState!.fields['dateOfDeparture']!.value != null)
      dateOfDeparture = DateFormat("dd-MM-yyyy")
          .format(_fbKey.currentState!.fields['dateOfDeparture']!.value);
    if (_fbKey.currentState!.fields['timeOfDeparture']!.value != null)
      timeOfDeparture = DateFormat("Hm")
          .format(_fbKey.currentState!.fields['timeOfDeparture']!.value);
    String formattedEnteredOnDate = DateFormat('d-M-y').format(DateTime.now());
    var data = json.encode({
      "form_c_appl_id": checkOutApplId,
      "date_of_departure": dateOfDeparture,
      "time_of_departure": timeOfDeparture,
      "frro_fro_code": checkOutFroCode,
      "entered_by": userName,
      "entered_on": formattedEnteredOnDate,
      "departure_remark": remarks
    });
    //  print(data);
    await http.post(
      Uri.parse(GET_DEPART_DETAIL_URL),
      body: data,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token'
      },
    ).then((response) {
      //  print("Response status: ${response.statusCode}");
      //  print("Response body: ${response.body}");
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        // stepsWizard.createState().moveToScreen(
        //     passportNumberFromSearch, nationalityFromSearch, "6", context);
        //  print('Success');
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  actions: [
                    TextButton(
                      child: new Text('Ok', style: TextStyle(color: blue)),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed("/homeScreen");
                      },
                    ),
                  ],
                  title: Text("Checkout details submitted successfully"),
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
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: FormBuilder(
                key: _fbKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(' Checkout Details ',
                        style: TextStyle(
                            //   decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: blue)),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: FIELDPADDING),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Date of departure *',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 16,
                                letterSpacing: 1),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(FIELDPADDING),
                      child: FormBuilderDateTimePicker(
                        name: "dateOfDeparture",
                        onChanged: (val) {
                          dateOfDeparture = '$val';
                          //  print(
                          //    ' Date of arrival in validation: ${arrivaldetails[0].dateOfArrivalInHotel}');
                          //  print('dateofdep $val');
                        },
                        // initialValue:
                        //     (DateFormat("dd/MM/yyyy").parse(dateOfDeparture)),

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
                          // labelText: 'Date of departure'

                          /*   suffixIcon: IconButton(
                            icon: new Icon(Icons.help),
                            tooltip: 'Date of birth as in Passport in DD/MM/YYYY format',
                            onPressed: () {},
                          ),*/
                        ),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                              errorText: 'Required',
                            ),
                            // ignore: missing_return
                            (val) {
                              if (val != null && dateOfArrivalInHotel != null) {
                                var dateOfdepFormatted =
                                    dateParseFormatter(val);

                                //  print('deptdateformatted $dateOfdepFormatted');

                                dynamic arrivalDateBeforeFormat =
                                    DateFormat('dd-MM-yyyy')
                                        .parse(dateOfArrivalInHotel);
                                dynamic arrivalDateFormatted =
                                    dateParseFormatter(arrivalDateBeforeFormat);
                                //  print('arrivaldateform $arrivalDateFormatted');
                                var df1 = DateFormat('dd/MM/yyyy')
                                    .parse(arrivalDateFormatted);
                                var df2 = DateFormat('dd/MM/yyyy')
                                    .parse(dateOfdepFormatted);
                                if ((df2).isBefore(df1)) {
                                  //  print('inside isbefore');
                                  return "Date must be later than arrival date";
                                }
                                // if ((df1.isAtSameMomentAs(df2))) {
                                //   return "";
                                // }
                              }
                            }
                          ],
                        ),
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
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: FIELDPADDING),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Time of departure *',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 16,
                                letterSpacing: 1),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(FIELDPADDING),
                      child: FormBuilderDateTimePicker(
                        name: "timeOfDeparture",
                        onChanged: (val) {
                          timeOfDeparture = '$val';
                        },
                        // initialValue:
                        //     (DateFormat("dd/MM/yyyy").parse(timeOfDeparture)),

                        valueTransformer: (value) => (value != null)
                            ? DateFormat("Hm").format(value)
                            : null,
                        inputType: InputType.time,
                        format: DateFormat("Hm"),
                        //  readOnly:  page1.dateOfBirth !=null ? true : false ,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: CONTENTPADDING),
                          prefixIcon: Icon(Icons.timelapse, color: blue),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          // labelText: 'Time of departure'

                          /*   suffixIcon: IconButton(
                            icon: new Icon(Icons.help),
                            tooltip: 'Date of birth as in Passport in DD/MM/YYYY format',
                            onPressed: () {},
                          ),*/
                        ),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                              errorText: 'Required',
                            ),
                            // ignore: missing_return
                            (val) {}
                          ],
                        ),
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
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: FIELDPADDING),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Remarks ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 16,
                                letterSpacing: 1),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(FIELDPADDING),
                      child: Container(
                        child: FormBuilderTextField(
                          initialValue: remarks,
                          name: "remarksIfAny",
                          maxLines: 1,
                          maxLength: 20,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(alphaNumericSpace))
                          ],
                          onChanged: (field) {
                            remarks = field!.toUpperCase();
                          },
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: CONTENTPADDING),
                            prefixIcon:
                                Icon(FontAwesomeIcons.edit, color: blue),
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
                            // labelText: 'Remarks',
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
                    Container(
                      width: 250,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          //  highlightColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                          ),
                          primary: blue,
                        ),
                        // hoverColor: Colors.blue,
                        // focusColor: Colors.blue,

                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (_fbKey.currentState!.saveAndValidate()) {
                            // Navigator.of(context)
                            //     .pushReplacementNamed("/loginScreen");
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      'Do you want to submit checkout details'),
                                  actions: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(18.0),
                                          ),
                                          primary: blue,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('No',
                                            style: TextStyle(
                                                color: Colors.white))),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(18.0),
                                          ),
                                          primary: blue,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          postCheckOutDetails();
                                        },
                                        child: Text(
                                          'yes',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ],
                                );
                              },
                            );

                            //  print('true');
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
                      height: 10,
                    ),
                    if ((arrivaldetails != null &&
                        arrivaldetails!.length > 0 &&
                        arrivaldetails!.isNotEmpty))
                      Text(' Arrival Details ',
                          style: TextStyle(
                              //   decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: blue)),
                    SizedBox(
                      height: 10,
                    ),
                    if ((arrivaldetails != null &&
                        arrivaldetails!.length > 0 &&
                        arrivaldetails!.isNotEmpty))
                      Center(
                        child: InkWell(
                          // onTap: getImage,

                          child: CircleAvatar(
                            minRadius: 80.0,
                            maxRadius: 80,
                            child: ClipOval(
                                child: (arrivaldetails![0].img != null &&
                                        arrivaldetails![0].img != "")
                                    ? Image.memory(Base64Decoder()
                                        .convert(arrivaldetails![0].img))
                                    : Icon(
                                        Icons.person,
                                        color: blue,
                                        size: 50,
                                      )),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    if ((arrivaldetails != null &&
                        arrivaldetails!.length > 0 &&
                        arrivaldetails!.isNotEmpty))
                      Center(
                        child: Table(
                          children: [
                            if (arrivaldetails![0].formCApplId != null)
                              TableRow(children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Application Id',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    ' ${arrivaldetails![0].formCApplId} ',
                                    style: TextStyle(
                                      color: blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ]),
                            if (arrivaldetails![0].name != null)
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
                                    ' ${arrivaldetails![0].name} ',
                                    style: TextStyle(
                                      color: blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ]),
                            if (arrivaldetails![0].passportNo != null)
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
                                    ' ${arrivaldetails![0].passportNo} ',
                                    style: TextStyle(
                                      color: blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ]),
                            if (arrivaldetails![0].nationalityName != null)
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
                                    ' ${arrivaldetails![0].nationalityName} ',
                                    style: TextStyle(
                                      color: blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ]),
                            if (arrivaldetails![0].visaNo != null)
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
                                    ' ${arrivaldetails![0].visaNo} ',
                                    style: TextStyle(
                                      color: blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ]),
                            if (arrivaldetails![0].dateOfArrivalInHotel != null)
                              TableRow(children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Arrival Date',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    ' ${arrivaldetails![0].dateOfArrivalInHotel} ',
                                    style: TextStyle(
                                      color: blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ]),
                            if (arrivaldetails![0].timeOfArrivalInHotel != null)
                              TableRow(children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Arrival Time',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    ' ${arrivaldetails![0].timeOfArrivalInHotel} ',
                                    style: TextStyle(
                                      color: blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ]),
                          ],
                          columnWidths: {0: FractionColumnWidth(.4)},
                          textDirection: ui.TextDirection.ltr,
                        ),
                      )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
