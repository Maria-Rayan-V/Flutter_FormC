import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:formc_showcase/util/spUtil.dart';
import 'package:formc_showcase/util/validations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/date_time_patterns.dart';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:formc_showcase/screens/homeScreen.dart';
import 'package:formc_showcase/services/formC_commonServices.dart';
import 'package:formc_showcase/main.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import '../../models/Registration/AccoProfileModel.dart';
import '../Registration/form1-accomodatorInfo.dart';

class ValidateUserScreen extends StatefulWidget {
  // const ValidateUserScreen({ Key? key }) : super(key: key);

  @override
  _ValidateUserScreenState createState() => _ValidateUserScreenState();
}

class _ValidateUserScreenState extends State<ValidateUserScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  dynamic _accoDetails;
  var serverResponse,
      isFinalSubmit,
      getuserName,
      random,
      randomQuestion,
      questionIndex,
      selectedAnswer;
  bool? isUserLoggedOut;
  bool isPasswordChanged = false;
  bool _obscureText = true;
  // SharedPreferences sharedPrefInstance;
  // void getSharedPrefInst() async {
  //   sharedPrefInstance = await SharedPreferences.getInstance();
  // }
  // checkIfAlreadyLogin() {
  //   isUserLoggedOut = (SpUtil.getBool('login') ?? true);
  //   //print(isUserLoggedOut);
  //   if (isUserLoggedOut == false) {
  //     Future.delayed(Duration(seconds: 1), () {
  //       navigatorKey.currentState.pushReplacementNamed('/homeScreen');
  //     });
  //   }
  // }
  var originalPassword,
      encryptedPassword,
      encryptedSalt,
      captchaToSend,
      statusCode,
      captchaForValidUser;
  String? userName,
      saltForValidUser,
      responseToken,
      frroCode,
      accoCode,
      lastLogin,
      responseUser,
      accoName,
      frroFroName,
      isApprovedUser;
  var responseJson;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // getSharedPrefInst();

    random = new Random();

    // checkIfAlreadyLogin();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  refreshCaptchaFunc(String usernameInsideFun) async {
    EasyLoading.show(status: 'Please Wait...');
    //print('user : $usernameInsideFun');
    //print(GET_SALT_URL + '$usernameInsideFun');
    var res;
    try {
      res = await http
          .get(Uri.parse(REFRESH_CAPTCHA_URL + '$usernameInsideFun'), headers: {
        "Accept": "application/json",
        //'Authorization': 'Bearer $token'
      });
      print('response :${res.body}');
      if (res.statusCode == 200) {
        setState(() {
          captchaForValidUser = json.decode(json.encode(res.body));
        });
      } else {
        captchaForValidUser = json.decode(res.body);
      }

      if (res.statusCode != 200) {
        var result = FormCCommonServices.getStatusCodeError(res.statusCode);

        if (captchaForValidUser != null &&
            captchaForValidUser["message"] != null) {
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
                      Text('${captchaForValidUser["message"]}'),
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
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                title: Column(children: [
                  Text('$e'),
                ]));
          });
    }
    EasyLoading.dismiss();
    return captchaForValidUser;
  }

  sendLoginRequest() async {
    EasyLoading.show(status: 'Please Wait...');
    try {
      //print('inside fun :$userName$encryptedPassword');

      var data = json.encode({
        "username": getuserName,
        "password": encryptedPassword,
        "requestFrom": "frmcapp",
        "captcha": captchaToSend
      });
      print(data);
      await http.post(
        Uri.parse(AUTHENTICATE_URL),
        body: data,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          // 'Authorization':
          //     'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJCQUxNSUtJMDA2QEdNQUlMLkNPTSIsImV4cCI6MTYzNTM2NzgyMCwiaWF0IjoxNjMxNzY3ODIwfQ._VhbKq2sYrLYhhKXbi1hEx - yx0PB2g1l5aficw6YOrGix5y3avtdnQyyuJMS45KMCDgVHEx_2tupvXyHxsqW8w'
        },
      ).then((response) {
        statusCode = response.statusCode;
        print("Login Response status: ${response.statusCode}");
        print("Login Response body: ${response.body}");
        responseJson = json.decode(response.body);
        if (response.statusCode == 200) {
          //print('ResponseJson :$responseJson');
          responseUser = responseJson['username'];
          responseToken = responseJson['token'];
          accoCode = responseJson['acco_code'];
          accoName = responseJson['acco_name'];
          frroCode = responseJson['frro_fro_code'];
          lastLogin = responseJson['lastLogin'];
          frroFroName = responseJson['frroFroDesc'];
          isApprovedUser = responseJson['isApprovedUser'];
          // isFinalSubmit = responseJson['isRegAppFinalSubmit'];
          //print('ResponseUser :$responseUser');
          // // print('ResponseToken :$responseToken');
          // //print(chkuser);

          //print('statusCode: $statusCode');
        }
      });

      if (responseUser != null &&
          responseToken != "" &&
          responseUser != "" &&
          responseToken != null &&
          statusCode == 200) {
        await HttpUtils().saveToken(responseToken!);
        await HttpUtils().saveUsername(responseUser!);
        await HttpUtils().saveAccocode(accoCode!);
        await HttpUtils().saveAccoName(accoName!);
        await HttpUtils().saveLastLogin(lastLogin!);
        await HttpUtils().saveFrroCode(frroCode!);
        // SpUtil.putString('isRegAppFinalSubmit', isFinalSubmit);
        // await HttpUtils().saveIsRegFinalSubmit(isFinalSubmit);
        if (isApprovedUser == 'Y') {
          Navigator.of(context).pushReplacementNamed("/homeScreen");
        }
        // if (isApprovedUser == 'N') {
        //   print('inside isApprovedUser N ');
        //   if (accoCode != null && frroCode != null) {
        //     print('calling getaccodts');
        //     getAccoDts(accoCode, frroCode, responseUser);
        //   } else {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => AccomodatorInformation(
        //                 data: null,
        //               )),
        //     );
        //   }
        // }
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Home()));
      }

      if (statusCode != 200) {
        //print('inside !200 fn');
        var result = FormCCommonServices.getStatusCodeError(statusCode);
        //print('statusCode $statusCode');
        //print('result :$result');

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
                          Navigator.of(context)
                              .pushReplacementNamed("/validateUser");
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
                          Navigator.of(context)
                              .pushReplacementNamed("/validateUser");
                        },
                      ),
                    ],
                    title: Column(children: [
                      Text('$result'),
                    ]));
              });
        }
      }
    } catch (e) {
      print('exception $e');
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
                actions: [
                  TextButton(
                    child: new Text('Ok', style: TextStyle(color: blue)),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed("/validateUser");
                    },
                  ),
                ],
                title: Column(children: [
                  Text('$e'),
                ]));
          });
    }

    EasyLoading.dismiss();
  }

  getAccoDts(String accoCode, String frroCode, String userId) async {
    EasyLoading.show(status: 'Please Wait...');

    print('Inside get Acco function');
    var token = await HttpUtils().getToken();
    try {
      var response = await http.get(
          Uri.parse(GET_ACCOM_DETAILS +
              '$accoCode&frro_fro_code=$frroCode&userid=$userId'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $token'
          });
      print('captcha response :${response.body}');

      serverResponse = json.decode(response.body);

      // // print('$captcha $salt');

      if (serverResponse != "" &&
          serverResponse != null &&
          response.statusCode == 200) {
        //print('saltvalid : $salt');
        setState(() {
          // _accoDetails = serverResponse;
          AccomodatorModel _accoDetails =
              AccomodatorModel.fromJson(jsonDecode(response.body));
          print(
              'getAccoDts Response ${_accoDetails.accomAddress} ${_accoDetails.ownerDetails![0].name}');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AccomodatorInformation(
                      data: _accoDetails,
                    )),
          );
        });
      }

      if (response.statusCode != 200) {
        var result =
            FormCCommonServices.getStatusCodeError(response.statusCode);

        if (serverResponse != null && serverResponse["message"] != null) {
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
                          // print('user id after cleared ${userRegnObj.userId}');
                        },
                      ),
                    ],
                    title: Column(children: [
                      Text('${serverResponse["message"]}'),
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
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                title: Column(children: [
                  Text('$e'),
                ]));
          });
    }
    EasyLoading.dismiss();
    return serverResponse;
  }

  validateUser(String usernameInsideFun) async {
    EasyLoading.show(status: 'Please Wait...');
    print('user : $usernameInsideFun');
    //print(GET_SALT_URL + '$usernameInsideFun');
    var res;
    try {
      res = await http
          .get(Uri.parse(GET_SALT_URL + '$usernameInsideFun'), headers: {
        "Accept": "application/json",
        //'Authorization': 'Bearer $token'
      });
      print('response :${res.body}');
      serverResponse = json.decode(res.body);

      // // print('$captcha $salt');

      if (serverResponse != "" &&
          serverResponse != null &&
          res.statusCode == 200) {
        //print('saltvalid : $salt');
        setState(() {
          saltForValidUser = serverResponse['salt'];
          captchaForValidUser = serverResponse['captcha'];
        });

        // Navigator.of(context).pushReplacementNamed("/loginScreen");
      }
      if (saltForValidUser == "" || saltForValidUser == null) {
        // print('Inside server response null');
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
                    Text('INVALID CREDENTIALS'),
                  ]));
            });
      }
      if (res.statusCode != 200) {
        // print('Inside server response !=200');
        var result = FormCCommonServices.getStatusCodeError(res.statusCode);

        if (serverResponse != null && serverResponse["message"] != null) {
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
                      Text('${serverResponse["message"]}'),
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
    } catch (e) {
      // print('Inside catch e');
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
                  Text('$e'),
                ]));
          });
    }
    EasyLoading.dismiss();
    return serverResponse;
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit an App?'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text('No'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                ),
                onPressed: () => SystemNavigator.pop(),
                //return true when click on "Yes"
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  var contextInBuild;
  @override
  Widget build(BuildContext context) {
    setState(() => this.contextInBuild = context);
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
          // backgroundColor: blue,

          /*    body:Stack(children: [
         Container(
             child: Column(children: [  SizedBox(
                        height: size.height * 0.010,
                      ),Center(
                        child: new Image.asset(
                          'assets/images/BOILogoWhite.jpg',
                          width: size.width * 0.25,
                          height: size.height * 0.15,
                          fit: BoxFit.fill,
                        ),
                      ),],),
         ),
           Center(
             child: Padding(
               padding: const EdgeInsets.all(12.0),
               child: Container(
                    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue[200],
      boxShadow: [
        BoxShadow(color:blue, spreadRadius: 3),
      ],
  ),
               //  color:blue,
                 child: Column(children: [
 Padding(
                        padding: const EdgeInsets.all(fieldPadding),
                        child: Container(
                          child: FormBuilderTextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(alphabetSpace))
                            ],
                            initialValue: userName,
                            //attribute: "Name",
                            maxLines: 1,
                            maxLength: 50,
                            onChanged: (field) {
                              userName = field;
                              //      //print('Name ${enteredCaptcha}');
                            },
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              labelText: 'Username',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 16,
                                  letterSpacing: 1),
                            ),
                            validators: [
                              FormBuilderValidators.required(
                                errorText: 'Required',
                              ),
                            ],
                          ),
                        ),
                      ),
                      RaisedButton(
                        child: Text('Validate'),
                        onPressed: () {
                          if (_fbKey.currentState.saveAndValidate()) {
                            validateUser(userName);
                            //print('true');
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      actions: [
                                        TextButton(
                                          child: new Text('Ok',
                                              style: TextStyle(
                                                  color: blue)),
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
                      SizedBox(
                        height: size.height * 0.30,
                      ),
                 ],),
                  height: size.height/2,
                  width: size.width,
               ),
             ),
           )

          ],)*/
          body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            color: Colors.white,
          ),
        ),
        SingleChildScrollView(
          child: Center(
            child: FormBuilder(
              key: _fbKey,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.050,
                    ),
                    Center(
                      child: Text(
                        'FORM C LOGIN',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: blue),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.050,
                    ),
                    Center(
                      child: new Image.asset(
                        'assets/images/BOI.png',
                        width: size.width * 0.35,
                        height: size.height * 0.15,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.060,
                    ),
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
                        child: Focus(
                          child: FormBuilderTextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(alphaNumericSpace))
                            ],
                            initialValue: getuserName,
                            //attribute: "Name",
                            maxLines: 1,
                            maxLength: MAX_LENGTH_TEXTFIELD,
                            onChanged: (field) {
                              getuserName = field;
                              setState(() {
                                captchaForValidUser = null;
                              });

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
                                  borderSide: BorderSide(
                                      width: BORDERWIDTH, color: blue),
                                  borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: BORDERWIDTH, color: blue),
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
                          onFocusChange: (hasFocus) {
                            if (hasFocus == false) {
                              print('Inside focus');
                              if (getuserName != null &&
                                  getuserName != "" &&
                                  getuserName != " ") {
                                validateUser(getuserName);
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
                                          title: Text(" Enter Valid Username "),
                                        ));
                              }
                            }
                          },
                        ),
                      ),
                    ),

                    // SizedBox(
                    //   width: size.width * 0.10,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Password *',
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
                          //    initialValue: enteredCaptcha,
                          name: "password",
                          // maxLines: 1,
                          maxLength: MAX_LENGTH_TEXTFIELD,

                          obscureText: _obscureText,
                          onChanged: (field) {
                            //print('inside onchanged');
                            originalPassword = field;
                            isPasswordChanged = true;
                          },
                          //    textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            // filled: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10.0),
                            // fillColor: Colors.white,
                            prefixIcon:
                                Icon(FontAwesomeIcons.lock, color: blue),
                            suffixIcon: IconButton(
                              icon: _obscureText
                                  ? Icon(FontAwesomeIcons.eyeSlash, color: blue)
                                  : Icon(FontAwesomeIcons.eye, color: blue),
                              onPressed: () {
                                _toggle();
                              },
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: BORDERWIDTH, color: blue),
                                borderRadius: BorderRadius.circular(10.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: BORDERWIDTH, color: blue),
                                borderRadius: BorderRadius.circular(10.0)),
                            // labelText: 'Password',
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
                    if (captchaForValidUser != null &&
                        captchaForValidUser != "")
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: size.height * 0.125,
                                //   color: blue,
                                child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Image.memory(
                                    Base64Decoder()
                                        .convert(captchaForValidUser),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  margin: EdgeInsets.all(10),
                                ),
                              ),
                              // Card(
                              //   elevation: 30,
                              //   color: blue,
                              //   child: Image.memory(
                              //     Base64Decoder().convert(captchaForValidUser),
                              //     fit: BoxFit.cover,
                              //   ),
                              // ),
                              Ink(
                                  decoration: const ShapeDecoration(
                                    color: blue,
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.refresh,
                                    ),
                                    splashColor: Colors.purple,
                                    iconSize: 50,
                                    onPressed: () {
                                      refreshCaptchaFunc(getuserName);
                                    },
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Captcha *',
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
                                //    initialValue: enteredCaptcha,
                                name: "captcha",
                                // maxLines: 1,
                                maxLength: 6,

                                onChanged: (field) {
                                  //print('inside onchanged');
                                  captchaToSend = field;
                                },
                                textCapitalization:
                                    TextCapitalization.characters,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  filled: true,
                                  prefixIcon: Icon(FontAwesomeIcons.refresh,
                                      color: blue),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  fillColor: Colors.white,

                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: BORDERWIDTH, color: blue),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: BORDERWIDTH, color: blue),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  // labelText: 'Password',
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
                        ],
                      ),

                    Container(
                      width: 250,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                          ),
                          primary: blue,
                        ),
                        child: Text('Login',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          // Navigator.of(context)
                          //     .pushReplacementNamed("/homeScreen");
                          if (originalPassword != null &&
                              originalPassword != "" &&
                              isPasswordChanged == true) {
                            originalPassword =
                                new Utf8Encoder().convert(originalPassword);
                            //print('Original Password :$originalPassword');
                            var md5Password =
                                crypto.md5.convert(originalPassword);
                            //print('md5 :$md5Password');
                            var md5PasswordString =
                                hex.encode(md5Password.bytes);
                            //print('md5 String :$md5PasswordString');
                            var md5toSha256 = utf8.encode(md5PasswordString);
                            var convertedSha256Password =
                                crypto.sha256.convert(md5toSha256);
                            var sha256PasswordString =
                                hex.encode(convertedSha256Password.bytes);
                            //print('password sha :$sha256PasswordString');
                            var saltToSha256 = utf8.encode(saltForValidUser!);
                            var sha256Salt =
                                crypto.sha256.convert(saltToSha256);
                            var sha256SaltString = hex.encode(sha256Salt.bytes);
                            var combinedsha256String =
                                sha256PasswordString + sha256SaltString;
                            var combinedToSha256 =
                                utf8.encode(combinedsha256String);
                            var combinedSha256 =
                                crypto.sha256.convert(combinedToSha256);
                            encryptedPassword =
                                hex.encode(combinedSha256.bytes);
                            isPasswordChanged = false;
                          }
                          //print('encrypted : $encryptedPassword');
                          if (_fbKey.currentState!.saveAndValidate()) {
                            //print('true');
                            if (encryptedPassword != null &&
                                encryptedPassword != "") sendLoginRequest();
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
                                      title: Text(" Enter Mandatory Fields "),
                                    ));
                          }
                        },
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     SizedBox(
                    //       width: size.width * 0.11,
                    //     ),
                    //     Text(
                    //       "Create account",
                    //       style: TextStyle(
                    //         fontSize: 17,
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //     ButtonTheme(
                    //       minWidth: 270,
                    //       height: 15,
                    //       child: TextButton(
                    //         child: Text(
                    //           "Sign Up",
                    //           style: TextStyle(
                    //             fontSize: 20,
                    //             color: blue,
                    //             decoration: TextDecoration.underline,
                    //           ),
                    //         ),
                    //         onPressed: () async {
                    //           Navigator.of(context)
                    //               .pushReplacementNamed("/userRegn");
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ])),
    );
  }
}
