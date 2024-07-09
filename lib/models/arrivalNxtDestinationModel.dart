class ArrivalNxtDestModel {
  String? applicationId;
  String? arrivedFromPlace;
  String? arrivedFromCity;
  String? arrivedFromCountry;
  String? dateOfArrivalInIndia;
  String? dateOfArrivalInHotel;
  String? timeOfArrivalInHotel;
  String? durationOfStay;
  String? nextDestPlaceInIndia;
  String? nextDestDistInIndia;
  String? nextDeststateInIndia;
  String? nextDestCountryFlag;
  String? nextDestPlaceOutIndia;
  String? nextDestCityOutIndia;
  String? nextDestCountryOutIndia;
  ArrivalNxtDestModel({
    this.applicationId,
    this.arrivedFromCity,
    this.arrivedFromCountry,
    this.dateOfArrivalInHotel,
    this.dateOfArrivalInIndia,
    this.arrivedFromPlace,
    this.timeOfArrivalInHotel,
    this.durationOfStay,
    this.nextDestCityOutIndia,
    this.nextDestCountryFlag,
    this.nextDestCountryOutIndia,
    this.nextDestDistInIndia,
    this.nextDestPlaceInIndia,
    this.nextDestPlaceOutIndia,
    this.nextDeststateInIndia,
  });
  ArrivalNxtDestModel.fromJson(Map<String?, dynamic> json)
      : this.applicationId = json['form_c_appl_id'],
        this.arrivedFromPlace = json['arriplace'],
        this.arrivedFromCity = json['arricity'],
        this.arrivedFromCountry = json['arricoun'],
        this.dateOfArrivalInIndia = json['arridateind'],
        this.dateOfArrivalInHotel = json['arridatehotel'],
        this.timeOfArrivalInHotel = json['arritimehotel'],
        this.durationOfStay = json['durationofstay'],
        this.nextDestPlaceInIndia = json['nextdestplaceinind'],
        this.nextDestDistInIndia = json['nextdestdistinind'],
        this.nextDeststateInIndia = json['nextdeststateinind'],
        this.nextDestCountryFlag = json['nextdestcounflag'],
        this.nextDestPlaceOutIndia = json['nextdestplaceoutind'],
        this.nextDestCityOutIndia = json['nextdestcityoutind'],
        this.nextDestCountryOutIndia = json['nextdestcounoutind'];
  Map<String?, dynamic> toJson() => {
        'form_c_appl_id': applicationId,
        'arriplace': arrivedFromPlace,
        'arricity': arrivedFromCity,
        'arricoun': arrivedFromCountry,
        'arridateind': dateOfArrivalInIndia,
        'arridatehotel': dateOfArrivalInHotel,
        'arritimehotel': timeOfArrivalInHotel,
        'durationofstay': durationOfStay,
        'nextdestplaceinind': nextDestPlaceInIndia,
        'nextdestdistinind': nextDestDistInIndia,
        'nextdeststateinind': nextDeststateInIndia,
        'nextdestcounflag': nextDestCountryFlag,
        'nextdestplaceoutind': nextDestPlaceOutIndia,
        'nextdestcityoutind': nextDestCityOutIndia,
        'nextdestcounoutind': nextDestCountryOutIndia,
      };
}
