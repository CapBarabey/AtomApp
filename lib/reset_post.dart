class ResetResponse {
  late final String status;
  late final String message;

  ResetResponse({
    required this.status,
    required this.message,
  });

  factory ResetResponse.fromJson(Map<String, dynamic> json)
  => ResetResponse(
    status: json['status'],
    message: json['message'],
  );

}