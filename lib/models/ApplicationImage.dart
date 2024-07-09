class ApplicantImage {
  String? photo;
  double? size;
  String? imageExtension;

  ApplicantImage({this.photo, this.size, this.imageExtension});

  ApplicantImage.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    size = json['size'];
    imageExtension = json['imageExtension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.photo;
    data['size'] = this.size;
    data['imageExtension'] = this.imageExtension;
    return data;
  }
}
