import 'package:dio/dio.dart';
import 'package:dio/browser.dart';
import 'http_client_options.dart';

Dio createDioClient(String baseUrl) {
  final dio = Dio(buildBaseOptions(baseUrl))
    ..httpClientAdapter = BrowserHttpClientAdapter(withCredentials: true);
  return dio;
}
