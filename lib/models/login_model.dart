class LoginModel {
  final String? token;
  final String? name;
  final String? email;
  final String? pin;
  final String? otp;

  LoginModel({
    required this.token,
    required this.name,
    required this.email,
    required this.pin,
    required this.otp,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      token: json['token'],
      name: json['name'],
      email: json['email'],
      pin: json['pin'],
      otp: json['otp'],
    );
  }
}
