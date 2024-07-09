import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:http/retry.dart';
import 'package:shimmer/shimmer.dart';
import 'package:formc_showcase/Widgets/myShimmerEffectUi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FullDetailsDisplayScreen extends StatefulWidget {
  dynamic applicationId;

  FullDetailsDisplayScreen(
      {Key? key, @required this.applicationId, String? appId})
      : super(key: key);

  @override
  _FullDetailsDisplayScreenState createState() =>
      _FullDetailsDisplayScreenState();
}

class _FullDetailsDisplayScreenState extends State<FullDetailsDisplayScreen> {
  var formCFullDetails;
  bool _enabled = true;
  Future<List> getSavedFormCDataByAppId(String appid) async {
    // print('id: $appid');
    var token = await HttpUtils().getToken();
    print('Token $token');
    try {
      print(GET_APPLICANT_FULLDETAILS_URL + '${appid}');
      var res = await http.get(Uri.parse(
          // ignore: unnecessary_brace_in_string_interps
          GET_APPLICANT_FULLDETAILS_URL + '${appid}'), headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      });

      var resBody = json.decode(res.body);

      formCFullDetails = resBody;
      // given_name = resBody['form_c_appl_id'];

      print('Full Details $formCFullDetails');
    } catch (e) {
      //   print(e);
    }

    return formCFullDetails;
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );

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
        body: FutureBuilder(
          future: getSavedFormCDataByAppId(widget.applicationId),
          // ignore: missing_return
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  // ignore: unused_local_variable
                  //  Profile profile = Profile.fromMap(snapshot.data[index]);
                  return Card(
                      //  color: Colors.blue[50],
                      child: SingleChildScrollView(
                    child: Container(
                        child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // child: ListTile(
                          //   // leading: Icon(
                          //   //   Icons.person,
                          //   //   color: Colors.black,
                          //   // ),
                          //   title: Text(
                          //     snapshot.data[index]['name'] != null
                          //         ? 'Name : ${snapshot.data[index]['name']}'
                          //         : 'Name: Rayan',
                          //     style:
                          //         TextStyle(fontSize: 17, color: Colors.black),
                          //     //  textAlign: TextAlign.center,
                          //   ),
                          // ),
                          // Text(snapshot.data[index]['img']),
                          // Center(
                          //   child: InkWell(
                          //     // onTap: getImage,

                          //     child: CircleAvatar(
                          //       minRadius: 60.0,
                          //       maxRadius: 60,
                          //       child: ClipOval(
                          //         child: (snapshot.data[index]['img'] != null)
                          //             ? Image.memory(Base64Decoder()
                          //                 .convert(snapshot.data[index]['img']))
                          //             : Icon(
                          //                 Icons.person,
                          //                 size: 100,
                          //               ),
                          //       ),
                          //       backgroundColor: Colors.transparent,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //     height: 10,
                          //   ),
                          Center(
                            child: Text(' Form C Details ',
                                style: TextStyle(
                                    //   decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: blue)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: ExpansionTileCard(
                              animateTrailing: true,
                              colorCurve: Curves.easeIn,
                              leading: CircleAvatar(
                                  backgroundColor: blue,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  )),
                              title: Text('Personal Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                      color: Colors.black)),
                              subtitle: Text(
                                snapshot.data[index]['name'] != null
                                    ? 'Name : ${snapshot.data[index]['name']}'
                                    : 'Name: ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                                //  textAlign: TextAlign.center,
                              ),
                              children: <Widget>[
                                Center(
                                  child: InkWell(
                                    // onTap: getImage,

                                    child: CircleAvatar(
                                      minRadius: 60.0,
                                      maxRadius: 60,
                                      child: ClipOval(
                                        child: (snapshot.data[index]['img'] !=
                                                "")
                                            ? Image.memory(Base64Decoder()
                                                .convert(snapshot.data[index]
                                                    ['img']))
                                            : Icon(
                                                Icons.person,
                                                size: 100,
                                              ),
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.005,
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(17, 64, 113, 1.0),
                                        Colors.grey[900]!
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['form_c_appl_id'] !=
                                                  null
                                              ? 'Application ID : ${snapshot.data[index]['form_c_appl_id']}'
                                              : 'Application Id: ',

                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]['surname'] !=
                                                  null
                                              ? 'Surname : ${snapshot.data[index]['surname']}'
                                              : '',

                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]['genderDesc'] !=
                                                  null
                                              ? 'Gender: ${snapshot.data[index]['genderDesc']}'
                                              : 'Gender: ',

                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          // textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]['dob'] != null
                                              ? 'Date Of Birth: ${snapshot.data[index]['dob']}'
                                              : 'Date Of Birth:',

                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: SizedBox(
                                          height: 10,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['nationalityDesc'] !=
                                                  null
                                              ? 'Nationality : ${snapshot.data[index]['nationalityDesc']}'
                                              : 'Nationality : ',

                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['employedinind'] !=
                                                  null
                                              ? 'Employed In India: ${snapshot.data[index]['employedinind']}'
                                              : 'Employed In India: ',

                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['purposeofvisitDesc'] !=
                                                  null
                                              ? 'Purpose Of Visit: ${snapshot.data[index]['purposeofvisitDesc']}'
                                              : 'Purpose Of Visit: ',

                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          // textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['splcategorycodeDesc'] !=
                                                  null
                                              ? 'Special Category: ${snapshot.data[index]['splcategorycodeDesc']}'
                                              : 'Spl Category Code: ',

                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          // textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: ExpansionTileCard(
                              animateTrailing: true,
                              colorCurve: Curves.easeIn,
                              leading: CircleAvatar(
                                  backgroundColor: blue,
                                  child: Icon(
                                    FontAwesomeIcons.solidAddressBook,
                                    color: Colors.white,
                                  )),
                              title: Text('Address Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                      color: Colors.black)),
                              subtitle: Text(
                                snapshot.data[index]['addroutind'] != null
                                    ? 'Address : ${snapshot.data[index]['addroutind']}'
                                    : 'Address Outside India : ',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                                // textAlign: TextAlign.center,
                              ),
                              children: <Widget>[
                                // onTap: getImage,

                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(17, 64, 113, 1.0),
                                        Colors.grey[900]!
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]['cityoutind'] !=
                                                  null
                                              ? 'City: ${snapshot.data[index]['cityoutind']}'
                                              : 'City Outside India:  ',

                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['counoutindDesc'] !=
                                                  null
                                              ? 'Country: ${snapshot.data[index]['counoutindDesc']}'
                                              : 'Country Outside India: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: ExpansionTileCard(
                              animateTrailing: true,
                              colorCurve: Curves.easeIn,
                              leading: CircleAvatar(
                                  backgroundColor: blue,
                                  child: Icon(
                                    FontAwesomeIcons.personBooth,
                                    color: Colors.white,
                                  )),
                              title: Text('Reference Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                      color: Colors.black)),
                              subtitle: Text(
                                snapshot.data[index]['addrofrefinind'] != null
                                    ? 'Address: ${snapshot.data[index]['addrofrefinind']}'
                                    : 'Address Of Reference In India: ',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                                // textAlign: TextAlign.center,
                              ),
                              children: <Widget>[
                                // onTap: getImage,

                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(17, 64, 113, 1.0),
                                        Colors.grey[900]!
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['stateofrefinindDesc'] !=
                                                  null
                                              ? 'State: ${snapshot.data[index]['stateofrefinindDesc']}'
                                              : 'State Of Reference In India:',

                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['cityofrefinindDesc'] !=
                                                  null
                                              ? 'City: ${snapshot.data[index]['cityofrefinindDesc']}'
                                              : 'City Of Reference In India: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['pincodeofref'] !=
                                                  null
                                              ? 'Pincode: ${snapshot.data[index]['pincodeofref']}'
                                              : 'Pincode Of Reference In India:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: ExpansionTileCard(
                              animateTrailing: true,
                              colorCurve: Curves.easeIn,
                              leading: CircleAvatar(
                                  backgroundColor: blue,
                                  child: Icon(
                                    FontAwesomeIcons.passport,
                                    color: Colors.white,
                                  )),
                              title: Text('Passport Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                      color: Colors.black)),
                              subtitle: Text(
                                snapshot.data[index]['passnum'] != null
                                    ? 'Passport Number : ${snapshot.data[index]['passnum']}'
                                    : 'Passport Number :',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                                // textAlign: TextAlign.center,
                              ),
                              children: <Widget>[
                                // onTap: getImage,

                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(17, 64, 113, 1.0),
                                        Colors.grey[900]!
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]['passdate'] !=
                                                  null
                                              ? 'Date Of Issue: ${snapshot.data[index]['passdate']}'
                                              : 'Date Of Issue:',

                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]['passexpdate'] !=
                                                  null
                                              ? 'Expiry Date: ${snapshot.data[index]['passexpdate']}'
                                              : 'Expiry Date: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['passcounDesc'] !=
                                                  null
                                              ? 'Country Of Issue: ${snapshot.data[index]['passcounDesc']}'
                                              : 'Passport Issued Country:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]['passplace'] !=
                                                  null
                                              ? 'Place Of Issue: ${snapshot.data[index]['passplace']}'
                                              : 'Passport Place Of Issue:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: ExpansionTileCard(
                              animateTrailing: true,
                              colorCurve: Curves.easeIn,
                              leading: CircleAvatar(
                                  backgroundColor: blue,
                                  child: Icon(
                                    FontAwesomeIcons.ccVisa,
                                    color: Colors.white,
                                  )),
                              title: Text('Visa Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                      color: Colors.black)),
                              subtitle: Text(
                                snapshot.data[index]['visanum'] != null
                                    ? 'Visa Number: ${snapshot.data[index]['visanum']}'
                                    : 'Visa Number: ',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                                //  textAlign: TextAlign.center,
                              ),
                              children: <Widget>[
                                // onTap: getImage,

                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(17, 64, 113, 1.0),
                                        Colors.grey[900]!
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['visacounDesc'] !=
                                                  null
                                              ? 'Issued Country: ${snapshot.data[index]['visacounDesc']}'
                                              : 'Visa Issued Country:',

                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['visatypeDesc'] !=
                                                  null
                                              ? 'Visatype: ${snapshot.data[index]['visatypeDesc']}'
                                              : 'Visatype: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['visasubtypeDesc'] !=
                                                  null
                                              ? 'Visa Subtype: ${snapshot.data[index]['visasubtypeDesc']}'
                                              : 'Visa Subtype: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]['visadate'] !=
                                                  null
                                              ? 'Date Of Issue: ${snapshot.data[index]['visadate']}'
                                              : 'Visa Date Of Issue:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]['visaexpdate'] !=
                                                  null
                                              ? 'Expiry Date: ${snapshot.data[index]['visaexpdate']}'
                                              : 'Visa Expiry Date:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]['visaplace'] !=
                                                  null
                                              ? 'Place Of Issue: ${snapshot.data[index]['visaplace']}'
                                              : 'Visa Place Of Issue: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: ExpansionTileCard(
                              animateTrailing: true,
                              colorCurve: Curves.easeIn,
                              leading: CircleAvatar(
                                  backgroundColor: blue,
                                  child: Icon(
                                    FontAwesomeIcons.bus,
                                    color: Colors.white,
                                  )),
                              title: Text('Arrival Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                      color: Colors.black)),
                              subtitle: Text(
                                snapshot.data[index]['arricit'] != null
                                    ? 'Arrived From City: ${snapshot.data[index]['arricit']}'
                                    : 'Arrived From City: ',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                                // textAlign: TextAlign.center,
                              ),
                              children: <Widget>[
                                // onTap: getImage,

                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(17, 64, 113, 1.0),
                                        Colors.grey[900]!
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]['arriplace'] !=
                                                  null
                                              ? 'Arrived From Place: ${snapshot.data[index]['arriplace']}'
                                              : 'Arrived From Place: ',

                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['arricounDesc'] !=
                                                  null
                                              ? 'Arrived From Country: ${snapshot.data[index]['arricounDesc']}'
                                              : 'Arrived From Country: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['arridatehotel'] !=
                                                  null
                                              ? 'Date Of Arrival In Hotel: ${snapshot.data[index]['arridatehotel']}'
                                              : 'Date Of Arrival In Hotel:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]['arridateind'] !=
                                                  null
                                              ? 'Date Of Arrival In India: ${snapshot.data[index]['arridateind']}'
                                              : 'Date Of Arrival In India:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['arritimehotel'] !=
                                                  null
                                              ? 'Time Of Arrival In Hotel: ${snapshot.data[index]['arritimehotel']}'
                                              : 'Time Of Arrival In Hotel: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]
                                                      ['durationofstay'] !=
                                                  null
                                              ? 'Intended Duration Of Stay In Hotel: ${snapshot.data[index]['durationofstay']}'
                                              : 'Intended Duration Of Stay In Hotel:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: ExpansionTileCard(
                              animateTrailing: true,
                              colorCurve: Curves.easeIn,
                              leading: CircleAvatar(
                                  backgroundColor: blue,
                                  child: Icon(
                                    FontAwesomeIcons.directions,
                                    color: Colors.white,
                                  )),
                              title: Text('Next Destination Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                      color: Colors.black)),
                              subtitle: Text(
                                snapshot.data[index]['nextdestcounflag'] != null
                                    ? snapshot.data[index]
                                                ['nextdestcounflag'] ==
                                            'I'
                                        ? 'Inside India'
                                        : 'Outside India'
                                    : '',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                                // textAlign: TextAlign.center,
                              ),
                              children: <Widget>[
                                // onTap: getImage,

                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(17, 64, 113, 1.0),
                                        Colors.grey[900]!
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(children: [
                                      if (snapshot.data[index]
                                              ['nextdestcounflag'] ==
                                          'I')
                                        Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                snapshot.data[index][
                                                            'nextdestplaceinind'] !=
                                                        null
                                                    ? 'Next Destination Place In India: ${snapshot.data[index]['nextdestplaceinind']}'
                                                    : 'Next Destination Place In India: Nil',

                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17,
                                                    color: Colors.white),
                                                //  textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                snapshot.data[index][
                                                            'nextdestdistinindDesc'] !=
                                                        null
                                                    ? 'Next Destination City Inside India: ${snapshot.data[index]['nextdestdistinindDesc']}'
                                                    : 'Next Destination City Inside India : Nil',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17,
                                                    color: Colors.white),
                                                //  textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                snapshot.data[index][
                                                            'nextdeststateinindDesc'] !=
                                                        null
                                                    ? 'Next Destination State Inside India: ${snapshot.data[index]['nextdeststateinindDesc']}'
                                                    : 'Next Destination State Inside India:Nil',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17,
                                                    color: Colors.white),
                                                //  textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      if (snapshot.data[index]
                                              ['nextdestcounflag'] ==
                                          'O')
                                        Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                snapshot.data[index][
                                                            'nextdestcityoutind'] !=
                                                        null
                                                    ? 'Next Destination City Outside India: ${snapshot.data[index]['nextdestcityoutind']}'
                                                    : 'Next Destination City Outside India: Nil',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17,
                                                    color: Colors.white),
                                                //  textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                snapshot.data[index][
                                                            'nextdestplaceoutind'] !=
                                                        null
                                                    ? 'Next Destination Place Outside India: ${snapshot.data[index]['nextdestplaceoutind']}'
                                                    : 'Next Destination Place Outside India:Nil',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17,
                                                    color: Colors.white),
                                                //  textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                snapshot.data[index][
                                                            'nextdestcounoutindDesc'] !=
                                                        null
                                                    ? 'Next Destination Country Outside India: ${snapshot.data[index]['nextdestcounoutindDesc']}'
                                                    : 'Next Destination Country Outside India:Nil',

                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17,
                                                    color: Colors.white),
                                                //  textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: ExpansionTileCard(
                              animateTrailing: true,
                              colorCurve: Curves.easeIn,
                              leading: CircleAvatar(
                                  backgroundColor: blue,
                                  child: Icon(
                                    FontAwesomeIcons.solidAddressBook,
                                    color: Colors.white,
                                  )),
                              title: Text('Contact Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                      color: Colors.black)),
                              subtitle: Text(
                                snapshot.data[index]['mblnum'] != null
                                    ? 'Mobile Number: ${snapshot.data[index]['mblnum']}'
                                    : '',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                                //   textAlign: TextAlign.center,
                              ),
                              children: <Widget>[
                                // onTap: getImage,

                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(17, 64, 113, 1.0),
                                        Colors.grey[900]!
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]['phnnum'] != null
                                              ? 'Phone Number: ${snapshot.data[index]['phnnum']}'
                                              : '',

                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]['phnnum'] != null
                                              ? 'Mobile Number In India: ${snapshot.data[index]['mblnuminind']}'
                                              : '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          snapshot.data[index]['phnnuminind'] !=
                                                  null
                                              ? 'Phone Number In India: ${snapshot.data[index]['phnnuminind']}'
                                              : '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                          //  textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    )),
                  ));
                },
              );
            }
            if (snapshot.data == null || snapshot.data.length == 0) {
              return SizedBox(
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
                          leading:
                              MyShimmerEffectUI.circular(height: 60, width: 60),
                          title: Align(
                            alignment: Alignment.centerLeft,
                            child: MyShimmerEffectUI.rectangular(
                                height: 18,
                                width:
                                    MediaQuery.of(context).size.width * 0.35),
                          ),
                          subtitle: MyShimmerEffectUI.rectangular(height: 16),
                        );
                      }),
                ),
              );
            } else {
              return Text('');
            }
          },
        ),
      ),
    );
  }
}
