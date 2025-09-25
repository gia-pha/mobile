import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:gia_pha_mobile/model/user_model.dart';
import 'package:gia_pha_mobile/services/http_client.dart';
import 'package:passkeys/types.dart';

class RelyingPartyServer {
  final Dio dio = HttpClient().dio;

  // Initialize passkey registration
  Future<RegisterRequestType> startPasskeyRegister() async {
    final response = await dio.post(
      '/register/start',
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (kDebugMode) debugPrint(response.toString());
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load credential creation options: ${response.statusMessage}',
      );
    }
    if (kDebugMode) debugPrint('code: ${response.statusCode.toString()}');
    return RegisterRequestType(
      challenge: response.data['challenge'],
      relyingParty: RelyingPartyType(
        name: response.data['rp']['name'],
        id: response.data['rp']['id'],
      ),
      user: UserType(
        id: response.data['user']['id'],
        name: response.data['user']['name'],
        displayName: response.data['user']['displayName'],
      ),
      excludeCredentials: (response.data['excludeCredentials'] as List)
          .map(
            (e) => CredentialType(
              id: e['id'],
              type: e['type'],
              transports: e['transports'] != null
                  ? List<String>.from(e['transports'])
                  : <String>[],
            ),
          )
          .toList(),
      authSelectionType: AuthenticatorSelectionType(
        requireResidentKey:
            response.data['authSelectionType']['requireResidentKey'],
        residentKey: response.data['authSelectionType']['residentKey'],
        userVerification:
            response.data['authSelectionType']['userVerification'],
        authenticatorAttachment:
            response.data['authSelectionType']['authenticatorAttachment'],
      ),
      pubKeyCredParams: (response.data['pubKeyCredParams'] as List)
          .map((e) => PubKeyCredParamType(type: e['type'], alg: e['alg']))
          .toList(),
      timeout: 60000,
    );
  }

  // Finish passkey registration
  Future<UserModel> passKeyRegisterFinish({
    required RegisterResponseType data,
  }) async {
    try {
      final response = await dio.post(
        '/register/complete',
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to finish passkey registration: ${response.statusMessage}',
        );
      }

      return UserModel.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
      throw Exception('Failed to finish passkey registration $e');
    }
  }

  // Initialize passkey login
  Future<AuthenticateRequestType> passKeyLoginInit() async {
    final response = await dio.get(
      '/login/start',
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load credential login options ${response.statusMessage}',
      );
    }

    return AuthenticateRequestType(
      challenge: response.data['challenge'],
      allowCredentials: (response.data['allowCredentials'] as List)
          .map(
            (e) => CredentialType(
              id: e['id'],
              type: e['type'],
              transports: e['transports'] != null
                  ? List<String>.from(e['transports'])
                  : <String>[],
            ),
          )
          .toList(),
      timeout: 60000,
      relyingPartyId: response.data['rpId'],
      userVerification: response.data['userVerification'],
      preferImmediatelyAvailableCredentials: response.data['preferImmediatelyAvailableCredentials'],
      mediation: response.data['mediation'],
    );
  }

  // Finish passkey login
  Future<UserModel> passKeyLoginFinish({
    required AuthenticateResponseType data,
  }) async {
    final response = await dio.post(
      '/login/complete',
      data: data,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to finish passkey login: ${response.statusMessage}',
      );
    }

    return UserModel.fromJson(response.data);
  }

  // Get user details
  Future<UserModel> getUser() async {
    final response = await dio.get(
      '/session',
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to get current user: ${response.statusMessage}');
    }
    return UserModel.fromJson(response.data);
  }
}
