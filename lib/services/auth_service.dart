import 'dart:developer';

import 'package:credential_manager/credential_manager.dart';
import 'package:dio/dio.dart';
import 'package:gia_pha_mobile/model/user_model.dart';
import 'package:gia_pha_mobile/services/http_client.dart';


class AuthService {
  static final Dio dio = HttpClient().dio;

  // Initialize passkey registration
  static Future<CredentialCreationOptions> passKeyRegisterInit() async {
    final response = await dio.post(
      '/register/start',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      return CredentialCreationOptions.fromJson(
        response.data,
      );
    } else {
      throw Exception(
        'Failed to load credential creation options: ${response.statusMessage}',
      );
    }
  }

  // Finish passkey registration
  static Future<UserModel> passKeyRegisterFinish(
      {
      required String challenge,
      required PublicKeyCredential request}) async {
    Map<String, dynamic> body = {
      'challenge': challenge,
    };

    body.addAll(request.toJson());
    log(body.toString());
    try {
      final response = await dio.post(
        '/register/complete',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to finish passkey registration: ${response.statusMessage}',
        );
      }

      return UserModel.fromJson(response.data);
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to finish passkey registration $e');
    }
  }

  // Initialize passkey login
  static Future<CredentialLoginOptions> passKeyLoginInit() async {
    final response = await dio.get(
      '/login/start',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load credential login options ${response.statusMessage}');
    }

    return CredentialLoginOptions.fromJson(response.data);
  }

  // Finish passkey login
  static Future<UserModel> passKeyLoginFinish(
      {required String challenge, required PublicKeyCredential request}) async {
    final Map<String, dynamic> body = {
      'challenge': challenge,
    };
    body.addAll(request.toJson());

    final response = await dio.post(
      '/login/complete',
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to finish passkey login: ${response.statusMessage}',
      );
    }

    return UserModel.fromJson(response.data);
  }

  // Get user details
  static Future<UserModel> getUser() async {
    final response = await dio.get(
      '/session',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to get current user: ${response.statusMessage}',
      );
    }
    return UserModel.fromJson(response.data);
  }

  // Instance of CredentialManager
  static CredentialManager credentialManager = CredentialManager();
}
