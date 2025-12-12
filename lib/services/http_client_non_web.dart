import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'http_client_options.dart';

Dio createDioClient(String baseUrl) {
  final cookieJar = CookieJar(); // Use PersistCookieJar() if needed
  final dio = Dio(buildBaseOptions(baseUrl));
  dio.interceptors.add(CookieManager(cookieJar));
  return dio;
}
