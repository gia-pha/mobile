class ApiResponse {
  final int statusCode;
  final Map<String, List<String>> headers;
  final dynamic data;

  ApiResponse({
    required this.statusCode,
    required this.headers,
    required this.data,
  });
}
