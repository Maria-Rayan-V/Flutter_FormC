import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:formc_showcase/models/Registration/UserRegnModel.dart';
import '../../Widgets/sideDrawer.dart';
import '../../constants/formC_constants.dart';
import '../../models/masters/countryModel.dart';
import '../../services/formC_commonServices.dart';
import '../../util/httpUtil.dart';
import '../../util/validations.dart';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:developer';

class UserRegnScreen extends StatefulWidget {
  const UserRegnScreen({Key? key}) : super(key: key);

  @override
  State<UserRegnScreen> createState() => _UserRegnScreenState();
}

class _UserRegnScreenState extends State<UserRegnScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  UserRegnModel userRegnObj = UserRegnModel();
  bool _obscureText = true;
  bool _isCnfrmPswdObsecre = true;
  bool isUserAvailable = false;
  String? userValidationMsg;
  bool isMobileOtpGenerated = false;
  bool isMailOtpGenerated = false;
  bool isMblOTPObsecure = true;
  bool isMailOTPObsecure = true;
  var serverResponse, captchaForValidUser, passwordtoReg, confirmPasstoReg;
  List<CountryModel> countryList = [];
  _toggle(bool isobsecureStr) {
    setState(() {
      isobsecureStr = !isobsecureStr;
    });
    return isobsecureStr;
  }

  void initState() {
    super.initState();
    debugPrint('Inside init in regn');
  }

  postUserRegnData() async {
    var responseJson;
    EasyLoading.show(status: 'Please Wait...');
    var token = await HttpUtils().getToken();
    //print('token: $token');

    try {
      var data = json.encode({
        "userId": userRegnObj.userId,
        "userName": userRegnObj.userName,
        "password": passwordtoReg,
        "confirmPassword": confirmPasstoReg,
        "emailId": userRegnObj.emailId,
        "email_otp": userRegnObj.emailOtp,
        "mobile": userRegnObj.mobile,
        "mobile_otp": userRegnObj.mobileOtp,
        "captcha": userRegnObj.captcha,
        "clientIp": userRegnObj.clientIp,
      });
      // print('inside reg user $data');
      //print(GENERATE_APPLID);
      await http.post(
        Uri.parse(POST_USER_REGN_DTS),
        body: data,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
      ).then((response) async {
        // print('chkuser ${response.body}');
        responseJson = json.decode(response.body);
        if (response.statusCode == 200) {
          // print('success');

          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                    actions: [
                      ElevatedButton(
                        child: new Text('Ok',
                            style: TextStyle(color: Colors.blue.shade500)),
                        onPressed: () {
                          Navigator.pushNamed(context, "/validateUser");
                        },
                      ),
                    ],
                    title: Column(children: [
                      Text('Userid created successfully'),
                    ]));
              });
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
                        ElevatedButton(
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
                        ElevatedButton(
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
                  ElevatedButton(
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

  bool isPasswordChanged = false;
  validateUserid(String usernameInsideFun) async {
    print('inside valid user : $usernameInsideFun');
    EasyLoading.show(status: 'Please Wait...');

    //print(GET_SALT_URL + '$usernameInsideFun');
    var res;
    try {
      res = await http.get(
          Uri.parse(VALIDUSER_REGN_CAPTCHA + '$usernameInsideFun'),
          headers: {
            "Accept": "application/json",
            //'Authorization': 'Bearer $token'
          });
      print('captcha response :${res.body}');

      serverResponse = json.decode(res.body);

      // // print('$captcha $salt');

      if (serverResponse != "" &&
          serverResponse != null &&
          res.statusCode == 200) {
        //print('saltvalid : $salt');
        setState(() {
          isUserAvailable = true;
        });
        captchaForValidUser = serverResponse['captcha'];
      }

      if (res.statusCode != 200) {
        var result = FormCCommonServices.getStatusCodeError(res.statusCode);

        if (serverResponse != null && serverResponse["message"] != null) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                    actions: [
                      ElevatedButton(
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
                      ElevatedButton(
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
                  ElevatedButton(
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

  generateMobileOtp(String userid, String mblnum) async {
    var responseFromServer;
    EasyLoading.show(status: 'Please Wait...');
    //print('user : $usernameInsideFun');
    //print(GET_SALT_URL + '$usernameInsideFun');
    var res;
    try {
      res = await http
          .get(Uri.parse(GET_MOBILE_OTP + '$userid/$mblnum'), headers: {
        "Accept": "application/json",
        //'Authorization': 'Bearer $token'
      });
      // print('response :${res.body}');

      responseFromServer = json.decode(res.body);

      // // print('$captcha $salt');

      if (responseFromServer != "" &&
          responseFromServer != null &&
          res.statusCode == 200) {
        //print('saltvalid : $salt');
        // print('otp rsp $responseFromServer');
        setState(() {
          isMobileOtpGenerated = true;
        });
      }

      if (res.statusCode != 200) {
        var result = FormCCommonServices.getStatusCodeError(res.statusCode);

        if (responseFromServer != null &&
            responseFromServer["message"] != null) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                    actions: [
                      ElevatedButton(
                        child: new Text('Ok',
                            style: TextStyle(color: Colors.blue.shade500)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                    title: Column(children: [
                      Text('${responseFromServer["message"]}'),
                    ]));
              });
        } else {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                    actions: [
                      ElevatedButton(
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
                  ElevatedButton(
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
    return responseFromServer;
  }

  generateMailOtp(String userid, String mailid) async {
    var responseFromServer;
    EasyLoading.show(status: 'Please Wait...');
    //print('user : $usernameInsideFun');
    //print(GET_SALT_URL + '$usernameInsideFun');
    var res;
    try {
      res = await http
          .get(Uri.parse(GET_EMAIL_OTP + '$userid/$mailid'), headers: {
        "Accept": "application/json",
        //'Authorization': 'Bearer $token'
      });
      // print('response :${res.body}');

      responseFromServer = json.decode(res.body);

      // // print('$captcha $salt');

      if (responseFromServer != "" &&
          responseFromServer != null &&
          res.statusCode == 200) {
        //print('saltvalid : $salt');
        // print('otp rsp $responseFromServer');
        setState(() {
          isMailOtpGenerated = true;
        });
      }

      if (res.statusCode != 200) {
        var result = FormCCommonServices.getStatusCodeError(res.statusCode);

        if (responseFromServer != null &&
            responseFromServer["message"] != null) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                    actions: [
                      ElevatedButton(
                        child: new Text('Ok',
                            style: TextStyle(color: Colors.blue.shade500)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                    title: Column(children: [
                      Text('${responseFromServer["message"]}'),
                    ]));
              });
        } else {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                    actions: [
                      ElevatedButton(
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
                  ElevatedButton(
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
    return responseFromServer;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        //  resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0), // here the desired height
          child: AppBar(
            backgroundColor: blue,
            leading: Container(),
            title: Text('Form C'),
            actions: <Widget>[
              IconButton(
                tooltip: 'Login',
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  Navigator.pushNamed(context, "/validateUser");
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
        // drawer: FormCSideDrawer(),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: FormBuilder(
              key: _fbKey,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(' Register User ',
                      style: TextStyle(
                          //   decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: blue)),
                  SizedBox(
                    height: size.height * 0.010,
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
                          initialValue: (userRegnObj.userId != null)
                              ? userRegnObj.userId
                              : null,
                          //attribute: "Name",
                          maxLines: 1, cursorColor: blue,
                          maxLength: MAX_LENGTH_TEXTFIELD,
                          onChanged: (field) {
                            userRegnObj.userId = field;
                            // print('userid ${userRegnObj.userId}');
                            setState(() {
                              isUserAvailable = false;
                            });

                            Pattern pattern =
                                r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+){8,20}$';
                            RegExp regex = new RegExp("$pattern");
                            if (!regex.hasMatch(userRegnObj.userId!))
                              setState(() {
                                userValidationMsg =
                                    'Minimum 8 charecters, Should contain a alphabet and number';
                              });
                            else
                              setState(() {
                                userValidationMsg = null;
                              });
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
                            // hintText: 'Userid',
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
                              (value) {
                                Pattern pattern =
                                    r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+){8,20}$';
                                RegExp regex = new RegExp("$pattern");
                                if (!regex.hasMatch(value!))
                                  return 'Minimum 8 charecters, Should contain a alphabet and number';
                                else
                                  return null;
                              }
                            ],
                          ),
                          name: 'userid',
                        ),
                        onFocusChange: (hasFocus) {
                          if (hasFocus == false) {
                            if (userValidationMsg == null) {
                              FocusScope.of(context).unfocus();
                              print('Inside focus before fn');
                              validateUserid(userRegnObj.userId!);
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  if (userValidationMsg != null)
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        '$userValidationMsg',
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    ),
                  if (isUserAvailable)
                    Text(
                      'Userid available',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.green, fontSize: 17),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Full Name *',
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
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(alphabetSpace))
                        ],
                        initialValue: userRegnObj.userName,
                        //attribute: "Name",
                        maxLines: 1, cursorColor: blue,
                        maxLength: MAX_LENGTH_TEXTFIELD,
                        onChanged: (field) {
                          // print('inside username onchanges');
                          userRegnObj.userName = field;
                          // print('Name ${userRegnObj.userName}');
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
                        name: 'name',
                      ),
                    ),
                  ),
                  if (isUserAvailable)
                    Column(
                      children: [
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
                              // cursorWidth: size.width * 0.02,
                              cursorColor: blue,
                              obscureText: _obscureText,
                              onChanged: (field) {
                                //print('inside onchanged');
                                userRegnObj.password = field;
                                passwordtoReg = field;
                                isPasswordChanged = true;
                              },
                              //    textCapitalization: TextCapitalization.characters,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                // filled: true,
                                errorMaxLines: 2,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                // fillColor: Colors.white,
                                prefixIcon:
                                    Icon(FontAwesomeIcons.lock, color: blue),
                                suffixIcon: IconButton(
                                  icon: _obscureText
                                      ? Icon(Icons.remove_red_eye)
                                      : Icon(Icons.highlight_remove_rounded),
                                  onPressed: () {
                                    _obscureText = _toggle(_obscureText);
                                  },
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2, color: blue),
                                    borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2, color: blue),
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
                                  (value) {
                                    Pattern pattern =
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[@#\$*]).{8,}$';
                                    RegExp regex = new RegExp("$pattern");
                                    if (!regex.hasMatch(value!))
                                      return 'Minimum 8 charecters, Should contain a uppercase, a lowercase, a number and a special charecter';
                                    else
                                      return null;
                                  }
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
                                'Confirm Password *',
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
                              name: "confirmPassword",
                              // maxLines: 1,
                              maxLength: MAX_LENGTH_TEXTFIELD,

                              // cursorWidth: size.width * 0.02,
                              cursorColor: blue,
                              obscureText: _isCnfrmPswdObsecre,
                              onChanged: (field) {
                                //print('inside onchanged');
                                userRegnObj.confirmPassword = field;
                                isPasswordChanged = true;
                                confirmPasstoReg = field;
                              },
                              //    textCapitalization: TextCapitalization.characters,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                // filled: true,
                                errorMaxLines: 3,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                // fillColor: Colors.white,
                                prefixIcon:
                                    Icon(FontAwesomeIcons.lock, color: blue),
                                suffixIcon: IconButton(
                                  icon: _isCnfrmPswdObsecre
                                      ? Icon(Icons.remove_red_eye)
                                      : Icon(Icons.highlight_remove_rounded),
                                  onPressed: () {
                                    _isCnfrmPswdObsecre =
                                        _toggle(_isCnfrmPswdObsecre);
                                  },
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2, color: blue),
                                    borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2, color: blue),
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
                                  (value) {
                                    Pattern pattern =
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[@#\$*]).{8,}$';
                                    RegExp regex = new RegExp("$pattern");
                                    if (!regex.hasMatch(value!))
                                      return 'Minimum 8 charecters, Should contain a uppercase, a lowercase, a number and a special charecter';
                                    else
                                      return null;
                                  }
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Email Id*',
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
                                      initialValue: userRegnObj.emailId,
                                      //attribute: "Name",
                                      maxLines: 1, cursorColor: blue,
                                      maxLength: MAX_LENGTH_TEXTFIELD,
                                      onChanged: (field) {
                                        userRegnObj.emailId = field;
                                        //      //print('Name ${enteredCaptcha}');
                                      },
                                      //       textCapitalization: TextCapitalization.characters,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                        prefixIcon:
                                            Icon(Icons.person, color: blue),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2, color: blue),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2, color: blue),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        // labelText: 'Username',
                                        // hintText: 'emailid',
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
                                          EmailValidator(
                                              errorText:
                                                  'Enter Valid Email Id'),
                                        ],
                                      ),
                                      name: 'emailid',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                ),
                              ),
                              child: Text(
                                'Get OTP in mail',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                if (userRegnObj.emailId != null) {
                                  generateMailOtp(userRegnObj.userId!,
                                      userRegnObj.emailId!);
                                } else {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            actions: [
                                              ElevatedButton(
                                                child: new Text('Ok',
                                                    style:
                                                        TextStyle(color: blue)),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                            title: Column(children: [
                                              Text('Enter emailid'),
                                            ]));
                                      });
                                }
                              },
                            ),
                          ),
                        ]),
                        if (isMailOtpGenerated)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Enter OTP sent in mail *',
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
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(alphaNumeric))
                                    ],
                                    initialValue: userRegnObj.emailOtp,
                                    //attribute: "Name",
                                    obscureText: isMailOTPObsecure,
                                    maxLines: 1, cursorColor: blue,
                                    maxLength: 4,
                                    onChanged: (field) {
                                      userRegnObj.emailOtp = field;
                                      //      //print('Name ${enteredCaptcha}');
                                    },
                                    //       textCapitalization: TextCapitalization.characters,
                                    textInputAction: TextInputAction.next,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: InputDecoration(
                                      // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                      prefixIcon:
                                          Icon(Icons.person, color: blue),
                                      suffixIcon: IconButton(
                                        icon: isMailOTPObsecure
                                            ? Icon(Icons.remove_red_eye)
                                            : Icon(
                                                Icons.highlight_remove_rounded),
                                        onPressed: () {
                                          isMailOTPObsecure =
                                              _toggle(isMailOTPObsecure);
                                        },
                                      ),
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
                                      // hintText: 'emailOtp',
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
                                        // (value) {
                                        //   if ((value == null || value == "") &&
                                        //       (userRegnObj.mobileOtp == null ||
                                        //           userRegnObj.mobileOtp ==
                                        //               "")) {
                                        //     return 'Either Email OTP or Mobile OTP is required.';
                                        //   } else {
                                        //     return null;
                                        //   }
                                        // }
                                      ],
                                    ),
                                    name: 'emailOtp',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
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
                                    padding: const EdgeInsets.all(15),
                                    child: Container(
                                      child: FormBuilderTextField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(numbers))
                                        ],
                                        initialValue: userRegnObj.mobile,
                                        //attribute: "Name",
                                        maxLines: 1, cursorColor: blue,
                                        maxLength: 10,
                                        onChanged: (field) {
                                          userRegnObj.mobile = field;
                                          //      //print('Name ${enteredCaptcha}');
                                        },
                                        //       textCapitalization: TextCapitalization.characters,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0),
                                          prefixIcon:
                                              Icon(Icons.person, color: blue),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 2, color: blue),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 2, color: blue),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          // labelText: 'Username',
                                          // hintText: 'mobile',
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 16,
                                              letterSpacing: 1),
                                        ),
                                        validator:
                                            FormBuilderValidators.compose(
                                          [
                                            FormBuilderValidators.required(
                                              errorText: 'Required',
                                            ),
                                          ],
                                        ),
                                        name: 'mobile',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                  ),
                                ),
                                child: Text(
                                  'Get OTP in mobile',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  if (userRegnObj.mobile != null) {
                                    generateMobileOtp(userRegnObj.userId!,
                                        userRegnObj.mobile!);
                                  } else {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              actions: [
                                                ElevatedButton(
                                                  child: new Text('Ok',
                                                      style: TextStyle(
                                                          color: blue)),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                              title: Column(children: [
                                                Text('Enter mobile number'),
                                              ]));
                                        });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        if (isMobileOtpGenerated)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Enter OTP sent in mobile *',
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
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(alphaNumeric))
                                    ],
                                    initialValue: userRegnObj.mobileOtp,
                                    //attribute: "Name",
                                    obscureText: isMblOTPObsecure,
                                    maxLines: 1, cursorColor: blue,
                                    maxLength: 4,
                                    onChanged: (field) {
                                      userRegnObj.mobileOtp = field;
                                      //      //print('Name ${enteredCaptcha}');
                                    },
                                    //       textCapitalization: TextCapitalization.characters,
                                    textInputAction: TextInputAction.next,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: InputDecoration(
                                      // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                      suffixIcon: IconButton(
                                        icon: isMblOTPObsecure
                                            ? Icon(Icons.remove_red_eye)
                                            : Icon(
                                                Icons.highlight_remove_rounded),
                                        onPressed: () {
                                          isMblOTPObsecure =
                                              _toggle(isMblOTPObsecure);
                                        },
                                      ),
                                      prefixIcon:
                                          Icon(Icons.person, color: blue),
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
                                      // hintText: 'mobileOtp',
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
                                        // (value) {
                                        //   if ((value == null || value == "") &&
                                        //       (userRegnObj.emailOtp == null ||
                                        //           userRegnObj.emailOtp == "")) {
                                        //     return 'Either Email OTP or Mobile OTP is required.';
                                        //   } else {
                                        //     return null;
                                        //   }
                                        // }
                                      ],
                                    ),
                                    name: 'mobileotp',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (captchaForValidUser != null &&
                            captchaForValidUser != "")
                          Column(
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
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(alphaNumeric))
                                    ],
                                    initialValue: userRegnObj.captcha,
                                    //attribute: "Name",
                                    maxLines: 1, cursorColor: blue,
                                    maxLength: 6,
                                    onChanged: (field) {
                                      userRegnObj.captcha = field;
                                      //      //print('Name ${enteredCaptcha}');
                                    },
                                    //       textCapitalization: TextCapitalization.characters,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      // hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                      prefixIcon:
                                          Icon(Icons.person, color: blue),
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
                                      // hintText: 'mobileOtp',
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
                                    name: 'captcha',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            if ((userRegnObj.mobileOtp == null ||
                                    userRegnObj.mobileOtp == "") &&
                                (userRegnObj.emailOtp == null ||
                                    userRegnObj.emailOtp == "")) {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        actions: [
                                          ElevatedButton(
                                            child: new Text('Ok',
                                                style: TextStyle(
                                                    color:
                                                        Colors.blue.shade500)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                        title: Column(children: [
                                          Text(
                                              'Either Email OTP or Mobile OTP is required.'),
                                        ]));
                                  });
                            }

                            if (_fbKey.currentState!.saveAndValidate()) {
                              if (passwordtoReg != null &&
                                  passwordtoReg != "") {
                                passwordtoReg =
                                    new Utf8Encoder().convert(passwordtoReg);
                                //print('Original Password :$originalPassword');
                                var md5Password =
                                    crypto.md5.convert(passwordtoReg);
                                //print('md5 :$md5Password');
                                var md5PasswordString =
                                    hex.encode(md5Password.bytes);
                                //print('md5 String :$md5PasswordString');
                                var md5toSha256 =
                                    utf8.encode(md5PasswordString);
                                var convertedSha256Password =
                                    crypto.sha256.convert(md5toSha256);
                                var sha256PasswordString =
                                    hex.encode(convertedSha256Password.bytes);
                                passwordtoReg = sha256PasswordString;
                              }
                              if (confirmPasstoReg != null &&
                                  confirmPasstoReg != "") {
                                confirmPasstoReg =
                                    new Utf8Encoder().convert(confirmPasstoReg);
                                //print('Original Password :$originalPassword');
                                var md5Password =
                                    crypto.md5.convert(confirmPasstoReg);
                                //print('md5 :$md5Password');
                                var md5PasswordString =
                                    hex.encode(md5Password.bytes);
                                //print('md5 String :$md5PasswordString');
                                var md5toSha256 =
                                    utf8.encode(md5PasswordString);
                                var convertedSha256Password =
                                    crypto.sha256.convert(md5toSha256);
                                var sha256PasswordString =
                                    hex.encode(convertedSha256Password.bytes);
                                confirmPasstoReg = sha256PasswordString;
                              }
                              postUserRegnData();
                            } else {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        actions: [
                                          ElevatedButton(
                                            child: new Text('Ok',
                                                style: TextStyle(
                                                    color:
                                                        Colors.blue.shade500)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                        title: Column(children: [
                                          Text(
                                              'Please check the error message'),
                                        ]));
                                  });
                            }
                          },
                        ),
                      ],
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
