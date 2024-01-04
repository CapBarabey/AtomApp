class ApiResponse {
  late final String status;
  late final String message;
  late final Map<String, dynamic>? data;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    status: json['status'],
    message: json['message'],
    data: json['data'],
  );

}


//  dkovalyov@uis.kz
//  230400D2456436d$

