// import 'dart:convert';
// import 'package:formc_showcase/models/masters/AccogradeModel.dart';
// import 'package:formc_showcase/models/masters/accotypeModel.dart';
// import 'package:formc_showcase/models/masters/frroModel.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:formc_showcase/constants/formC_constants.dart';
// import 'package:formc_showcase/models/masters/districtModel.dart';
// import 'package:intl/intl.dart';
// import '../../models/Registration/AccoProfileModel.dart';
// import '../../models/masters/countryModel.dart';
// import '../../models/masters/stateModel.dart';
// import '../../services/formC_commonServices.dart';
// import '../../util/httpUtil.dart';
// import '../../util/validations.dart';

// class AccomodatorProfile extends StatefulWidget {
//   const AccomodatorProfile({Key key}) : super(key: key);
//   @override
//   State<AccomodatorProfile> createState() => _AccomodatorProfileState();
// }

// class _AccomodatorProfileState extends State<AccomodatorProfile> {
//   int currStep = 0;
//   List<CountryModel> countryList = [];
//   bool addOwnerDetail = false;
//   static var _focusNode = new FocusNode();
//   OwnerDetail multipleOwnerObj = new OwnerDetail();
//   List<GlobalKey<FormBuilderState>> formKeys = [
//     GlobalKey<FormBuilderState>(),
//     GlobalKey<FormBuilderState>(),
//     GlobalKey<FormBuilderState>()
//   ];
//   final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
//   TextEditingController _nationalityController = new TextEditingController();
//   static AccomodatorModel accodataObj = new AccomodatorModel();
//   TextEditingController _accoState = new TextEditingController();
//   TextEditingController _accoCity = new TextEditingController();
//   TextEditingController _ownerState = new TextEditingController();
//   TextEditingController _ownerCity = new TextEditingController();
//   List<StateModel> stateList = [];
//   List<AccoGradeModel> accogradeList = [];
//   List<AccotypeModel> accotypeList = [];
//   List<DistrictModel> distInIndList = [];
//   List<FrroModel> frroList = [];
//   List<OwnerDetail> ownerDetList = [];
//   var ownerNameCtrlr = TextEditingController();
//   var ownerAddrCtrlr = TextEditingController();
//   var ownerPhnCtrlr = TextEditingController();
//   var ownerMblCtrlr = TextEditingController();
//   var ownerEmailCtrlr = TextEditingController();
//   bool dobFromOnchanged = false;
//   String nationality;
//   @override
//   void initState() {
//     super.initState();
//     FormCCommonServices.getAccotype().then((result) {
//       accotypeList = result;
//       ////print('state $stateList');
//     });
//     FormCCommonServices.getState().then((result) {
//       stateList = result;
//       ////print('state $stateList');
//     });
//     FormCCommonServices.getAccoGrade().then((result) {
//       accogradeList = result;
//       ////print('state $stateList');
//     });
//     FormCCommonServices.getAccotype().then((result) {
//       accotypeList = result;
//       ////print('state $stateList');
//     });
//     FormCCommonServices.getCountry().then((result) {
//       countryList = result;
//       ////print('state $stateList');
//     });
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }

//   saveAccomDetails() async {
//     var responseJson;
//     EasyLoading.show(status: 'Please Wait...');
//     var token = await HttpUtils().getToken();
//     var registeredUser = await HttpUtils().getUsername();
//     ////print('token: $token');
//     try {
//       var data = json.encode({
//         "userId": registeredUser,
//         "accomName": accodataObj.accomName,
//         "accomCapacity": accodataObj.accomCapacity,
//         "accomAddress": accodataObj.accomAddress,
//         "accomState": accodataObj.accomState,
//         "accomCityDist": accodataObj.accomCityDist,
//         "frroTypeCode": accodataObj.frroTypeCode,
//         "accomodationType": accodataObj.accomodationType,
//         "accomodationGrade": accodataObj.accomodationGrade,
//         "accomMobile": accodataObj.accomMobile,
//         "accomPhoneNum": accodataObj.accomPhoneNum,
//         "accomEmail": accodataObj.accomEmail,
//         "ownerDetails": ownerDetList,
//       });
//       //print('inside reg user $data');
//       ////print(GENERATE_APPLID);
//       await http.post(
//         Uri.parse(POST_ACCOM_DTS),
//         body: data,
//         headers: {
//           "Accept": "application/json",
//           "content-type": "application/json",
//           'Authorization': 'Bearer $token'
//         },
//       ).then((response) async {
//         // ////print(chkuser);
//         if (response.statusCode == 200) {
//           showDialog(
//               barrierDismissible: false,
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                     actions: [
//                       FlatButton(
//                         child: new Text('Ok',
//                             style: TextStyle(color: Colors.blue.shade500)),
//                         onPressed: () {
//                           Navigator.pushNamed(context, "/validateUser");
//                         },
//                       ),
//                     ],
//                     title: Column(children: [
//                       Text('Accomodator details saved successfully'),
//                     ]));
//               });
//         }
//         if (response.statusCode != 200) {
//           var result =
//               FormCCommonServices.getStatusCodeError(response.statusCode);

//           if (responseJson != null && responseJson["message"] != null) {
//             showDialog(
//                 barrierDismissible: false,
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                       actions: [
//                         FlatButton(
//                           child: new Text('Ok',
//                               style: TextStyle(color: Colors.blue.shade500)),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                       ],
//                       title: Column(children: [
//                         Text('${responseJson["message"]}'),
//                       ]));
//                 });
//           } else {
//             showDialog(
//                 barrierDismissible: false,
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                       actions: [
//                         FlatButton(
//                           child: new Text('Ok', style: TextStyle(color: blue)),
//                           onPressed: () {
//                             // Navigator.popAndPushNamed(
//                             //                   context, "/loginScreen");
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                       ],
//                       title: Column(children: [
//                         Text('$result'),
//                       ]));
//                 });
//           }
//         }
//       });
//     } catch (e) {
//       showDialog(
//           barrierDismissible: false,
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//                 actions: [
//                   FlatButton(
//                     child: new Text('Ok', style: TextStyle(color: blue)),
//                     onPressed: () {
//                       // Navigator.popAndPushNamed(
//                       //                   context, "/homeScreen");
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//                 title: Column(children: [
//                   Text('Something went wrong, Please try again later'),
//                 ]));
//           });
//     }

//     EasyLoading.dismiss();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     List<Step> steps = [
//       new Step(
//           isActive: true,
//           state: StepState.indexed,
//           content: FormBuilder(
//             key: formKeys[0],
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: LABELPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Gender *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: LABELPADDING, right: LABELPADDING, top: TOPPADDING),
//                   child: FormBuilderDropdown(
//                     initialValue: accodataObj.gender,
//                     decoration: InputDecoration(
//                       contentPadding:
//                           const EdgeInsets.symmetric(vertical: CONTENTPADDING),
//                       prefixIcon:
//                           Icon(Icons.location_history_sharp, color: blue),
//                       labelStyle: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                           fontSize: 16,
//                           letterSpacing: 1),
//                       //    labelText: 'Gender *',
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                     ),
//                     // initialValue: 'Male',
//                     allowClear: true,
//                     //   hint: Text('Select Gender'),
//                     validator: FormBuilderValidators.compose(
//                       [
//                         FormBuilderValidators.required(
//                           errorText: 'Required',
//                         )
//                       ],
//                     ),
//                     items: GENDERLIST
//                         .map((gender) => DropdownMenuItem(
//                               child: new Text(gender['gender_desc']),
//                               value: gender['gender_code'].toString(),
//                             ))
//                         .toList(),

//                     onChanged: (value) {
//                       FocusScope.of(context).requestFocus(FocusNode());
//                       accodataObj.gender = value;
//                     },
//                     name: 'gender',
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Date Of Birth *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(FIELDPADDING),
//                   child: FormBuilderDateTimePicker(
//                     firstDate: DateTime(DateTime.now().year - 100,
//                         DateTime.now().month, DateTime.now().day),
//                     lastDate: DateTime.now(),
//                     name: "dob",
//                     onChanged: (val) {
//                       setState(() {
//                         dobFromOnchanged = true;
//                       });
//                       if (val != null)
//                         accodataObj.dob = DateFormat("dd/MM/yyyy").format(val);
//                     },
//                     initialValue: (accodataObj.dob != null)
//                         ? (DateFormat("dd/MM/yyyy").parse(accodataObj.dob))
//                         : null,
//                     valueTransformer: (value) => (value != null)
//                         ? DateFormat("dd/MM/yyyy").format(value)
//                         : null,
//                     inputType: InputType.date,
//                     format: DateFormat("dd/MM/yyyy"),
//                     //  readOnly:  page1.dateOfBirth !=null ? true : false ,
//                     decoration: InputDecoration(
//                       contentPadding:
//                           const EdgeInsets.symmetric(vertical: CONTENTPADDING),
//                       prefixIcon: Icon(FontAwesome.calendar, color: blue),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                     ),
//                     validator: FormBuilderValidators.compose(
//                       [
//                         // ignore: missing_return
//                         (val) {
//                           if ((val == null || val == "")) {
//                             return 'Required';
//                           } else {
//                             return null;
//                           }
//                         }
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 15.0),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Designation *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Container(
//                     child: FormBuilderTextField(
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp(alphabetSpace))
//                       ],
//                       initialValue: accodataObj.designation,
//                       //name: "Name",
//                       maxLines: 1,
//                       maxLength: MAX_LENGTH_TEXTFIELD,
//                       onChanged: (field) {
//                         //print('inside username onchanges');
//                         accodataObj.designation = field;
//                         //print('Name ${accodataObj.accomName}');
//                       },
//                       //       textCapitalization: TextCapitalization.characters,
//                       textInputAction: TextInputAction.next,
//                       decoration: InputDecoration(
//                         // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
//                         contentPadding:
//                             const EdgeInsets.symmetric(vertical: 10.0),
//                         prefixIcon: Icon(Icons.person, color: blue),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         // labelText: 'Username',
//                         // hintText: 'Username',
//                         labelStyle: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       ),
//                       validator: FormBuilderValidators.compose(
//                         [
//                           FormBuilderValidators.required(
//                             errorText: 'Required',
//                           ),
//                         ],
//                       ),
//                       cursorColor: blue,
//                       name: 'design',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Phone Number *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(FIELDPADDING),
//                   child: FormBuilderTextField(
//                     initialValue: accodataObj.phone_no,
//                     keyboardType: TextInputType.number,
//                     onChanged: (value) {
//                       accodataObj.phone_no = value;
//                     },
//                     maxLength: MAX_LENGTH_MBL_PHN_NUM,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.allow(RegExp(phnNumbers))
//                     ],
//                     name: "phnNum",
//                     decoration: InputDecoration(
//                       contentPadding:
//                           const EdgeInsets.symmetric(vertical: CONTENTPADDING),
//                       prefixIcon: Icon(FontAwesome.phone_square, color: blue),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       //     labelText: 'Phone Number',
//                       labelStyle: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                           fontSize: 16,
//                           letterSpacing: 1),
//                     ),
//                     validator: FormBuilderValidators.compose(
//                       [
//                         FormBuilderValidators.numeric(),
//                         if (accodataObj.phone_no == null ||
//                             accodataObj.phone_no == "")
//                           FormBuilderValidators.required(errorText: 'Required')
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Nationality *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(FIELDPADDING),
//                   child: TypeAheadFormField(
//                     // enabled: isPptNatEditable,
//                     // hideKeyboard: isPptNatNonEditable,
//                     getImmediateSuggestions: false,
//                     textFieldConfiguration: TextFieldConfiguration(
//                       decoration: InputDecoration(
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: CONTENTPADDING),
//                         prefixIcon: Icon(Icons.location_on, color: blue),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         labelStyle: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                         //   contentPadding: EdgeInsets.all(15.0),
//                         suffixIcon: IconButton(
//                             icon: (nationality != null)
//                                 ? Icon(Icons.remove_circle)
//                                 : Icon(Icons.search),
//                             onPressed: () {
//                               setState(() {
//                                 nationality = null;
//                                 _nationalityController.clear();
//                               });
//                             }),
//                         //  contentPadding: EdgeInsets.all(10),
//                         //  labelText: 'Nationality',
//                         // border: OutlineInputBorder(
//                         //     borderRadius: BorderRadius.circular(10.0)),
//                       ),
//                       controller: _nationalityController,
//                     ),

//                     // //  attribute: 'nationality',
//                     // onSaved: (newVal) async {
//                     //   FocusScope.of(context).requestFocus(FocusNode());

//                     //   setState(() {
//                     //     personalDetailObj.nationality = newVal;
//                     //     nationality = newVal;
//                     //     // tempIdGeneration.nationality = newVal.countrycode;
//                     //     //  _controller.text = country;

//                     //     //  print(newVal.countrycode);
//                     //     // final index = country.indexWhere(
//                     //     //     (element) => element['country_name'] == newVal);
//                     //     // print(-index);

//                     //     // print(
//                     //     //     'Using indexWhere: ${country[-index]['country_code']}');
//                     //   });
//                     // },
//                     // selectionToTextTransformer:
//                     //     (CountryModel countryModel) {
//                     //   return countryModel.countryname;
//                     // },
//                     // initialValue: new CountryModel(),
//                     itemBuilder: (context, countryModel) {
//                       return ListTile(
//                         title: Text(
//                           countryModel.countryname,
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 17,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         tileColor: blue,
//                       );
//                     },

//                     validator: FormBuilderValidators.compose(
//                       [
//                         FormBuilderValidators.required(
//                           errorText: 'Required',
//                         ),
//                         (value) {
//                           if (accodataObj.nationality == null ||
//                               accodataObj.nationality == "") {
//                             return "Select from suggestions only";
//                           }
//                           return null;
//                         }
//                       ],
//                     ),
//                     suggestionsCallback: (query) {
//                       if (query.isNotEmpty) {
//                         var lowercaseQuery = query.toLowerCase();
//                         return countryList.where((country) {
//                           return country.countryname
//                               .toLowerCase()
//                               .contains(query.toLowerCase());
//                         }).toList(growable: false)
//                           ..sort((a, b) => a.countryname
//                               .toLowerCase()
//                               .indexOf(lowercaseQuery)
//                               .compareTo(b.countryname
//                                   .toLowerCase()
//                                   .indexOf(lowercaseQuery)));
//                       } else {
//                         return countryList
//                           ..sort((a, b) => a.countryname
//                               .toLowerCase()
//                               .compareTo(b.countryname.toLowerCase()));
//                       }
//                     },
//                     onSuggestionSelected: (CountryModel suggestion) {
//                       _nationalityController.text = suggestion.countryname;
//                       nationality = suggestion.countrycode;
//                       accodataObj.nationality = suggestion.countrycode;
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           title: Text('')),
//       new Step(
//           isActive: true,
//           state: StepState.indexed,
//           content: FormBuilder(
//             key: formKeys[1],
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 15.0),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Name *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Container(
//                     child: FormBuilderTextField(
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp(alphabetSpace))
//                       ],
//                       initialValue: accodataObj.accomName,
//                       //name: "Name",
//                       maxLines: 1,
//                       maxLength: MAX_LENGTH_TEXTFIELD,
//                       onChanged: (field) {
//                         //print('inside username onchanges');
//                         accodataObj.accomName = field;
//                         //print('Name ${accodataObj.accomName}');
//                       },
//                       //       textCapitalization: TextCapitalization.characters,
//                       textInputAction: TextInputAction.next,
//                       decoration: InputDecoration(
//                         // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
//                         contentPadding:
//                             const EdgeInsets.symmetric(vertical: 10.0),
//                         prefixIcon: Icon(Icons.person, color: blue),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         // labelText: 'Username',
//                         // hintText: 'Username',
//                         labelStyle: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       ),
//                       validator: FormBuilderValidators.compose(
//                         [
//                           FormBuilderValidators.required(
//                             errorText: 'Required',
//                           ),
//                         ],
//                       ),
//                       cursorColor: blue,
//                       name: 'name',
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Capacity *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Container(
//                     child: FormBuilderTextField(
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp(numbers))
//                       ],
//                       initialValue: accodataObj.accomCapacity,
//                       //name: "Name",
//                       maxLines: 1,
//                       maxLength: MAX_LENGTH_TEXTFIELD,
//                       onChanged: (field) {
//                         //print('inside username onchanges');
//                         accodataObj.accomCapacity = field;
//                       },
//                       //       textCapitalization: TextCapitalization.characters,
//                       textInputAction: TextInputAction.next,
//                       decoration: InputDecoration(
//                         // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
//                         contentPadding:
//                             const EdgeInsets.symmetric(vertical: 10.0),
//                         prefixIcon: Icon(Icons.person, color: blue),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         // labelText: 'Username',
//                         // hintText: 'Username',
//                         labelStyle: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       ),
//                       validator: FormBuilderValidators.compose(
//                         [
//                           FormBuilderValidators.required(
//                             errorText: 'Required',
//                           ),
//                         ],
//                       ),
//                       cursorColor: blue,
//                       name: 'capacity',
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Address *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(FIELDPADDING),
//                   child: Container(
//                     child: FormBuilderTextField(
//                       initialValue: accodataObj.accomAddress,
//                       cursorColor: blue,
//                       name: "addressOutsideIndia",
//                       maxLines: 1,
//                       maxLength: MAX_LENGTH_ADDRESS,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(
//                             RegExp(alphaNumSpaceSpecial))
//                       ],
//                       onChanged: (field) {
//                         accodataObj.accomAddress = field;
//                         //   FocusScope.of(context).nextFocus();
//                       },
//                       textCapitalization: TextCapitalization.characters,
//                       textInputAction: TextInputAction.next,
//                       decoration: InputDecoration(
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: CONTENTPADDING),
//                         prefixIcon: Icon(Icons.location_city, color: blue),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         // border: OutlineInputBorder(
//                         //     borderRadius: BorderRadius.circular(10.0)),
//                         // labelText:
//                         //     'Address *',
//                         labelStyle: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       ),
//                       validator: FormBuilderValidators.compose(
//                         [
//                           FormBuilderValidators.required(
//                             errorText: 'Required',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'State *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10, bottom: 10),
//                   child: TypeAheadFormField(
//                     validator: FormBuilderValidators.compose(
//                       [
//                         FormBuilderValidators.required(
//                           errorText: 'Required',
//                         ),
//                       ],
//                     ),
//                     getImmediateSuggestions: false,
//                     textFieldConfiguration: TextFieldConfiguration(
//                       controller: _accoState,
//                       decoration: InputDecoration(
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: CONTENTPADDING),
//                         prefixIcon:
//                             Icon(Icons.location_city_rounded, color: blue),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         labelStyle: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                         //   contentPadding: EdgeInsets.all(15.0),
//                         suffixIcon: IconButton(
//                             icon: (accodataObj.accomState != null)
//                                 ? Icon(Icons.remove_circle)
//                                 : Icon(Icons.search),
//                             onPressed: () {
//                               setState(() {
//                                 //    page1.froState = null;
//                                 accodataObj.accomState = null;
//                               });
//                             }),
//                         // contentPadding: EdgeInsets.all(10),
//                         //    labelText: 'Next Destination State',
//                         // border: OutlineInputBorder(
//                         //     borderRadius: BorderRadius.circular(10.0)),
//                       ),
//                     ),

//                     //cursorColor: blue,
//                     // name: 'nextDestStateInInd',

//                     // selectionToTextTransformer: (StateModel stateModel) {
//                     //   return stateModel.statename;
//                     // },
//                     // initialValue: new StateModel(),
//                     itemBuilder: (context, stateModel) {
//                       return ListTile(
//                         title: Text(
//                           stateModel.statename,
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 17,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         tileColor: blue,
//                       );
//                     },

//                     suggestionsCallback: (query) {
//                       if (query.isNotEmpty) {
//                         var lowercaseQuery = query.toLowerCase();
//                         return stateList.where((state) {
//                           return state.statename
//                               .toLowerCase()
//                               .contains(query.toLowerCase());
//                         }).toList(growable: false)
//                           ..sort((a, b) => a.statename
//                               .toLowerCase()
//                               .indexOf(lowercaseQuery)
//                               .compareTo(b.statename
//                                   .toLowerCase()
//                                   .indexOf(lowercaseQuery)));
//                       } else {
//                         return stateList
//                           ..sort((a, b) => a.statename
//                               .toLowerCase()
//                               .compareTo(b.statename.toLowerCase()));
//                       }
//                     },
//                     onSuggestionSelected: (StateModel suggestion) {
//                       FocusScope.of(context).requestFocus(FocusNode());
//                       //page1.froState = newVal.statecode;
//                       setState(() {
//                         //  page1.froState = newVal.statecode;
//                         accodataObj.accomCityDist = null;

//                         accodataObj.accomState = suggestion.statecode;
//                         _accoState.text = suggestion.statename;
//                         FormCCommonServices.getDistrict(accodataObj.accomState)
//                             .then((result) {
//                           setState(() {
//                             distInIndList = result;
//                           });
//                         });
//                         //  _controller.text = country;

//                         //  ////print(newVal.countrycode);
//                         // final index = country.indexWhere(
//                         //     (element) => element['country_name'] == newVal);
//                         // ////print(-index);

//                         // ////print(
//                         //     'Using indexWhere: ${country[-index]['country_code']}');
//                       });
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'City *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(FIELDPADDING),
//                   child: FormBuilderDropdown(
//                     validator: FormBuilderValidators.compose(
//                       [
//                         FormBuilderValidators.required(
//                           errorText: 'Required',
//                         ),
//                       ],
//                     ),
//                     initialValue: accodataObj.accomCityDist,

//                     decoration: InputDecoration(
//                       contentPadding:
//                           const EdgeInsets.symmetric(vertical: CONTENTPADDING),
//                       prefixIcon: Icon(Icons.location_city, color: blue),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       labelStyle: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                           fontSize: 16,
//                           letterSpacing: 1),
//                       // labelText: 'District',
//                       // border: OutlineInputBorder(
//                       //     borderRadius: BorderRadius.circular(12),
//                       //     borderSide: BorderSide(color: Colors.red)),
//                     ),
//                     // initialValue: 'Male',
//                     allowClear: true,

//                     //   hint: Text('Select Gender'),

//                     items: distInIndList
//                         .map((district) => DropdownMenuItem(
//                               child: new Text(district.districtname),
//                               value: district.districtcode.toString(),
//                             ))
//                         .toList(),

//                     name: 'anyOtherDist',
//                     onChanged: (value) {
//                       accodataObj.accomCityDist = value;
//                       accodataObj.frroTypeCode = null;
//                       FormCCommonServices.getFrro(
//                               accodataObj.accomState, accodataObj.accomCityDist)
//                           .then((result) {
//                         setState(() {
//                           frroList = result;
//                         });
//                       });
//                       FocusScope.of(context).requestFocus(FocusNode());
//                       //     tempIdGeneration.gender = value;
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Frro/Fro Description *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(FIELDPADDING),
//                   child: FormBuilderDropdown(
//                     validator: FormBuilderValidators.compose(
//                       [
//                         FormBuilderValidators.required(
//                           errorText: 'Required',
//                         ),
//                       ],
//                     ),
//                     initialValue: accodataObj.frroTypeCode,

//                     decoration: InputDecoration(
//                       contentPadding:
//                           const EdgeInsets.symmetric(vertical: CONTENTPADDING),
//                       prefixIcon: Icon(Icons.location_city, color: blue),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       labelStyle: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                           fontSize: 16,
//                           letterSpacing: 1),
//                       // labelText: 'Frro/Fro',
//                       // border: OutlineInputBorder(
//                       //     borderRadius: BorderRadius.circular(12),
//                       //     borderSide: BorderSide(color: Colors.red)),
//                     ),
//                     // initialValue: 'Male',
//                     allowClear: true,

//                     //   hint: Text('Select Gender'),

//                     items: frroList
//                         .map((frro) => DropdownMenuItem(
//                               child: new Text(frro.frroFroDesc),
//                               value: frro.frroFroCode.toString(),
//                             ))
//                         .toList(),

//                     name: 'frrodesc',
//                     onChanged: (value) {
//                       accodataObj.frroTypeCode = value;

//                       FocusScope.of(context).requestFocus(FocusNode());
//                       //     tempIdGeneration.gender = value;
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Accomodation Type *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(FIELDPADDING),
//                   child: FormBuilderDropdown(
//                     validator: FormBuilderValidators.compose(
//                       [
//                         FormBuilderValidators.required(
//                           errorText: 'Required',
//                         ),
//                       ],
//                     ),
//                     initialValue: accodataObj.accomodationType,

//                     decoration: InputDecoration(
//                       contentPadding:
//                           const EdgeInsets.symmetric(vertical: CONTENTPADDING),
//                       prefixIcon: Icon(Icons.location_city, color: blue),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       labelStyle: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                           fontSize: 16,
//                           letterSpacing: 1),
//                       // labelText: 'Accomodationtype',
//                       // border: OutlineInputBorder(
//                       //     borderRadius: BorderRadius.circular(12),
//                       //     borderSide: BorderSide(color: Colors.red)),
//                     ),
//                     // initialValue: 'Male',
//                     allowClear: true,

//                     //   hint: Text('Select Gender'),

//                     items: accotypeList
//                         .map((accotype) => DropdownMenuItem(
//                               child: new Text(accotype.accTypeName),
//                               value: accotype.accTypeCode.toString(),
//                             ))
//                         .toList(),

//                     name: 'accotype',
//                     onChanged: (value) {
//                       accodataObj.accomodationType = value;

//                       FocusScope.of(context).requestFocus(FocusNode());
//                       //     tempIdGeneration.gender = value;
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Accomodation Grade *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(FIELDPADDING),
//                   child: FormBuilderDropdown(
//                     validator: FormBuilderValidators.compose(
//                       [
//                         FormBuilderValidators.required(
//                           errorText: 'Required',
//                         ),
//                       ],
//                     ),
//                     initialValue: accodataObj.accomodationGrade,

//                     decoration: InputDecoration(
//                       contentPadding:
//                           const EdgeInsets.symmetric(vertical: CONTENTPADDING),
//                       prefixIcon: Icon(Icons.location_city, color: blue),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       labelStyle: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                           fontSize: 16,
//                           letterSpacing: 1),
//                       // labelText: 'Accomodation Grade',
//                       // border: OutlineInputBorder(
//                       //     borderRadius: BorderRadius.circular(12),
//                       //     borderSide: BorderSide(color: Colors.red)),
//                     ),
//                     // initialValue: 'Male',
//                     allowClear: true,

//                     //   hint: Text('Select Gender'),

//                     items: accogradeList
//                         .map((district) => DropdownMenuItem(
//                               child: new Text(district.accoGradeDesc),
//                               value: district.accoGrade.toString(),
//                             ))
//                         .toList(),

//                     name: 'accograde',
//                     onChanged: (value) {
//                       accodataObj.accomodationGrade = value;

//                       FocusScope.of(context).requestFocus(FocusNode());
//                       //     tempIdGeneration.gender = value;
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Mobile Number *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(FIELDPADDING),
//                   child: FormBuilderTextField(
//                     initialValue: accodataObj.accomMobile,
//                     keyboardType: TextInputType.number,
//                     maxLength: 15,
//                     onChanged: (value) {
//                       accodataObj.accomMobile = value;
//                     },
//                     inputFormatters: [
//                       FilteringTextInputFormatter.allow(RegExp(phnNumbers))
//                     ],
//                     cursorColor: blue,
//                     name: "mblNum",
//                     decoration: InputDecoration(
//                       contentPadding:
//                           const EdgeInsets.symmetric(vertical: CONTENTPADDING),
//                       prefixIcon: Icon(FontAwesome.mobile_phone, color: blue),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       //      labelText: 'Mobile Number',
//                       labelStyle: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                           fontSize: 16,
//                           letterSpacing: 1),
//                     ),
//                     validator: FormBuilderValidators.compose(
//                       [
//                         FormBuilderValidators.numeric(),
//                         FormBuilderValidators.required(
//                           errorText: 'Required',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Phone Number *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(FIELDPADDING),
//                   child: FormBuilderTextField(
//                     initialValue: accodataObj.accomPhoneNum,
//                     keyboardType: TextInputType.number,
//                     onChanged: (value) {
//                       accodataObj.accomPhoneNum = value;
//                     },
//                     maxLength: 15,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.allow(RegExp(phnNumbers))
//                     ],
//                     cursorColor: blue,
//                     name: "phnNumInInd",
//                     decoration: InputDecoration(
//                       contentPadding:
//                           const EdgeInsets.symmetric(vertical: CONTENTPADDING),
//                       prefixIcon: Icon(FontAwesome.phone, color: blue),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       // labelText: 'Phone Number In India',
//                       labelStyle: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                           fontSize: 16,
//                           letterSpacing: 1),
//                     ),
//                     validator: FormBuilderValidators.compose(
//                       [
//                         FormBuilderValidators.numeric(),
//                         FormBuilderValidators.required(
//                           errorText: 'Required',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Email Id *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Container(
//                     child: FormBuilderTextField(
//                       // inputFormatters: [
//                       //   FilteringTextInputFormatter.allow(RegExp(alphabetSpace))
//                       // ],
//                       initialValue: accodataObj.accomEmail,
//                       //name: "Name",
//                       maxLines: 1,
//                       maxLength: MAX_LENGTH_TEXTFIELD,
//                       onChanged: (field) {
//                         //print('inside username onchanges');
//                         accodataObj.accomEmail = field;
//                         //print('Name ${accodataObj.accomName}');
//                       },
//                       //       textCapitalization: TextCapitalization.characters,
//                       textInputAction: TextInputAction.next,
//                       decoration: InputDecoration(
//                         // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
//                         contentPadding:
//                             const EdgeInsets.symmetric(vertical: 10.0),
//                         prefixIcon: Icon(Icons.person, color: blue),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         // labelText: 'Username',
//                         // hintText: 'Username',
//                         labelStyle: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       ),
//                       validator: FormBuilderValidators.compose(
//                         [
//                           FormBuilderValidators.required(
//                             errorText: 'Required',
//                           ),
//                         ],
//                       ),
//                       cursorColor: blue,
//                       name: 'name',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           title: Text('Hotel Information')),
//       new Step(
//           isActive: true,
//           state: StepState.indexed,
//           content: FormBuilder(
//             key: formKeys[2],
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Name *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Container(
//                     child: FormBuilderTextField(
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp(alphabetSpace))
//                       ],
//                       //  initialValue: multipleOwnerObj.name,
//                       controller: ownerNameCtrlr,
//                       //name: "Name",
//                       maxLines: 1,
//                       maxLength: MAX_LENGTH_TEXTFIELD,

//                       onSubmitted: (field) {
//                         multipleOwnerObj.name = field;
//                         //print('name owner ${multipleOwnerObj.name}');
//                         ownerNameCtrlr.text = field;
//                       },
//                       //       textCapitalization: TextCapitalization.characters,
//                       textInputAction: TextInputAction.next,
//                       decoration: InputDecoration(
//                         // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
//                         contentPadding:
//                             const EdgeInsets.symmetric(vertical: 10.0),
//                         prefixIcon: Icon(Icons.person, color: blue),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         // labelText: 'Username',
//                         // hintText: 'Username',
//                         labelStyle: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       ),
//                       validator: FormBuilderValidators.compose(
//                         [
//                           FormBuilderValidators.required(
//                             errorText: 'Required',
//                           ),
//                         ],
//                       ),
//                       cursorColor: blue,
//                       name: 'ownerName',
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Address *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Container(
//                     child: FormBuilderTextField(
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(
//                             RegExp(alphaNumSpaceSpecial))
//                       ],
//                       // initialValue: multipleOwnerObj.address,
//                       controller: ownerAddrCtrlr,
//                       //name: "Name",
//                       maxLines: 1,
//                       maxLength: MAX_LENGTH_TEXTFIELD,
//                       onSubmitted: (field) {
//                         multipleOwnerObj.address = field;
//                         ownerAddrCtrlr.text = field;
//                       },
//                       //       textCapitalization: TextCapitalization.characters,
//                       textInputAction: TextInputAction.next,
//                       decoration: InputDecoration(
//                         // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
//                         contentPadding:
//                             const EdgeInsets.symmetric(vertical: 10.0),
//                         prefixIcon: Icon(Icons.person, color: blue),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         // labelText: 'Username',
//                         // hintText: 'Username',
//                         labelStyle: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       ),
//                       validator: FormBuilderValidators.compose(
//                         [
//                           FormBuilderValidators.required(
//                             errorText: 'Required',
//                           ),
//                         ],
//                       ),
//                       cursorColor: blue,
//                       name: 'ownerAddr',
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'State *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10, bottom: 10),
//                   child: TypeAheadFormField(
//                     validator: FormBuilderValidators.compose(
//                       [
//                         FormBuilderValidators.required(
//                           errorText: 'Required',
//                         ),
//                       ],
//                     ),
//                     getImmediateSuggestions: false,
//                     textFieldConfiguration: TextFieldConfiguration(
//                       controller: _ownerState,
//                       decoration: InputDecoration(
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: CONTENTPADDING),
//                         prefixIcon:
//                             Icon(Icons.location_city_rounded, color: blue),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         labelStyle: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                         //   contentPadding: EdgeInsets.all(15.0),
//                         suffixIcon: IconButton(
//                             icon: (multipleOwnerObj.state != null)
//                                 ? Icon(Icons.remove_circle)
//                                 : Icon(Icons.search),
//                             onPressed: () {
//                               setState(() {
//                                 //    page1.froState = null;
//                                 multipleOwnerObj.state = null;
//                               });
//                             }),
//                         // contentPadding: EdgeInsets.all(10),
//                         //    labelText: 'Next Destination State',
//                         // border: OutlineInputBorder(
//                         //     borderRadius: BorderRadius.circular(10.0)),
//                       ),
//                     ),

//                     //cursorColor: blue,
//                     // name: 'nextDestStateInInd',

//                     // selectionToTextTransformer: (StateModel stateModel) {
//                     //   return stateModel.statename;
//                     // },
//                     // initialValue: new StateModel(),
//                     itemBuilder: (context, stateModel) {
//                       return ListTile(
//                         title: Text(
//                           stateModel.statename,
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 17,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         tileColor: blue,
//                       );
//                     },

//                     suggestionsCallback: (query) {
//                       if (query.isNotEmpty) {
//                         var lowercaseQuery = query.toLowerCase();
//                         return stateList.where((state) {
//                           return state.statename
//                               .toLowerCase()
//                               .contains(query.toLowerCase());
//                         }).toList(growable: false)
//                           ..sort((a, b) => a.statename
//                               .toLowerCase()
//                               .indexOf(lowercaseQuery)
//                               .compareTo(b.statename
//                                   .toLowerCase()
//                                   .indexOf(lowercaseQuery)));
//                       } else {
//                         return stateList
//                           ..sort((a, b) => a.statename
//                               .toLowerCase()
//                               .compareTo(b.statename.toLowerCase()));
//                       }
//                     },
//                     onSuggestionSelected: (StateModel suggestion) {
//                       FocusScope.of(context).requestFocus(FocusNode());
//                       //page1.froState = newVal.statecode;

//                       setState(() {
//                         //  page1.froState = newVal.statecode;
//                         multipleOwnerObj.city = null;

//                         multipleOwnerObj.state = suggestion.statecode;
//                         _ownerState.text = suggestion.statename;
//                         FormCCommonServices.getDistrict(multipleOwnerObj.state)
//                             .then((result) {
//                           setState(() {
//                             distInIndList = result;
//                             //print('dist to load $distInIndList');
//                           });
//                         });
//                         //  _controller.text = country;

//                         //  ////print(newVal.countrycode);
//                         // final index = country.indexWhere(
//                         //     (element) => element['country_name'] == newVal);
//                         // ////print(-index);

//                         // ////print(
//                         //     'Using indexWhere: ${country[-index]['country_code']}');
//                       });
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'City *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10, bottom: 10),
//                   child: TypeAheadFormField(
//                     validator: FormBuilderValidators.compose(
//                       [
//                         FormBuilderValidators.required(
//                           errorText: 'Required',
//                         ),
//                       ],
//                     ),
//                     getImmediateSuggestions: false,
//                     textFieldConfiguration: TextFieldConfiguration(
//                       controller: _ownerCity,
//                       decoration: InputDecoration(
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: CONTENTPADDING),
//                         prefixIcon:
//                             Icon(Icons.location_city_rounded, color: blue),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         labelStyle: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                         //   contentPadding: EdgeInsets.all(15.0),
//                         suffixIcon: IconButton(
//                             icon: (multipleOwnerObj.city != null)
//                                 ? Icon(Icons.remove_circle)
//                                 : Icon(Icons.search),
//                             onPressed: () {
//                               setState(() {
//                                 //    page1.froState = null;
//                                 multipleOwnerObj.city = null;
//                               });
//                             }),
//                         // contentPadding: EdgeInsets.all(10),
//                         //    labelText: 'Next Destination State',
//                         // border: OutlineInputBorder(
//                         //     borderRadius: BorderRadius.circular(10.0)),
//                       ),
//                     ),

//                     //cursorColor: blue,
//                     // name: 'nextDestStateInInd',

//                     // selectionToTextTransformer: (StateModel stateModel) {
//                     //   return stateModel.statename;
//                     // },
//                     // initialValue: new StateModel(),
//                     itemBuilder: (context, districtModel) {
//                       return ListTile(
//                         title: Text(
//                           districtModel.districtname,
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 17,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         tileColor: blue,
//                       );
//                     },

//                     suggestionsCallback: (query) {
//                       if (query.isNotEmpty) {
//                         var lowercaseQuery = query.toLowerCase();
//                         return distInIndList.where((district) {
//                           return district.districtname
//                               .toLowerCase()
//                               .contains(query.toLowerCase());
//                         }).toList(growable: false)
//                           ..sort((a, b) => a.districtname
//                               .toLowerCase()
//                               .indexOf(lowercaseQuery)
//                               .compareTo(b.districtname
//                                   .toLowerCase()
//                                   .indexOf(lowercaseQuery)));
//                       } else {
//                         return distInIndList
//                           ..sort((a, b) => a.districtname
//                               .toLowerCase()
//                               .compareTo(b.districtname.toLowerCase()));
//                       }
//                     },
//                     onSuggestionSelected: (DistrictModel suggestion) {
//                       FocusScope.of(context).requestFocus(FocusNode());
//                       //page1.froState = newVal.statecode;

//                       setState(() {
//                         //  page1.froState = newVal.statecode;
//                         multipleOwnerObj.city = suggestion.districtcode;

//                         _ownerCity.text = suggestion.districtname;
//                       });
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Email Id *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Container(
//                     child: FormBuilderTextField(
//                       // inputFormatters: [
//                       //   FilteringTextInputFormatter.allow(RegExp(alphabetSpace))
//                       // ],
//                       // initialValue: multipleOwnerObj.emailId,
//                       controller: ownerEmailCtrlr,
//                       //name: "Name",
//                       maxLines: 1,
//                       maxLength: MAX_LENGTH_TEXTFIELD,
//                       onSubmitted: (field) {
//                         multipleOwnerObj.emailId = field;
//                       },
//                       //       textCapitalization: TextCapitalization.characters,
//                       textInputAction: TextInputAction.next,
//                       decoration: InputDecoration(
//                         // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
//                         contentPadding:
//                             const EdgeInsets.symmetric(vertical: 10.0),
//                         prefixIcon: Icon(Icons.person, color: blue),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 2, color: blue),
//                             borderRadius: BorderRadius.circular(10.0)),
//                         // labelText: 'Username',
//                         // hintText: 'Username',
//                         labelStyle: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       ),
//                       validator: FormBuilderValidators.compose(
//                         [
//                           FormBuilderValidators.required(
//                             errorText: 'Required',
//                           ),
//                         ],
//                       ),
//                       cursorColor: blue,
//                       name: 'ownerEmail',
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Mobile Number *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(FIELDPADDING),
//                   child: FormBuilderTextField(
//                     // initialValue: multipleOwnerObj.mobile,
//                     controller: ownerMblCtrlr,
//                     keyboardType: TextInputType.number,
//                     maxLength: 15,
//                     onSubmitted: (value) {
//                       multipleOwnerObj.mobile = value;
//                     },
//                     inputFormatters: [
//                       FilteringTextInputFormatter.allow(RegExp(phnNumbers))
//                     ],
//                     cursorColor: blue,
//                     name: "ownerMblnum",
//                     decoration: InputDecoration(
//                       contentPadding:
//                           const EdgeInsets.symmetric(vertical: CONTENTPADDING),
//                       prefixIcon: Icon(FontAwesome.mobile_phone, color: blue),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       //      labelText: 'Mobile Number',
//                       labelStyle: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                           fontSize: 16,
//                           letterSpacing: 1),
//                     ),
//                     validator: FormBuilderValidators.compose(
//                       [
//                         FormBuilderValidators.numeric(),
//                         FormBuilderValidators.required(
//                           errorText: 'Required',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: FIELDPADDING),
//                   child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Phone Number *',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontSize: 16,
//                             letterSpacing: 1),
//                       )),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(FIELDPADDING),
//                   child: FormBuilderTextField(
//                     // initialValue: multipleOwnerObj.phoneNum,
//                     controller: ownerPhnCtrlr,
//                     keyboardType: TextInputType.number,
//                     onSubmitted: (value) {
//                       multipleOwnerObj.phoneNum = value;
//                     },
//                     maxLength: 15,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.allow(RegExp(phnNumbers))
//                     ],
//                     cursorColor: blue,
//                     name: "ownerPhn",
//                     decoration: InputDecoration(
//                       contentPadding:
//                           const EdgeInsets.symmetric(vertical: CONTENTPADDING),
//                       prefixIcon: Icon(FontAwesome.phone, color: blue),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 2, color: blue),
//                           borderRadius: BorderRadius.circular(10.0)),
//                       // labelText: 'Phone Number In India',
//                       labelStyle: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                           fontSize: 16,
//                           letterSpacing: 1),
//                     ),
//                     validator: FormBuilderValidators.compose(
//                       [
//                         FormBuilderValidators.numeric(),
//                         FormBuilderValidators.required(
//                           errorText: 'Required',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 50),
//                   child: RaisedButton(
//                       child: Text('Add'),
//                       onPressed: () {
//                         //print('inside accept');
//                         setState(() {
//                           {
//                             if (formKeys[1].currentState.validate()) {
//                               formKeys[1].currentState.save();
//                               ownerDetList.add(OwnerDetail(
//                                 name: ownerNameCtrlr.text,
//                                 address: ownerAddrCtrlr.text,
//                                 state: multipleOwnerObj.state,
//                                 city: multipleOwnerObj.city,
//                                 emailId: ownerEmailCtrlr.text,
//                                 mobile: ownerMblCtrlr.text,
//                                 phoneNum: ownerPhnCtrlr.text,
//                               ));
//                               //print(
//                               // 'owner name in list 1 ${ownerDetList[0].name}');

//                               ownerNameCtrlr.clear();
//                               ownerNameCtrlr.text = "";
//                               ownerAddrCtrlr.clear();
//                               ownerAddrCtrlr.text = "";
//                               ownerEmailCtrlr.clear();
//                               ownerEmailCtrlr.text = "";
//                               ownerMblCtrlr.clear();
//                               ownerMblCtrlr.text = "";
//                               ownerPhnCtrlr.clear();
//                               ownerPhnCtrlr.text = "";
//                               _ownerState.clear();
//                               _ownerState.text = "";
//                               _ownerCity.clear();
//                               _ownerCity.text = "";
//                               // multipleOwnerObj.city = '';
//                               ////print('details $ownerDetList');
//                             } else {
//                               showDialog(
//                                   barrierDismissible: false,
//                                   context: context,
//                                   builder: (context) {
//                                     return AlertDialog(
//                                         actions: [
//                                           FlatButton(
//                                             child: new Text('Ok',
//                                                 style: TextStyle(
//                                                     color:
//                                                         Colors.blue.shade500)),
//                                             onPressed: () {
//                                               Navigator.of(context).pop();
//                                             },
//                                           ),
//                                         ],
//                                         title: Column(children: [
//                                           Text('Enter Owner Details'),
//                                         ]));
//                                   });
//                             }
//                           }
//                         });
//                       }),
//                 ),
//                 if (ownerDetList.length > 0)
//                   ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: ownerDetList.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Card(
//                           child: ListTile(
//                         title: Column(
//                           children: [
//                             Align(
//                               alignment: Alignment.topLeft,
//                               child: Text(
//                                 'Owner Detail ${index + 1}',
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             Align(
//                                 alignment: Alignment.topLeft,
//                                 child:
//                                     Text('Name: ${ownerDetList[index].name}')),
//                             Align(
//                                 alignment: Alignment.topLeft,
//                                 child: Text(
//                                     'Address: ${ownerDetList[index].address}')),
//                             Align(
//                                 alignment: Alignment.topLeft,
//                                 child: Text(
//                                     'Mobile: ${ownerDetList[index].mobile}'))
//                           ],
//                         ),
//                         trailing: IconButton(
//                           icon: Icon(
//                             Icons.delete,
//                           ),
//                           iconSize: 35,
//                           color: blue,
//                           splashColor: Colors.red,
//                           onPressed: () {
//                             showDialog(
//                                 context: context,
//                                 builder: (context) {
//                                   return AlertDialog(
//                                     title: Text(
//                                         'Do you want to delete the record ?'),
//                                     //    content: Text('Thank You For Submission'),
//                                     actions: [
//                                       FlatButton(
//                                         child: new Text('No',
//                                             style: TextStyle(
//                                                 color: Colors.blue.shade500)),
//                                         onPressed: () {
//                                           Navigator.of(context).pop();
//                                         },
//                                       ),
//                                       FlatButton(
//                                         child: new Text('Yes',
//                                             style: TextStyle(
//                                                 color: Colors.blue.shade500)),
//                                         onPressed: () {
//                                           ////print('i value $index');
//                                           Navigator.of(context).pop();
//                                           ////print('i value $index');
//                                           setState(() {
//                                             ownerDetList.removeAt(index);
//                                           });
//                                         },
//                                       ),
//                                     ],
//                                   );
//                                 });
//                           },
//                         ),
//                       ));
//                     },
//                   ),
//               ],
//             ),
//           ),
//           title: Text('Hotel Owner Details'))
//     ];
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(80.0), // here the desired height
//           child: AppBar(
//             backgroundColor: blue,
//             leading: Container(),
//             title: Text('Form C'),
//             actions: <Widget>[
//               IconButton(
//                 tooltip: 'Login Page',
//                 icon: Icon(Icons.exit_to_app),
//                 onPressed: () {
//                   Navigator.pushNamed(context, "/validateUser");
//                 },
//               ),
//             ],
//             centerTitle: true,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(
//                 bottom: Radius.circular(50),
//               ),
//             ),
//           ),
//         ),
//         body: new SingleChildScrollView(
//           physics: AlwaysScrollableScrollPhysics(),
//           child: FormBuilder(
//             key: _formKey,
//             child: Column(children: <Widget>[
//               Theme(
//                 data: ThemeData(
//                     accentColor: blue,
//                     colorScheme: ColorScheme.light(primary: blue)),
//                 child: new Stepper(
//                   physics: NeverScrollableScrollPhysics(),
//                   steps: steps,
//                   type: StepperType.vertical,
//                   currentStep: this.currStep,
//                   onStepContinue: () {
//                     setState(() {
//                       if (formKeys[currStep].currentState.validate()) {
//                         if (currStep < steps.length - 1) {
//                           currStep = currStep + 1;
//                         } else {
//                           currStep = 0;
//                         }
//                       }
//                     });
//                   },
//                   onStepCancel: () {
//                     setState(() {
//                       if (currStep > 0) {
//                         currStep = currStep - 1;
//                       } else {
//                         currStep = 0;
//                       }
//                     });
//                   },
//                   // onStepTapped: (step) {
//                   //   setState(() {
//                   //     currStep = step;
//                   //   });
//                   // },
//                 ),
//               ),
//               new RaisedButton(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: new BorderRadius.circular(18.0),
//                 ),
//                 child: new Text(
//                   'Submit Accomodator Details',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () {
//                   if (formKeys[0].currentState.validate() &&
//                       formKeys[1].currentState.validate()) {
//                     //print('form is valid');
//                     saveAccomDetails();
//                   } else {
//                     showDialog(
//                         barrierDismissible: false,
//                         context: context,
//                         builder: (context) {
//                           return AlertDialog(
//                               actions: [
//                                 FlatButton(
//                                   child: new Text('Ok',
//                                       style: TextStyle(
//                                           color: Colors.blue.shade500)),
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                 ),
//                               ],
//                               title: Column(children: [
//                                 Text('Enter Mandatory Fields'),
//                               ]));
//                         });
//                     //print('Form is invalid');
//                   }
//                 },
//                 color: blue,
//               ),
//             ]),
//           ),
//         ),
//       ),
//     );
//   }

//   _submitDetails() {
//     ////print('calling accompanying input');
//     return;
//   }
// }
