import 'http_client_stub.dart'
  if (dart.library.js) 'http_client_web.dart';

import 'package:dio/dio.dart';

import 'package:gia_pha_mobile/model/api_response.dart';

class ApiService {
  static ApiService? _instance;
  static const String _defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:46025',
  );

  final String baseUrl;
  late final Dio dio;

  factory ApiService({String? baseUrl}) {
    _instance ??= ApiService._internal(baseUrl ?? _defaultBaseUrl);
    return _instance!;
  }

  ApiService._internal(this.baseUrl) {
    dio = createDioClient(baseUrl);
  }

  Future<ApiResponse> get(String path, {Map<String, String>? headers}) async {
    final response = await dio.get(path, options: Options(headers: headers));
    return _convertDioResponse(response);
  }

  Future<ApiResponse> post(String path, {Map<String, String>? headers, dynamic data}) async {
    final response = await dio.post(path, data: data, options: Options(headers: headers));
    return _convertDioResponse(response);
  }

  ApiResponse _convertDioResponse(Response response) {
    return ApiResponse(
      statusCode: response.statusCode ?? 0,
      headers: response.headers.map,
      data: response.data,
    );
  }
}
