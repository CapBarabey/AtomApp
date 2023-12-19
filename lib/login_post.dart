class LoginResponse {
  late final Map<String, dynamic>? data;
  late final String status;
  late final String message;

  LoginResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json)
  => LoginResponse(
    status: json['status'],
    message: json['message'],
    data: json['data'],
  );



}
