import 'package:flutter/material.dart';

import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/screens/Auth/change_password_screen.dart';
import 'package:formc_showcase/screens/Edit_FormC_application/pendingAppl_search.dart';
import 'package:formc_showcase/screens/FormCFullDetailsList/submittedAppl_search.dart';
import 'package:formc_showcase/screens/checkOut/checkOutSearchScreen.dart';
import 'package:formc_showcase/screens/splashScreen.dart';
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:http/http.dart' as http;
import '../screens/Others/editUserProfile.dart';

class FormCSideDrawer extends StatefulWidget {
  // const FormCSideDrawer({ Key? key }) : super(key: key);

  @override
  State<FormCSideDrawer> createState() => _FormCSideDrawerState();
}

class _FormCSideDrawerState extends State<FormCSideDrawer> {
  var token;
  @override
  void initState() {
    super.initState();
    getTokenInInit();
  }

  getTokenInInit() async {
    token = await HttpUtils().getToken();
    setState(() {
      token = token;
    });
  }

  getLogResponse() async {
    print(LOGOUT_URL);
    var logoutResponse = await http.post(Uri.parse(LOGOUT_URL), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    }).then((response) {
      print('Login Response code' + '${response.statusCode}');
      print('Login Response body' + '${response.body}');
      if (response.statusCode == 200) {
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => SplashScreen()));
      }
    });

    // print(resBody4);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 100.0,
            child: DrawerHeader(
                child: Center(
                    child: Text('Form C',
                        style: TextStyle(fontSize: 22, color: Colors.white))),
                decoration: BoxDecoration(color: blue),
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.all(0.0)),
          ),
          ListTile(
            leading: Icon(Icons.home, color: blue),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/homeScreen");
            },
          ),
          ListTile(
            leading: Icon(Icons.details, color: blue),
            title: Text('New FormC Entry'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/checkInSearch");
            },
          ),
          ListTile(
            leading: Icon(Icons.edit, color: blue),
            title: Text('Pending/ Temporary Saved Data'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => PendingApplicationSearch()));
            },
          ),
          ListTile(
            leading: Icon(Icons.list, color: blue),
            title: Text('Submitted Form C Details'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => SubmittedApplicationSearch()));
            },
          ),
          ListTile(
            leading: Icon(Icons.check_box, color: blue),
            title: Text('Check Out Details'),
            onTap: () {
              //  logindata.setBool('login', true);
              Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => CheckOutSearchScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.vpn_key_sharp, color: blue),
            title: Text('Change Password'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => ChangePasswordPage()));
            },
          ),
          // ListTile(
          //   leading: Icon(FontAwesome.pencil_square, color: blue),
          //   title: Text('Edit User Profile'),
          //   onTap: () {
          //     Navigator.pushReplacement(
          //         context,
          //         new MaterialPageRoute(
          //             builder: (context) => EditUserProdile()));
          //   },
          // ),
          // ListTile(
          //   leading: Icon(FontAwesome.pencil_square_o, color: blue),
          //   title: Text('Edit Accomodator Profile'),
          //   onTap: () {
          //     // Navigator.pushReplacement(
          //     //     context,
          //     //     new MaterialPageRoute(
          //     //         builder: (context) => ChangePasswordPage()));
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.logout, color: blue),
            title: Text('Logout'),
            onTap: () {
              HttpUtils().clearTokens();
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
      ),
    );
  }
}
