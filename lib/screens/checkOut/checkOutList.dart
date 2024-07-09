import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:developer' as developer;

import 'package:formc_showcase/models/getArrivalDetailsModel.dart';
import 'package:formc_showcase/screens/checkOut/checkOutDetailsPost.dart';
import 'package:formc_showcase/util/httpUtil.dart';
import 'package:formc_showcase/constants/formC_constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:formc_showcase/Widgets/myShimmerEffectUi.dart';

class CheckOutListScreen extends StatefulWidget {
  // const CheckOutListScreen({ Key? key }) : super(key: key);
  var appid, nationality, visano, passportno;
  DateTime? dateOfArrival;
  CheckOutListScreen(this.appid, this.nationality, this.visano, this.passportno,
      this.dateOfArrival);
  @override
  _CheckOutListScreenState createState() => _CheckOutListScreenState();
}

class _CheckOutListScreenState extends State<CheckOutListScreen> {
  List<ArrivalDetailsModel> arrivaldetails = [];
  List<ArrivalDetailsModel> searchedResultList = [];
  String? searchText;
  bool isFileNoExistsComplete = false;

  @override
  void initState() {
    super.initState();
    if (widget.appid != null) {
      //print('ApplicationId :${widget.appid}');
    }
    getArrivalDetails();
  }

  bool _enabled = true;
  bool isLoadingStatusComplete = false;
  Future<List> getArrivalDetails() async {
    var token = await HttpUtils().getToken();
    //print('id ${widget.appid}');
    // //print('passno $passportno');
    // //print('vno $visano');
    // // ignore: unnecessary_brace_in_string_interps
    print('date ${widget.dateOfArrival}');
    developer.log('date ${widget.dateOfArrival}');
    dynamic dateOfArrival;
    var userName = await HttpUtils().getUsername();
    var frroFroCode = await HttpUtils().getFrrocode();
    var accoCode = await HttpUtils().getAccocode();
    if (widget.dateOfArrival != "" && widget.dateOfArrival != null) {
      dateOfArrival = widget.dateOfArrival;
      // if (widget.dateofarrival != null) {
      //   widget.dateofarrival =
      //       DateFormat("dd/MM/yyyy").format(dateOfArrival);
      // }
      //print('dateofaari $dateOfArrival');
      dateOfArrival =
          "${dateOfArrival.day.toString().padLeft(2, '0')}-${dateOfArrival.month.toString().padLeft(2, '0')}-${dateOfArrival.year.toString().padLeft(4, '0')}";
      print('dateofaari $dateOfArrival');
    }
    var data = json.encode({
      "frro_fro_code": frroFroCode,
      "entered_by": userName,
      "form_c_appl_id": widget.appid,
      "acco_code": accoCode,
      "nationality": widget.nationality,
      "passport_no": widget.passportno,
      "date_of_arrival_in_hotel": dateOfArrival,
      "visa_no": widget.visano
    });
    //print(GET_ARRIVAL_DETAIL_URL);
    //print(data);
    await http.post(
      Uri.parse(GET_ARRIVAL_DETAIL_URL),
      body: data,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $token'
      },
    ).then((response) {
      //print("Response status: ${response.statusCode}");
      //print("Response body: ${response.body}");
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200)
        arrivaldetails = (responseJson as List)
            .map((i) => new ArrivalDetailsModel.fromJson(i))
            .toList();
      setState(() {
        isLoadingStatusComplete = true;
        isFileNoExistsComplete = true;
      });
      // chkuser = responseJson['username'];
      // token = responseJson['token'];
      // //print(chkuser);
      // status = response.statusCode;
      // //print(responseJson);
      // //print('arri $arrivaldetails1');
    });
    return arrivaldetails;
  }

  onSearchTextChanged(String text) async {
    searchedResultList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    if (arrivaldetails.isNotEmpty && arrivaldetails.length > 0) {
      arrivaldetails.forEach((userDetail) {
        try {
          if (userDetail.name!.contains(text) ||
              userDetail.passportNo!.contains(text) ||
              userDetail.formCApplId!.contains(text) ||
              userDetail.frroFroCode!.contains(text) ||
              userDetail.nationality!.contains(text) ||
              userDetail.visaNo!.contains(text) ||
              userDetail.dateOfArrivalInHotel!.contains(text) ||
              userDetail.timeOfArrivalInHotel!.contains(text) ||
              userDetail.nationalityName!.contains(text)) {
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
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10.0),
                      // fillColor: Colors.white,
                      // prefixIcon: Icon(FontAwesome.search, color: blue),
                      prefixIcon: IconButton(
                        icon: Icon(FontAwesomeIcons.search, color: blue),
                        onPressed: () {
                          onSearchTextChanged(searchText!);
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
                          arrivaldetails.isNotEmpty &&
                          arrivaldetails.length > 0)
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
                                    height: size.height * 0.22,
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
                                                .convert(
                                                    searchedResultList[index]
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
                                          (searchedResultList[index].name !=
                                                  null)
                                              ? Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                      'Name: ${searchedResultList[index].name}',
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
                                                      .nationalityName !=
                                                  null)
                                              ? Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                      'Nationality:${searchedResultList[index].nationalityName}',
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
                                                      .dateOfArrivalInHotel !=
                                                  null)
                                              ? Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                      'Date Of Arrival: ${searchedResultList[index].dateOfArrivalInHotel}',
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CheckOutDetails(
                                                    searchedResultList[index]
                                                        .formCApplId,
                                                    searchedResultList[index]
                                                        .frroFroCode,
                                                    searchedResultList[index]
                                                        .nationality,
                                                    searchedResultList[index]
                                                        .passportNo,
                                                  )),
                                        );
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
                                  itemCount: arrivaldetails.length,
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
                                            child: (arrivaldetails[index].img !=
                                                    "")
                                                ? Image.memory(Base64Decoder()
                                                    .convert(
                                                        arrivaldetails[index]
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
                                                    'Id: ${arrivaldetails[index].formCApplId}',
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
                                              (arrivaldetails[index].name !=
                                                      null)
                                                  ? Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                          'Name: ${arrivaldetails[index].name}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16.0,
                                                              letterSpacing:
                                                                  0.4)),
                                                    )
                                                  : Text(''),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              (arrivaldetails[index]
                                                          .nationalityName !=
                                                      null)
                                                  ? Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                          'Nationality:${arrivaldetails[index].nationalityName}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16.0,
                                                              letterSpacing:
                                                                  0.4)),
                                                    )
                                                  : Text(''),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              (arrivaldetails[index]
                                                          .dateOfArrivalInHotel !=
                                                      null)
                                                  ? Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                          'Date Of Arrival: ${arrivaldetails[index].dateOfArrivalInHotel}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16.0,
                                                              letterSpacing:
                                                                  0.4)),
                                                    )
                                                  : Text(''),
                                              SizedBox(
                                                height: 4,
                                              ),
                                            ],
                                          ),
                                          //    isThreeLine: true,
                                          dense: true,

                                          trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 26,
                                              color: Colors.black),

                                          onTap: () {
                                            //print('inside ontap');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CheckOutDetails(
                                                        arrivaldetails[index]
                                                            .formCApplId,
                                                        arrivaldetails[index]
                                                            .frroFroCode,
                                                        arrivaldetails[index]
                                                            .nationality,
                                                        arrivaldetails[index]
                                                            .passportNo,
                                                      )),
                                            );
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
          ),
        ),
      ),
    );
  }
}
