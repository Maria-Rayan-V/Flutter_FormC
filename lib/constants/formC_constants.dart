library formc_constants;

import 'package:flutter/cupertino.dart';

const Color blue = Color.fromRGBO(17, 64, 113, 1.0);
const double FIELDPADDING = 1.0;
const double CONTENTPADDING = 10.0;
const double LABELPADDING = 12.0;
const double LEFTPADDING = 12.0;
const double RIGHTPADDING = 12.0;
const double TOPPADDING = 6.0;
const int DOBYEAR = 100;
const MAX_LENGTH_TEXTFIELD = 50;
const MAX_LENGTH_PASSPORT_VISA = 20;
const MAX_LENGTH_ADDRESS = 150;
const MAX_LENGTH_PINCODE = 6;
const MAX_LENGTH_MBL_PHN_NUM = 15;
const double RAISEDBUTTON_HEIGHT = 40;
const double RAISEDBUTTON_WIDTH = 270;
const double BORDERWIDTH = 0.5;

List DOBFORMATLIST = [
  {"dobFormat_code": "DD", "dobFormat_desc": "DD/MM/YYYY"},
  {"dobFormat_code": "MM", "dobFormat_desc": "MM/YYYY"},
  {"dobFormat_code": "YY", "dobFormat_desc": "YYYY"},
  {"dobFormat_code": "XX", "dobFormat_desc": "Age in XX years"},
];
List GENDERLIST = [
  {"gender_code": "F", "gender_desc": "Female"},
  {"gender_code": "M", "gender_desc": "Male"},
  {"gender_code": "X", "gender_desc": "Transgender"}
];
final List<dynamic> HOMEPAGESCROLLIMAGELIST = [
  'https://media.istockphoto.com/photos/the-india-gate-in-delhi-picture-id898467608?b=1&k=20&m=898467608&s=170667a&w=0&h=HlThQtBd6DV7ceWb25DBticSPDyKoCUnTfDy1vgQH0A=',
  'https://images.unsplash.com/photo-1564507592333-c60657eea523?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8dGFqJTIwbWFoYWx8ZW58MHx8MHx8&w=1000&q=80',
  //'httpss://i.pinimg.com/736x/76/08/ea/7608eaefb21bb780c94474eefbe942b1.jpg',
  'https://www.tourmyindia.com/blog//wp-content/uploads/2018/06/Hotels-in-India.jpg',
  'https://wallpaperaccess.com/full/2631237.jpg',
  'https://gos3.ibcdn.com/13afc4e8a99311e7a17e02755708f0b3.jpg'
];
// const String FORMC_GOV = "http://localhost:8082/formc";
//  const String FORMC_GOV = "https://indianfrro.gov.in/formc";
const String FORMC_GOV = "http://10.199.62.92:8082/formc";
//  const String FORMC_GOV = "http://localhost:8082/formc";
const LOGOUT_URL = FORMC_GOV + "/formcLogout";
const GET_COUNTRY_URL = FORMC_GOV + "/masters/country/";
const GET_ARRIVAL_DETAIL_URL = FORMC_GOV + "/get-arrivaldetail";
const GET_DEPART_DETAIL_URL = FORMC_GOV + "/departdetail";
const GET_SPLCATEGORY_URL = FORMC_GOV + "/masters/spl-category/";
const GET_FRRO_LIST = FORMC_GOV + "/masters/formc/frro-list/";
const GET_STATE_URL = FORMC_GOV + "/masters/state/";
const GET_DISTRICT_URL = FORMC_GOV + "/masters/district-list/";
const GET_VISATYPE = FORMC_GOV + "/masters/visa-type/";
const GET_VISASUBTYPE = FORMC_GOV + "/masters/visa-subtype/";
const GET_ACCO_TYPE = FORMC_GOV + "/masters/accommodation-type/";
const GET_ACCO_GRADE = FORMC_GOV + "/masters/accommodation-grade/";
const GET_VISIT_PURPOSE_URL = FORMC_GOV + "/masters/visit-purpose/";
const POST_FORMC_DATA_URL = FORMC_GOV + "/form-c";
const GET_APPDETAILSBY_PASSPORTANDNATIONALITY_URL =
    FORMC_GOV + "/appdetail-by-passnum?";
const GET_APPLICANT_FULLDETAILS_URL = FORMC_GOV + "/appdetail-by-appid?appid=";
const GET_APPLICANTS_LIST = FORMC_GOV + "/userdetail?accoCode=";
const AUTHENTICATE_URL = FORMC_GOV + "/authenticate";
const GET_SALT_URL = FORMC_GOV + "/valid-user/formc/";
const GENERATE_APPLID = FORMC_GOV + "/genrate-appid";
const POST_PERSONAL_DETAILS = FORMC_GOV + "/submit-personaldetails";
const POST_PASSPORTVISA_DETAILS = FORMC_GOV + "/submit-passport-visa";
const REFRESH_CAPTCHA_URL = FORMC_GOV + "/valid-user/formc/refresh-captcha/";
const POST_ARRIVALNXTDEST_DETAILS = FORMC_GOV + "/submit-arrival-nextdest";
const POST_REFERENCEOTHERS_DETAILS = FORMC_GOV + "/submit-refrence-contact";
const PHOTO_UPLOAD_URL = FORMC_GOV + "/submit-photo";
const FINAL_SUBMIT_URL = FORMC_GOV + "/formc-final-submit?appid=";
const PENDING_FORMC_DETAILS_LIST = FORMC_GOV + "/pending-app-list?frroCode=";
const GET_FORMC_TEMPDETAILSBYAPPLID = FORMC_GOV + "/edit-application?appid=";
const GET_FORMC_PENDINGAPPL_BYPASSNOANDNAT =
    FORMC_GOV + "/pending-appdetail-by-passno-nat?passportNo=";
const GET_FORMC_SUBMITTEDAPPLBY_PPTNOANDNAT =
    FORMC_GOV + "/submitted-appdetail-by-passno-nat?passportNo=";
const CHANGE_PASSWORD_URL = FORMC_GOV + "/change-passward";
const VALIDUSER_REGN_CAPTCHA = FORMC_GOV + "/valid-user/formc/reg-captcha/";
const GET_MOBILE_OTP = FORMC_GOV + '/valid-user/formc/mobile-otp/';
const GET_EMAIL_OTP = FORMC_GOV + '/valid-user/formc/email-otp/';
const POST_USER_REGN_DTS = FORMC_GOV + '/valid-user/formc/submit-user-details';
const POST_ACCOM_DTS = FORMC_GOV + '/submit-accomdator-details';
const GET_ACCOM_DETAILS = FORMC_GOV + '/get-accommodator-details?acco_code=';
const POST_USR_PROF = FORMC_GOV + '/update-profile';
// const LOGOUT_URL = "https://indianfrro.gov.in/efrrows2/formc/logout";
// const GET_COUNTRY_URL = "https://indianfrro.gov.in/efrrows2/masters/country/";
// const GET_ARRIVAL_DETAIL_URL =
//     "https://indianfrro.gov.in/efrrows2/formc/get-arrivaldetail";
// const GET_DEPART_DETAIL_URL =
//     "https://indianfrro.gov.in/efrrows2/formc/departdetail";
// const GET_SPLCATEGORY_URL =
//     "https://indianfrro.gov.in/efrrows2/masters/spl-category/";
// const GET_STATE_URL = "https://indianfrro.gov.in/efrrows2/masters/state/";
// const GET_DISTRICT_URL =
//     "https://indianfrro.gov.in/efrrows2/masters/district-list/";
// const GET_VISATYPE = "https://indianfrro.gov.in/efrrows2/masters/visa-type/";
// const GET_VISASUBTYPE =
//     "https://indianfrro.gov.in/efrrows2/masters/visa-subtype/";
// const GET_VISIT_PURPOSE_URL =
//     "https://indianfrro.gov.in/efrrows2/masters/visit-purpose/";
// const POST_FORMC_DATA_URL = "https://indianfrro.gov.in/efrrows2/formc/form-c";
// const GET_APPDETAILSBY_PASSPORTANDNATIONALITY_URL =
//     "https://indianfrro.gov.in/efrrows2/formc/appdetail-by-passnum?";
// const GET_APPLICANT_FULLDETAILS_URL =
//     "https://indianfrro.gov.in/efrrows2/formc/appdetail-by-appid?appid=";
// const GET_APPLICANTS_LIST =
//     "https://indianfrro.gov.in/efrrows2/formc/userdetail?accoCode=";
// const AUTHENTICATE_URL = "https://indianfrro.gov.in/efrrows2/authenticate";
// const GET_SALT_URL = "https://indianfrro.gov.in/efrrows2/valid-user/formc/";
// const GENERATE_APPLID =
//     "https://indianfrro.gov.in/efrrows2/formc/genrate-appid";
// const POST_PERSONAL_DETAILS =
//     "https://indianfrro.gov.in/efrrows2/formc/submit-personaldetails";
// const POST_PASSPORTVISA_DETAILS =
//     "https://indianfrro.gov.in/efrrows2/formc/submit-passport-visa";
// const REFRESH_CAPTCHA_URL =
//     "https://indianfrro.gov.in/efrrows2/valid-user/formc/refresh-captcha/";
// const POST_ARRIVALNXTDEST_DETAILS =
//     "https://indianfrro.gov.in/efrrows2/formc/submit-arrival-nextdest";
// const POST_REFERENCEOTHERS_DETAILS =
//     "https://indianfrro.gov.in/efrrows2/formc/submit-refrence-contact";
// const PHOTO_UPLOAD_URL =
//     "https://indianfrro.gov.in/efrrows2/formc/submit-photo";
// const FINAL_SUBMIT_URL =
//     "https://indianfrro.gov.in/efrrows2/formc/formc-final-submit?appid=";
// const PENDING_FORMC_DETAILS_LIST =
//     "https://indianfrro.gov.in/efrrows2/formc/pending-app-list?frroCode=";
// const GET_FORMC_TEMPDETAILSBYAPPLID =
//     "https://indianfrro.gov.in/efrrows2/formc/edit-application?appid=";
// const GET_FORMC_PENDINGAPPL_BYPASSNOANDNAT =
//     "https://indianfrro.gov.in/efrrows2/formc/pending-appdetail-by-passno-nat?passportNo=";
// const GET_FORMC_SUBMITTEDAPPLBY_PPTNOANDNAT =
//     "https://indianfrro.gov.in/efrrows2/formc/submitted-appdetail-by-passno-nat?passportNo=";
// const CHANGE_PASSWORD_URL =
//     "https://indianfrro.gov.in/efrrows2/formc/change-passward";
// const POST_USER_REGN_DTS =
//     "https://indianfrro.gov.in/efrrows2/formc/submit-user-details";
// const POST_ACCOM_DTS =
//     "https://indianfrro.gov.in/efrrows2/formc/submit-accomdator-details";
// const VALIDUSER_REGN_CAPTCHA =
//     "https://indianfrro.gov.in/efrrows2/formc/valid-user/formc/reg-captcha/";
// const GET_MOBILE_OTP =
//     "https://indianfrro.gov.in/efrrows2/formc/valid-user/formc/mobile-otp/";
// const GET_EMAIL_OTP =
//     "https://indianfrro.gov.in/efrrows2/formc/valid-user/formc/email-otp/";
// const GET_ACCO_TYPE =
//     "https://indianfrro.gov.in/efrrows2/masters/accomodation-type/";
// const GET_ACCO_GRADE = "https://indianfrro.gov.in/efrrows2/masters/acco-grade/";
// const GET_FRRO_LIST =
//     "https://indianfrro.gov.in/efrrows2/masters/formc/frro-list/";
