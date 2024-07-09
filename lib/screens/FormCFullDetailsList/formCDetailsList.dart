import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:formc_showcase/util/spUtil.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:formc_showcase/screens/FormCFullDetailsList/fullDetailsDisplayScreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:formc_showcase/models/pendingAndSubmittedListModel.dart.dart';
import 'package:formc_showcase/services/formC_commonServices.dart';
import 'package:shimmer/shimmer.dart';
import 'package:formc_showcase/Widgets/myShimmerEffectUi.dart';

class FormCDetailListScreen extends StatefulWidget {
  // const FormCDetailListScreen({ Key? key }) : super(key: key);
  var passportNumber, nationality;
  FormCDetailListScreen(this.passportNumber, this.nationality);

  @override
  _FormCDetailListScreenState createState() => _FormCDetailListScreenState();
}

class _FormCDetailListScreenState extends State<FormCDetailListScreen> {
  List<PendingAndSubmittedModel> submittedApplication = [];
  List<PendingAndSubmittedModel> searchedResultList = [];
  var registerdUserInDevice;
  bool _enabled = true;
  bool isLoading = true;
  String? selectedNationality;
  String? selectedUserNationality;
  var _nationalityController = TextEditingController();
  bool isLoadingStatusComplete = false;
  bool isFileNoExistsComplete = false;
  bool isLoadingStatusCompleted = false;
  bool isFileNoExistsCompleted = false;
  String? searchText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getSubmittedDetailsByPassnumAndNationality(
        widget.passportNumber, widget.nationality);
  }

  onSearchTextChanged(String text) async {
    searchedResultList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    if (submittedApplication.isNotEmpty && submittedApplication.length > 0) {
      submittedApplication.forEach((userDetail) {
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
                  "Submitted Applications" +
                      "(" +
                      submittedApplication.length.toString() +
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
                        submittedApplication.isNotEmpty &&
                        submittedApplication.length > 0)
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
                                  height: size.height * 0.18,
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
                                itemCount: submittedApplication.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Container(
                                      height: size.height * 0.18,
                                      child: ListTile(
                                        tileColor: Colors.white,

                                        leading: CircleAvatar(
                                          // minRadius: 40,
                                          // radius: 50,
                                          maxRadius: 40,
                                          backgroundColor: Colors.transparent,
                                          child: (submittedApplication[index]
                                                      .img !=
                                                  "")
                                              ? Image.memory(Base64Decoder()
                                                  .convert(submittedApplication[
                                                          index]
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
                                                  'Id: ${submittedApplication[index].formCApplId}',
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
                                            (submittedApplication[index]
                                                        .givenName !=
                                                    null)
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        'Name: ${submittedApplication[index].givenName}',
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
                                            (submittedApplication[index]
                                                        .countryOutsideIndiaDesc !=
                                                    null)
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        'Country Outside:${submittedApplication[index].countryOutsideIndiaDesc}',
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
                                            (submittedApplication[index].dob !=
                                                    null)
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        'DOB: ${submittedApplication[index].dob}',
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
                                            (submittedApplication[index]
                                                        .passnum !=
                                                    null)
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        'Passport Number: ${submittedApplication[index].passnum}',
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
                                              submittedApplication[index]
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
                              text: "No FormC Application found. \n \n",
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

  // Future<List<PendingListView>> getSubmittedApplicationsByUserId() async {
  //   // //print('userid inside fun $userId');
  //   // var userID = userId.toLowerCase();
  //   var token = await HttpUtils().getToken();
  //   //print('token $token');
  //   var accoCode = SpUtil.getString('accoCode');
  //   var userId = SpUtil.getString('userName');
  //   try {
  //     //print('Inside Try :${GET_APPLICANTS_LIST + '$accoCode&userid=$userId'}');

  //     var res = await http.get(
  //         Uri.encodeFull(GET_APPLICANTS_LIST + '$accoCode&userid=$userId'),
  //         headers: {
  //           "Accept": "application/json",
  //           'Authorization': 'Bearer $token'
  //         });

  //     setState(() {
  //       var responseBody = json.decode(res.body);
  //       submittedApplication = (responseBody as List)
  //           .map((i) => new PendingListView.fromJson(i))
  //           .toList();
  //       setState(() {
  //         isLoadingStatusIncomplete = true;
  //         isFileNoExistsIncomplete = true;
  //       });
  //       //print('pending $submittedApplication');
  //       if (res.statusCode != 200) {
  //         var result = FormCCommonServices.getStatusCodeError(res.statusCode);
  //         if (responseBody["errors"] != null) {
  //           showDialog(
  //               barrierDismissible: false,
  //               context: context,
  //               builder: (context) {
  //                 return AlertDialog(
  //                     actions: [
  //                       TextButton(
  //                         child: new Text('Ok', style: TextStyle(color: blue)),
  //                         onPressed: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                       ),
  //                     ],
  //                     title: Column(children: [
  //                       Text('${responseBody["errors"]}'),
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
  //                           Navigator.popAndPushNamed(context, "/landingPage");
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
  //   if (submittedApplication.isEmpty || submittedApplication.length < 0) {}
  //   return submittedApplication;
  // }

  Future<List<PendingAndSubmittedModel>>
      getSubmittedDetailsByPassnumAndNationality(
          String pass, String nationality) async {
    var token = await HttpUtils().getToken();
    //print('token $token');
    try {
      print(GET_FORMC_SUBMITTEDAPPLBY_PPTNOANDNAT +
          '$pass&nationality=$nationality');
      var res = await http.get(
          Uri.parse(GET_FORMC_SUBMITTEDAPPLBY_PPTNOANDNAT +
              '$pass&nationality=$nationality'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $token'
          });

      setState(() {
        var responseBody = json.decode(res.body);
        print('responseBody $responseBody');
        submittedApplication = (responseBody as List)
            .map((i) => new PendingAndSubmittedModel.fromJson(i))
            .toList();
        setState(() {
          isLoadingStatusComplete = true;
          isFileNoExistsComplete = true;
        });
        //print('pending $submittedApplication');
        if (res.statusCode != 200) {
          var result = FormCCommonServices.getStatusCodeError(res.statusCode);
          if (responseBody != null && responseBody[0]["message"] != null) {
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
                        Text('${responseBody[0]["message"]}'),
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
                      Navigator.popAndPushNamed(context, "/homeScreen");
                      //  Navigator.of(context).pop();
                    },
                  ),
                ],
                title: Column(children: [
                  Text('Please try after sometime'),
                ]));
          });
    }
    if (submittedApplication.isEmpty || submittedApplication.length < 0) {}
    return submittedApplication;
  }

  Future processPartialData(String applicationId, BuildContext context) async {
    EasyLoading.show(status: 'Please Wait...');

    await HttpUtils().savePendingApplicationId(applicationId);
    //print('inside partial data');
    //print('applicationid :$applicationId');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FullDetailsDisplayScreen(
                applicationId: applicationId,
              )),
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => ServiceDetailsForm(data: value)),
    // );
    EasyLoading.dismiss();
  }
}
