class AddUserModel {
  final String name;
  final String email;
  final String cCode;
  final String phone;

  AddUserModel({
    required this.name,
    required this.email,
    required this.cCode,
    required this.phone,                                                                                            
  });                                                                                                               

  factory AddUserModel.fromJson(Map<String, dynamic> json) {
    return AddUserModel(
      name: json['name'],
      email: json['email'],
      cCode: json['c_code'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'c_code': cCode,
      'phone': phone,
    };
  }                            
}