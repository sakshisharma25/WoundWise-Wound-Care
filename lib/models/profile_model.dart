class ProfileModel {
  final String? profileImageUrl;
  final String? name;
  final String? departments;
  final String? about;
  final String? location;
  final int? patientCounts;
  final String? latitude;
  final String? longitude;

  ProfileModel({
    this.profileImageUrl,
    this.name,
    this.departments,
    this.about,
    this.location,
    this.patientCounts,
    this.latitude,
    this.longitude,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profileImageUrl: json['profile_photo_path'],
      name: json['name'],
      departments: json['departments'],
      about: json['about'],
      location: json['location'],
      patientCounts: json['patient_count'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
