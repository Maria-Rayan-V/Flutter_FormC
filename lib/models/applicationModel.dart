class ApplicationModel {
  String? image;
  String? applicationId;
  String? givenName;
  String? surName;
  String? gender;
  String? countryOfPermanentResidence;
  String? stateOfReference;
  String? cityOfReference;
  ApplicationModel(
      {this.image,
      this.applicationId,
      this.givenName,
      this.surName,
      this.gender,
      this.countryOfPermanentResidence,
      this.stateOfReference,
      this.cityOfReference});
  ApplicationModel.fromJson(Map<String?, dynamic> json)
      : this.image = json['img'],
        this.applicationId = json['form_c_appl_id'],
        this.givenName = json['given_name'],
        this.surName = json['surname'],
        this.gender = json['gender'],
        this.countryOfPermanentResidence = json['counoutind'],
        this.stateOfReference = json['stateofrefinind'],
        this.cityOfReference = json['cityofrefinind'];

  Map<String?, dynamic> toJson() => {
        'img': image,
        'form_c_appl_id': applicationId,
        'given_name': givenName,
        'surname': surName,
        'gender': gender,
        'counoutind': countryOfPermanentResidence,
        'stateofrefinind': stateOfReference,
        'cityofrefinind': cityOfReference,
      };
}
