import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:46025',
  );

  late Dio dio;
  late CookieJar cookieJar;

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _initCookieManager();
  }

  Future<void> _initCookieManager() async {
    cookieJar = CookieJar();

    dio.interceptors.add(CookieManager(cookieJar));
  }
}
