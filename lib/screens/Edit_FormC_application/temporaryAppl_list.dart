import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:formc_showcase/models/pendingAndSubmittedListModel.dart.dart';
import 'package:formc_showcase/util/spUtil.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:formc_showcase/services/formC_commonServices.dart';
import 'package:formc_showcase/screens/checkIn/form1_applicationGeneration.dart';
import 'package:shimmer/shimmer.dart';
import 'package:formc_showcase/Widgets/myShimmerEffectUi.dart';

class TemporaryFormCApplications extends StatefulWidget {
  TemporaryFormCApplications();
  var passportNumber, nationality;
  TemporaryFormCApplications.throughSearch(
      this.passportNumber, this.nationality);

  @override
  _TemporaryFormCApplicationsState createState() =>
      _TemporaryFormCApplicationsState();
}

class _TemporaryFormCApplicationsState
    extends State<TemporaryFormCApplications> {
  List<PendingAndSubmittedModel> pendingApplications = [];
  List<PendingAndSubmittedModel> searchedResultList = [];
  var registerdUserInDevice;
  bool _enabled = true;
  bool isLoading = true;
  String? selectedNationality;
  String? searchText;
  String? selectedUserNationality;
  var _nationalityController = TextEditingController();
  bool isLoadingStatusComplete = false;
  bool isFileNoExistsComplete = false;
  bool isPendingApplication = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getTempDetailsByPassnumAndNationality(
        widget.passportNumber, widget.nationality);
    if (isPendingApplication = true) {
      SpUtil.putBool('isPendingApplication', isPendingApplication);
    }
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
          body: _tabSection(context)),
    );
  }

  Widget _tabSection(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: EdgeInsets.only(top: 5),
        child: SingleChildScrollView(
            //    physics: NeverScrollableScrollPhysics(),
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Pending Applications" +
                      "(" +
                      pendingApplications.length.toString() +
                      ")",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                child: FormBuilderTextField(
                  //    initialValue: enteredCaptcha,
                  name: "searchbar",
                  // maxLines: 1,
                  maxLength: MAX_LENGTH_TEXTFIELD,

                  onChanged: (field) {
                    //print('inside onchanged');
                    searchText = field;
                    onSearchTextChanged(searchText!);
                  },
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    // filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                    // fillColor: Colors.white,
                    // prefixIcon: Icon(FontAwesome.search, color: blue),
                    prefixIcon: IconButton(
                      icon: Icon(FontAwesomeIcons.search, color: blue),
                      onPressed: () {
                        onSearchTextChanged(searchText!);
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: BORDERWIDTH, color: blue),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: BORDERWIDTH, color: blue),
                        borderRadius: BorderRadius.circular(10.0)),
                    // labelText: 'Password',
                    hintText: 'Search',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16,
                        letterSpacing: 1),
                  ),
                ),
              ),
            ),
            isLoadingStatusComplete
                ? (isFileNoExistsComplete &&
                        pendingApplications.isNotEmpty &&
                        pendingApplications.length > 0)
                    ? (searchedResultList.isNotEmpty &&
                            searchedResultList.length > 0)
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            //    physics: ScrollPhysics(),
                            itemCount: searchedResultList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Container(
                                  height: size.height * 0.35,
                                  child: ListTile(
                                    tileColor: Colors.white,

                                    leading: CircleAvatar(
                                      // minRadius: 40,
                                      // radius: 50,
                                      maxRadius: 40,
                                      backgroundColor: Colors.transparent,
                                      child: (searchedResultList[index].img !=
                                              "")
                                          ? Image.memory(Base64Decoder()
                                              .convert(searchedResultList[index]
                                                  .img!))
                                          : Icon(
                                              Icons.person,
                                              size: 40,
                                            ),
                                    ),
                                    title: Column(
                                      children: [
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: SelectableText(
                                              'Id: ${searchedResultList[index].formCApplId}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.4)),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        (searchedResultList[index].givenName !=
                                                null)
                                            ? Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    'Name: ${searchedResultList[index].givenName}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.4)),
                                              )
                                            : Text(''),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        (searchedResultList[index]
                                                    .nationalityDesc !=
                                                null)
                                            ? Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    'Nationality:${searchedResultList[index].nationalityDesc}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.4)),
                                              )
                                            : Text(''),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        (searchedResultList[index].dob != null)
                                            ? Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    'DOB: ${searchedResultList[index].dob}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.4)),
                                              )
                                            : Text(''),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    //    isThreeLine: true,
                                    dense: true,

                                    trailing: Icon(Icons.arrow_forward_ios,
                                        size: 26, color: Colors.black),

                                    onTap: () {
                                      //print('inside ontap');
                                      processPartialData(
                                          searchedResultList[index]
                                              .formCApplId!,
                                          context);
                                    },
                                  ),
                                ),
                              );
                            },
                          )
                        : (searchText == null || searchText == "")
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                //    physics: ScrollPhysics(),
                                itemCount: pendingApplications.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Container(
                                      height: size.height * 0.22,
                                      child: ListTile(
                                        tileColor: Colors.white,

                                        leading: CircleAvatar(
                                          // minRadius: 40,
                                          // radius: 50,
                                          maxRadius: 40,
                                          backgroundColor: Colors.transparent,
                                          child: (pendingApplications[index]
                                                      .img !=
                                                  "")
                                              ? Image.memory(Base64Decoder()
                                                  .convert(
                                                      pendingApplications[index]
                                                          .img!))
                                              : Icon(
                                                  Icons.person,
                                                  size: 40,
                                                ),
                                        ),
                                        title: Column(
                                          children: [
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: SelectableText(
                                                  'Id: ${pendingApplications[index].formCApplId}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.4)),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            (pendingApplications[index]
                                                        .givenName !=
                                                    null)
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        'Name: ${pendingApplications[index].givenName}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16.0,
                                                            letterSpacing:
                                                                0.4)),
                                                  )
                                                : Text(''),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            (pendingApplications[index]
                                                        .countryOutsideIndiaDesc !=
                                                    null)
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        'Country Outside: ${pendingApplications[index].countryOutsideIndiaDesc}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16.0,
                                                            letterSpacing:
                                                                0.4)),
                                                  )
                                                : Text(''),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            (pendingApplications[index].dob !=
                                                    null)
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        'DOB: ${pendingApplications[index].dob}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16.0,
                                                            letterSpacing:
                                                                0.4)),
                                                  )
                                                : Text(''),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            (pendingApplications[index]
                                                        .passnum !=
                                                    null)
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        'Passport Number: ${pendingApplications[index].passnum}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16.0,
                                                            letterSpacing:
                                                                0.4)),
                                                  )
                                                : Text(''),
                                          ],
                                        ),
                                        //    isThreeLine: true,
                                        dense: true,

                                        trailing: Icon(Icons.arrow_forward_ios,
                                            size: 26, color: Colors.black),

                                        onTap: () {
                                          //print('inside ontap');
                                          processPartialData(
                                              pendingApplications[index]
                                                  .formCApplId!,
                                              context);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                height:
                                    (MediaQuery.of(context).size.height / 2) +
                                        50,
                                child: Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text:
                                          "No Matching Application found. \n \n",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              )
                    : Container(
                        height: (MediaQuery.of(context).size.height / 2) + 50,
                        child: Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "No Incomplete Application found. \n \n",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      )
                : SizedBox(
                    width: size.width,
                    height: size.height,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      enabled: _enabled,
                      child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: MyShimmerEffectUI.circular(
                                  height: 60, width: 60),
                              title: Align(
                                alignment: Alignment.centerLeft,
                                child: MyShimmerEffectUI.rectangular(
                                    height: 18,
                                    width: MediaQuery.of(context).size.width *
                                        0.35),
                              ),
                              subtitle:
                                  MyShimmerEffectUI.rectangular(height: 16),
                            );
                          }),
                    ),
                  )
          ],
        )));
  }

  // Future<List<PendingAndSubmittedModel>> getTempDetailsByUserId(
  //     String frroFroCode, String userId) async {
  //   //print('userid inside fun $userId');
  //   var userID = userId.toLowerCase();
  //   var token = await HttpUtils().getToken();
  //   //print('token $token');
  //   try {
  //     // //print(
  //     //     'Inside Try :${PENDING_FORMC_DETAILS_LIST + '$frroFroCode&userid=$userId'}');
  //     var res2 = await http.get(
  //         Uri.parse(PENDING_FORMC_DETAILS_LIST + '$frroFroCode&userid=$userId'),
  //         headers: {
  //           "Accept": "application/json",
  //           'Authorization': 'Bearer $token'
  //         });

  //     setState(() {
  //       var responseBody = json.decode(res2.body);
  //       if (res2.statusCode == 200)
  //         pendingApplications = (responseBody as List)
  //             .map((i) => new PendingAndSubmittedModel.fromJson(i))
  //             .toList();
  //       setState(() {
  //         isLoadingStatusComplete = true;
  //         isFileNoExistsComplete = true;
  //       });
  //       //print('pending $pendingApplications');
  //       if (res2.statusCode != 200) {
  //         var result = FormCCommonServices.getStatusCodeError(res2.statusCode);
  //         if (responseBody != null && responseBody["message"] != null) {
  //           showDialog(
  //               barrierDismissible: false,
  //               context: context,
  //               builder: (context) {
  //                 return AlertDialog(
  //                     actions: [
  //                       TextButton(
  //                         child: new Text('Ok',
  //                             style: TextStyle(color: Colors.blue.shade500)),
  //                         onPressed: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                       ),
  //                     ],
  //                     title: Column(children: [
  //                       Text('${responseBody["message"]}'),
  //                     ]));
  //               });
  //         } else {
  //           showDialog(
  //               barrierDismissible: false,
  //               context: context,
  //               builder: (context) {
  //                 return AlertDialog(
  //                     actions: [
  //                       TextButton(
  //                         child: new Text('Ok', style: TextStyle(color: blue)),
  //                         onPressed: () {
  //                           // Navigator.popAndPushNamed(
  //                           //                   context, "/loginScreen");
  //                           Navigator.of(context).pop();
  //                         },
  //                       ),
  //                     ],
  //                     title: Column(children: [
  //                       Text('$result'),
  //                     ]));
  //               });
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     //print(e);
  //     showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //               actions: [
  //                 TextButton(
  //                   child: new Text('Ok', style: TextStyle(color: blue)),
  //                   onPressed: () {
  //                     Navigator.popAndPushNamed(context, "/landingPage");
  //                   },
  //                 ),
  //               ],
  //               title: Column(children: [
  //                 Text('Please try after sometime'),
  //               ]));
  //         });
  //   }
  //   if (pendingApplications.isEmpty || pendingApplications.length < 0) {}
  //   return pendingApplications;
  // }

  Future<List<PendingAndSubmittedModel>> getTempDetailsByPassnumAndNationality(
      String pass, String nationality) async {
    var token = await HttpUtils().getToken();
    //print('token $token');
    try {
      // print(GET_FORMC_PENDINGAPPL_BYPASSNOANDNAT +
      //     '$pass&nationality=$nationality');
      var res = await http.get(
          Uri.parse(GET_FORMC_PENDINGAPPL_BYPASSNOANDNAT +
              '$pass&nationality=$nationality'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $token'
          });

      setState(() {
        var responseBody = json.decode(res.body);
        // print('responseBody $responseBody');
        //  if(res.statusCode==200)
        pendingApplications = (responseBody as List)
            .map((i) => new PendingAndSubmittedModel.fromJson(i))
            .toList();
        setState(() {
          isLoadingStatusComplete = true;
          isFileNoExistsComplete = true;
        });
        //print('pending $pendingApplications');
        if (res.statusCode != 200) {
          var result = FormCCommonServices.getStatusCodeError(res.statusCode);
          if (responseBody[0]["error"] != null) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                      actions: [
                        TextButton(
                          child: new Text('Ok', style: TextStyle(color: blue)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      title: Column(children: [
                        Text('${responseBody[0]["error"]}'),
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
                            //  Navigator.popAndPushNamed(context, "/landingPage");
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
      //print(e);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
                actions: [
                  TextButton(
                    child: new Text('Ok', style: TextStyle(color: blue)),
                    onPressed: () {
                      //       Navigator.popAndPushNamed(context, "/landingPage");
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                title: Column(children: [
                  Text('Please try after sometime'),
                ]));
          });
    }
    if (pendingApplications.isEmpty || pendingApplications.length < 0) {}
    return pendingApplications;
  }

  onSearchTextChanged(String text) async {
    searchedResultList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    if (pendingApplications.isNotEmpty && pendingApplications.length > 0) {
      pendingApplications.forEach((userDetail) {
        try {
          if (userDetail.givenName!.contains(text) ||
              userDetail.surname!.contains(text) ||
              userDetail.formCApplId!.contains(text) ||
              userDetail.nationality!.contains(text) ||
              userDetail.nationalityDesc!.contains(text) ||
              userDetail.countryOutsideIndia!.contains(text) ||
              userDetail.countryOutsideIndiaDesc!.contains(text) ||
              userDetail.passnum!.contains(text)) {
            searchedResultList.add(userDetail);
          } else {
            // print('Inside error');
          }
        } catch (e) {
          // print('exception catched $e');
        }
      });
    }
    setState(() {});
    // print('Search Result $searchedResultList');
  }

  Future processPartialData(String applicationId, BuildContext context) async {
    EasyLoading.show(status: 'Please Wait...');

    await HttpUtils().savePendingApplicationId(applicationId);
    //print('inside partial data');
    //print('applicationid :$applicationId');
    FormCCommonServices.getFormCTempDetailsById(applicationId).then((value) {
      // print('value $value');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ApplicationGeneration(data: value)),
      );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => ServiceDetailsForm(data: value)),
      // );
      EasyLoading.dismiss();
    });
  }
}
