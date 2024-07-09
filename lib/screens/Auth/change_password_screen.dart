import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/screens/Auth/validateUsername.dart';
import 'package:formc_showcase/services/formC_commonServices.dart';
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final formKey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var currentPassword, newPassword, confirmPassword;
  bool isOldPswdObsecure = true;
  bool isNewPswdObsecure = true;
  bool isCnfrmPswdObsecure = true;
  SharedPreferences? logindata;
  Map? logOutResponse;
  _toggle(bool isobsecureStr) {
    setState(() {
      isobsecureStr = !isobsecureStr;
    });
    return isobsecureStr;
  }

  Future<Map> getLogResponse() async {
    var res4 = await http.get(Uri.parse(LOGOUT_URL), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    });
    var resBody4 = json.decode(res4.body);

    logOutResponse = resBody4;

    // //print(resBody4);

    return logOutResponse!;
  }

  String? token, acco, frro, userName;
  var status, responseJson;

  String url = LOGOUT_URL;

  changePasswordRequest() async {
    // // print('inside change func');
    EasyLoading.show(status: 'Please Wait...');
    token = await HttpUtils().getToken();
    var frroFroCode = await HttpUtils().getFrrocode();
    //// print('before data encode');
    var data = json.encode({
      "password": currentPassword,
      "newpassword": newPassword,
      "confirmpassword": confirmPassword,
      "frro_fro_code": frroFroCode
    });
    // print(data);
    try {
      await http.post(
        Uri.parse(url),
        body: data,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $token'
        },
      ).then((response) {
        //print("Response status: ${response.statusCode}");
        // print("Response body: ${response.body}");
        //// print(responseJson);
        responseJson = json.decode(response.body);

        // //print(chkuser);
        status = response.statusCode;
      });

      if ((responseJson['result'] == 'PASSWORD_CHANGE' && status == 200)) {
        // //print('Successfull');
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Password Changed Successfully'),
                actions: [
                  ElevatedButton(
                    child: new Text('Ok', style: TextStyle(color: blue)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ValidateUserScreen()));
                    },
                  ),
                ],
              );
            });
      }
      if ((responseJson['result'] == 'MATCHED_LAST_3_PASS' && status == 200)) {
        // //print('Successfull');
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Password cannot be same as 3 previous  passwords'),
                actions: [
                  ElevatedButton(
                    child: new Text('Ok', style: TextStyle(color: blue)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
      // if ((responseJson == 'PASSWORD_CHANGE' && status == 200)) {
      //   Utility.displaySnackBar(_scaffoldKey, 'Password changed successfully');
      //   return;
      // }
      if (status != 200) {
        var result = FormCCommonServices.getStatusCodeError(status);
        if (responseJson != null && responseJson["errors"] != null) {
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
                      Text('${responseJson["errors"]}'),
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
      /// // print(e);
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
                  Text("$e"),
                ]));
          });
    }
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
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
            )),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Text(' Change Password ',
                        style: TextStyle(
                            //   decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: blue)),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Center(
                        child: Image.asset(
                      'assets/images/change_password.jpg',
                      height: 135,
                      width: 135,
                    )),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: LABELPADDING),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Current Password *',
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
                    TextFormField(
                      // ignore: missing_return
                      validator: (value) {
                        if (value!.isEmpty ||
                            value.length < 1 ||
                            value.length > 50) {
                          return 'Please enter valid password';
                        }
                      },
                      maxLength: 15,
                      obscureText: isOldPswdObsecure,

                      //  onSaved: (val) => _password = val,
                      onChanged: (val) {
                        currentPassword = val;
                        //print('sha_256 pass: $_result');
                        //print('Original Pass: $val');
                      },
                      decoration: new InputDecoration(
                          suffixIcon: IconButton(
                            icon: isOldPswdObsecure
                                ? Icon(Icons.remove_red_eye)
                                : Icon(Icons.highlight_remove_rounded),
                            onPressed: () {
                              isOldPswdObsecure = _toggle(isOldPswdObsecure);
                            },
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: CONTENTPADDING),
                          prefixIcon: Icon(FontAwesomeIcons.lock, color: blue),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          // border: new OutlineInputBorder(
                          //     borderSide:
                          //         new BorderSide(color: Colors.blue[100])),
                          //labelText: 'Current Password',
                          // hintText: 'Enter your email-id',
                          //   helperText: 'As in passport',
                          //   icon: const Icon(Icons.person),
                          labelStyle: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: 1.5,
                              decorationStyle: TextDecorationStyle.solid)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: LABELPADDING),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'New Password *',
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
                    TextFormField(
                      // ignore: missing_return
                      validator: (value) {
                        RegExp regex = new RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[@#\$*]).{8,}$');
                        if (!regex.hasMatch(value!)) {
                          return 'Should contain minimum 8 charecters 1 uppercase,1 lowercase, 1 number, 1 special charecter';
                        }
                        if (value!.isEmpty ||
                            value.length < 1 ||
                            value.length > 20) {
                          return 'Please enter valid password';
                        }
                      },

                      maxLength: 20,
                      obscureText: isNewPswdObsecure,
                      //  onSaved: (val) => _password = val,
                      onChanged: (val) {
                        newPassword = val;
                        //print('sha_256 pass: $_result');
                        //print('Original Pass: $val');
                      },
                      decoration: new InputDecoration(
                          suffixIcon: IconButton(
                            icon: isNewPswdObsecure
                                ? Icon(Icons.remove_red_eye)
                                : Icon(Icons.highlight_remove_rounded),
                            onPressed: () {
                              isNewPswdObsecure = _toggle(isNewPswdObsecure);
                            },
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: CONTENTPADDING),
                          prefixIcon: Icon(FontAwesomeIcons.key, color: blue),
                          errorMaxLines: 3,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          // border: new OutlineInputBorder(
                          //     borderSide:
                          //         new BorderSide(color: Colors.blue[100])),
                          //   labelText: 'New Password',
                          // hintText: 'Enter your email-id',
                          //   helperText: 'As in passport',
                          //   icon: const Icon(Icons.person),
                          labelStyle: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: 1.5,
                              decorationStyle: TextDecorationStyle.solid)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: LABELPADDING),
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
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      // ignore: missing_return
                      validator: (value) {
                        RegExp regex = new RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[@#\$*]).{8,}$');
                        if (!regex.hasMatch(value!)) {
                          return 'Should contain minimum 8 charecters 1 uppercase,1 lowercase, 1 number, 1 special charecter';
                        }
                        if (value.isEmpty ||
                            value.length < 1 ||
                            value.length > 20) {
                          return 'Please enter valid password';
                        }
                      },
                      maxLength: 20,
                      obscureText: isCnfrmPswdObsecure,
                      //  onSaved: (val) => _password = val,
                      onChanged: (val) {
                        confirmPassword = val;
                        //print('sha_256 pass: $_result');
                        //print('Original Pass: $val');
                      },
                      decoration: new InputDecoration(
                          suffixIcon: IconButton(
                            icon: isCnfrmPswdObsecure
                                ? Icon(Icons.remove_red_eye)
                                : Icon(Icons.highlight_remove_rounded),
                            onPressed: () {
                              isCnfrmPswdObsecure =
                                  _toggle(isCnfrmPswdObsecure);
                            },
                          ),
                          errorMaxLines: 3,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: CONTENTPADDING),
                          prefixIcon: Icon(
                            Icons.vpn_key_sharp,
                            color: blue,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: BORDERWIDTH, color: blue),
                              borderRadius: BorderRadius.circular(10.0)),
                          // border: new OutlineInputBorder(
                          //     borderSide:
                          //         new BorderSide(color: Colors.blue[100])),
                          //    labelText: 'Confirm Password',
                          // hintText: 'Enter your email-id',
                          //   helperText: 'As in passport',
                          //   icon: const Icon(Icons.person),
                          labelStyle: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: 1.5,
                              decorationStyle: TextDecorationStyle.solid)),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    ButtonTheme(
                      minWidth: 250,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                          ),
                          primary: blue,
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (currentPassword != null &&
                                currentPassword != "") {
                              currentPassword =
                                  new Utf8Encoder().convert(currentPassword);
                              //print('Original Password :$originalPassword');
                              var md5Password =
                                  crypto.md5.convert(currentPassword);
                              //print('md5 :$md5Password');
                              var md5PasswordString =
                                  hex.encode(md5Password.bytes);
                              //print('md5 String :$md5PasswordString');
                              var md5toSha256 = utf8.encode(md5PasswordString);
                              var convertedSha256Password =
                                  crypto.sha256.convert(md5toSha256);
                              var sha256PasswordString =
                                  hex.encode(convertedSha256Password.bytes);
                              currentPassword = sha256PasswordString;
                            }
                            changePasswordRequest();
                            // Navigator.of(context)
                            //     .pushReplacementNamed("/loginScreen");
                            //  validateUser(getuserName);
                            //print('true');
                          }
                        },
                        child: Text(
                          'Change Password',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
