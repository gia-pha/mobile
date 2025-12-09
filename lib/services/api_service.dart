import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
// 1. Import BrowserClient for web
import 'package:http/browser_client.dart';

import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

import 'package:gia_pha_mobile/model/api_response.dart';

class ApiService {
  static ApiService? _instance;
  // Use the correct backend URL you provided
  static const String _defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:42985',
  );

  final String baseUrl;
  // Use a general http.Client that will be configured for web/mobile
  late final http.Client _httpClient;
  late final Dio _dio;
  late final CookieJar _cookieJar;

  factory ApiService({String? baseUrl}) {
    _instance ??= ApiService._internal(baseUrl ?? _defaultBaseUrl);
    return _instance!;
  }

  ApiService._internal(this.baseUrl) {
    if (kIsWeb) {
      // 2. For web, use BrowserClient and enable credentials
      _httpClient = BrowserClient()..withCredentials = true;
    } else {
      // For mobile, use Dio with CookieManager as before
      _dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => true,
      ));
      _cookieJar = CookieJar();
      _dio.interceptors.add(CookieManager(_cookieJar));
    }
  }

  Future<ApiResponse> get(String path, {Map<String, String>? headers}) async {
    if (kIsWeb) {
      final uri = Uri.parse('$baseUrl$path');
      // 3. Use the configured httpClient
      final response = await _httpClient.get(uri, headers: headers);
      return _convertHttpResponse(response);
    } else {
      final response = await _dio.get(path, options: Options(headers: headers));
      return _convertDioResponse(response);
    }
  }

  Future<ApiResponse> post(String path, {Map<String, String>? headers, dynamic data}) async {
    if (kIsWeb) {
      final uri = Uri.parse('$baseUrl$path');
      // 3. Use the configured httpClient
      final response = await _httpClient.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (headers != null) ...headers,
        },
        body: jsonEncode(data),
      );
      return _convertHttpResponse(response);
    } else {
      final response = await _dio.post(path, data: data, options: Options(headers: headers));
      return _convertDioResponse(response);
    }
  }

  ApiResponse _convertHttpResponse(http.Response response) {
    // Be robust against empty responses
    final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    return ApiResponse(
      statusCode: response.statusCode,
      headers: response.headers.map((k, v) => MapEntry(k, v.split(','))),
      data: data,
    );
  }

  ApiResponse _convertDioResponse(Response response) {
    return ApiResponse(
      statusCode: response.statusCode ?? 0,
      headers: response.headers.map,
      data: response.data,
    );
  }
}

