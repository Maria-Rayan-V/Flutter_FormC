import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class HttpUtils {
  final _storage = storage.FlutterSecureStorage();

  saveToken(String token) async =>
      await _storage.write(key: 'auth_token', value: token);

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  saveUsername(String formCUsername) async =>
      await _storage.write(key: 'formC-username', value: formCUsername);

  Future<String?> getUsername() async {
    return await _storage.read(key: 'formC-username');
  }

  saveSalt(String saltfromResponse) async =>
      await _storage.write(key: 'saltFromResponse', value: saltfromResponse);

  Future<String?> getSalt() async {
    return await _storage.read(key: 'saltFromResponse');
  }

  saveCaptcha(String captcha) async =>
      await _storage.write(key: 'captcha', value: captcha);

  Future<String?> getCaptcha() async {
    return await _storage.read(key: 'captcha');
  }

  saveAccocode(String accoCode) async =>
      await _storage.write(key: 'formCAccoCode', value: accoCode);

  Future<String?> getAccocode() async {
    return await _storage.read(key: 'formCAccoCode');
  }

  saveAccoName(String accoName) async =>
      await _storage.write(key: 'formCAccoName', value: accoName);

  Future<String?> getAccoName() async {
    return await _storage.read(key: 'formCAccoName');
  }

  saveFrroCode(String frroCode) async =>
      await _storage.write(key: 'formCFrroCode', value: frroCode);

  Future<String?> getFrrocode() async {
    return await _storage.read(key: 'formCFrroCode');
  }

  saveLastLogin(String lastLogin) async =>
      await _storage.write(key: 'formCLastLogin', value: lastLogin);

  Future<String?> getLastLogin() async {
    return await _storage.read(key: 'formCLastLogin');
  }

  saveExistingFormCPptNo(String? existingFormcPptNo) async => await _storage
      .write(key: 'formCExistingPptNo', value: existingFormcPptNo);

  Future<String?> getExistingFormCPptNo() async {
    return await _storage.read(key: 'formCExistingPptNo');
  }

  saveExistingFormCNationality(String? existingFormCNat) async => await _storage
      .write(key: 'formCExistingNationality', value: existingFormCNat);

  Future<String?> getExistingFormCNationality() async {
    return await _storage.read(key: 'formCExistingNationality');
  }

  savePendingApplicationId(String? pendingApplicationId) async => await _storage
      .write(key: 'formC_pending-application_id', value: pendingApplicationId);

  Future<String?> getPendingApplicationId() async {
    return await _storage.read(key: 'formC_pending-application_id');
  }

  saveNewApplicationId(String? applicationId) async =>
      await _storage.write(key: 'formC_application_id', value: applicationId);

  Future<String?> getNewApplicationId() async {
    return await _storage.read(key: 'formC_application_id');
  }

  saveApplicantCountryOutsideIndia(String countryOutsideInd) async =>
      await _storage.write(
          key: 'formCApplicantCountryOutsideIndia', value: countryOutsideInd);

  Future<String?> getApplicantCountryOutsideIndia() async {
    return await _storage.read(key: 'formCApplicantCountryOutsideIndia');
  }

  saveApplicantGivenName(String givenName) async =>
      await _storage.write(key: 'formCApplicantGivenName', value: givenName);

  Future<String?> getApplicantGivenName() async {
    return await _storage.read(key: 'formCApplicantGivenName');
  }

  saveApplicantSurname(String surname) async =>
      await _storage.write(key: 'formCApplicantSurname', value: surname);

  Future<String?> getApplicantSurname() async {
    return await _storage.read(key: 'formCApplicantSurname');
  }

  saveApplicantStateOfReference(String stateOfReference) async => await _storage
      .write(key: 'formCApplicantStateOfReference', value: stateOfReference);

  Future<String?> getApplicantStateOfReference() async {
    return await _storage.read(key: 'formCApplicantStateOfReference');
  }

  saveApplicantCityOfReference(String cityOfReference) async => await _storage
      .write(key: 'formCApplicantCityOfReference', value: cityOfReference);

  Future<String?> getApplicantCityOfReference() async {
    return await _storage.read(key: 'formCApplicantCityOfReference');
  }

  saveApplicantDOB(String dateOfBirth) async =>
      await _storage.write(key: 'formCApplicantDOB', value: dateOfBirth);

  Future<String?> getApplicantDOB() async {
    return await _storage.read(key: 'formCApplicantDOB');
  }

  saveSplcatCode(String splcatCode) async =>
      await _storage.write(key: 'splCategory', value: splcatCode);

  Future<String?> getSplcatCode() async {
    return await _storage.read(key: 'splCategory');
  }

  // saveIsRegFinalSubmit(String isFinalsubmit) async =>
  //     await _storage.write(key: 'isRegAppFinalSubmit', value: isFinalsubmit);

  // Future<String> getIsRegFinalSubmit() async {
  //   return await _storage.read(key: 'isRegAppFinalSubmit');
  // }

  clearTokens() async => await _storage.deleteAll();
}
