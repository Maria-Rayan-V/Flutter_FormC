import 'package:flutter/material.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert';
import 'package:formc_showcase/util/utility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:http/http.dart' as http;
import 'package:formc_showcase/screens/checkIn/form3_personalDetails.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:formc_showcase/screens/formC_wizard.dart';
import 'package:formc_showcase/util/spUtil.dart';
import 'package:formc_showcase/services/formC_commonServices.dart';

class FormCPhotoUploadScreen extends StatefulWidget {
  //const FormCPhotoUploadScreen({ Key? key }) : super(key: key);
  dynamic data;
  FormCPhotoUploadScreen({Key? key, @required this.data, String? appId})
      : super(key: key);
  @override
  _FormCPhotoUploadScreenState createState() => _FormCPhotoUploadScreenState();
}

class _FormCPhotoUploadScreenState extends State<FormCPhotoUploadScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double photoSize = 0.0;
  List? formCExistingData;
  var formCApplicationId;
  bool? isPendingApplication;
  FormCWizardMenuItem? stepsWizard;
  FormCWizardMenuItem? stepsWizardForPendingAppl;
  var passportNumberFromSearch, nationalityFromSearch, responseJson;
  uploadPhotoFunction() async {
    EasyLoading.show(status: 'Please Wait...');
    var token = await HttpUtils().getToken();
    var newApplicationId = await HttpUtils().getNewApplicationId();
    //print('token: $token');
    try {
      var data = json.encode({"form_c_appl_id": newApplicationId, "img": img});
      //print(data);
      //print(PHOTO_UPLOAD_URL);
      await http.post(
        Uri.parse(PHOTO_UPLOAD_URL),
        body: data,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $token'
        },
      ).then((response) {
        //print("Response status: ${response.statusCode}");
        //print("Response body: ${response.body}");
        // var responseJson = json.decode(response.body);
        ////print('ResponseJson :$responseJson');

        // //print(chkuser);
        responseJson = json.decode(json.encode(response.body));
        // print(responseJson);
        if (response.statusCode == 200) {
          //print('inside navigate');

          (isPendingApplication == true)
              ? stepsWizardForPendingAppl!
                  .createState()
                  .moveToPendingDataScreen(newApplicationId!, "3", context)
              : stepsWizard!.createState().moveToScreen(
                  passportNumberFromSearch,
                  nationalityFromSearch,
                  "3",
                  context);
          //   Navigator.of(context).pushReplacementNamed("/photoUploadScreen");
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => PersonalDetailsScreen()));
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
      // print(e);
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

  bool buttonEnabled = true;
  enableButton(bool flag) {
    setState(() {
      buttonEnabled = flag;
    });
  }

  isEnabled() {
    return buttonEnabled;
  }

  next() {
    if (img == null || img == "") {
      Utility.displaySnackBar(_scaffoldKey, 'Please upload your photograph');
      return;
    }
    if (photoSize > 0.0 && photoSize < 10) {
      Utility.displaySnackBar(
          _scaffoldKey, 'Minimum size limit of the photograph is 10 kb');
      return;
    }
    if (photoSize > 50) {
      Utility.displaySnackBar(
          _scaffoldKey, "Maximum size limit of the photograph is 50 kb");
      return;
    }
    if ((photoSize > 10 && photoSize < 100) || img != null) {
      uploadPhotoFunction();
    }
    // enableButton(false);

    // Navigator.push(context, MaterialPageRoute( builder: (context) => FRRO_P1()),);
  }

  back() {
    //print('Previous Page: P0');
    Navigator.pop(context);
  }

  getFlutterSecureStorageData() async {
    passportNumberFromSearch = await HttpUtils().getExistingFormCPptNo();
    nationalityFromSearch = await HttpUtils().getExistingFormCNationality();
    formCApplicationId = await HttpUtils().getNewApplicationId();
    setState(() {
      passportNumberFromSearch = passportNumberFromSearch;
      nationalityFromSearch = nationalityFromSearch;
      formCApplicationId = formCApplicationId;
    });
  }

  final keyOne = GlobalKey();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getFlutterSecureStorageData();
    if (widget.data != null) {
      formCExistingData = widget.data;
      //print('formCC Existing photoscreen :$formCExistingData');
    } else {
      //print('null pending data');
    }

    isPendingApplication = SpUtil.getBool('isPendingApplication');
    // WidgetsBinding.instance.addPostFrameCallback((_) =>
    //     ShowCaseWidget.of(_scaffoldKey.currentContext).startShowCase([keyOne]));
    setState(() {
      //  page1 = widget.data;
      stepsWizard = new FormCWizardMenuItem(
          passportNumberInWizard: passportNumberFromSearch,
          nationalityInWizard: nationalityFromSearch,
          currentPageNo: "2");
      stepsWizardForPendingAppl =
          new FormCWizardMenuItem.editFormCTempApplication(
        applicationId: formCApplicationId,
        currentPageNo: "2",
      );
    });
    if (formCExistingData != null &&
        formCExistingData!.length > 0 &&
        formCExistingData![0].image != null &&
        formCExistingData![0].image != "") {
      img = formCExistingData![0].image;
      // // print('image :${formCExistingData[0].image}');
    }
  }

  void _settingModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.white,
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      Navigator.pop(context);
                      //return getImage(ImageSource.camera);
                      Utility().getImage(ImageSource.camera).then((value) {
                        if (value.photo != null) {
                          setState(() {
                            img = value.photo!;
                            //print(img);
                            photoSize = value.size!;
                          });
                        }
                      });
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    //return getImage(ImageSource.gallery);
                    Utility().getImage(ImageSource.gallery).then((value) {
                      if (value.photo != null) {
                        setState(() {
                          img = value.photo!;
                          //print('img :$img');
                          photoSize = value.size!;
                          //print('photoSize: $photoSize');
                        });
                      }
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  String? img;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _scaffoldKey,
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
                  child: Center(
                    child: Column(children: [
                      SizedBox(height: 20),
                      SelectableText(
                        'Application Id: $formCApplicationId',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(' Photo Upload ',
                          style: TextStyle(
                              //   decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: blue)),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 5,
                        child: Container(
                            width: 300,
                            height: 300,
                            child: Stack(
                              children: <Widget>[
                                (img != null)
                                    ? Image.memory(base64Decode(img!))
                                    : Image.asset(
                                        "assets/images/image-placeholder-500x500.jpg"),
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(200, 0, 0, 0),
                                          Color.fromARGB(0, 0, 0, 0)
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _settingModalBottomSheet();
                                          },
                                          icon: Icon(
                                            Icons.photo_camera,
                                            color: Colors.white,
                                          ),
                                          iconSize: 35.0,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (img != null) {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Do you want to delete the photo'),
                                                    actions: [
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                      .circular(
                                                                      18.0),
                                                            ),
                                                            primary: blue,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {
                                                              img = null;
                                                              //   photoSize = 0.0;
                                                            });
                                                          },
                                                          child: Text(
                                                            'yes',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                      .circular(
                                                                      18.0),
                                                            ),
                                                            backgroundColor:
                                                                blue,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('No',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)))
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          icon: Icon(
                                            Icons.clear_rounded,
                                            color: Colors.red,
                                          ),
                                          iconSize: 35.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                /* Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _settingModalBottomSheet();
                                      },
                                      icon: Icon(
                                        Icons.photo_camera,
                                        color: Colors.white,
                                      ),
                                      iconSize: 35.0,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          img = null;
                                          photoSize = 0.0;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.clear_rounded,
                                        color: Colors.red,
                                      ),
                                      iconSize: 35.0,
                                    ),
                                  ],
                                ),
                    //           ), */
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ],
                            )),
                      ),
                      photoSize > 1
                          ? Text('Photo Size: $photoSize KB')
                          : Text(''),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('1. Format JPEG/JPG'),
                            Text("2. Size Minimum 10 Kb, Maximum 50 kb"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      //                 Center(
                      //                   child: ButtonTheme(
                      //                     minWidth: 250,
                      //                     height: 45,
                      //                     child: RaisedButton(
                      //                       onPressed: () {
                      //                          if (photoSize == 0.0) {
                      //   Utility.displaySnackBar(
                      //       _scaffoldKey, 'Please upload your photograph');
                      //   return;
                      // }
                      // if (photoSize > 0.0 && photoSize < 10) {
                      //   Utility.displaySnackBar(
                      //       _scaffoldKey, 'Minimum size limit of the photograph is 10 kb');
                      //   return;
                      // }
                      // if (photoSize > 100) {
                      //   Utility.displaySnackBar(
                      //       _scaffoldKey, "Minimum size limit of the photograph is 50 kb");
                      //   return;
                      // }
                      //   if(photoSize>10 && photoSize <100){ uploadPhotoFunction();}

                      //                       },
                      //                       color: blue,
                      //                       shape: RoundedRectangleBorder(
                      //                           borderRadius: BorderRadius.circular(10)),
                      //                       child: Text(
                      //                         "Upload ",
                      //                         style: TextStyle(color: Colors.white),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 )
                    ]),
                  ))),
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
