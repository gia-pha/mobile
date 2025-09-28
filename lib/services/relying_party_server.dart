import 'package:flutter/foundation.dart';

import 'package:gia_pha_mobile/model/user_model.dart';
import 'package:gia_pha_mobile/services/api_service.dart';
import 'package:passkeys/types.dart';

class RelyingPartyServer {
  final ApiService apiService;

  RelyingPartyServer({ApiService? apiService})
      : apiService = apiService ?? ApiService();

  // Initialize passkey registration
  Future<RegisterRequestType> startPasskeyRegister() async {
    final response = await apiService.post(
      '/register/start',
      headers: {'Content-Type': 'application/json'},
    );
    if (kDebugMode) debugPrint(response.toString());
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load credential creation options: ${response.statusCode}',
      );
    }
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
      excludeCredentials: (response.data['excludeCredentials'] ?? [])
          .map(
            (e) => CredentialType(
              id: e['id'],
              type: e['type'],
              transports: e['transports'] != null
                  ? List<String>.from(e['transports'])
                  : <String>[],
            ),
          )
          .toList()
          .cast<CredentialType>(),
      authSelectionType: AuthenticatorSelectionType(
        requireResidentKey:
            response.data['authenticatorSelection']?['requireResidentKey'] ?? false,
        residentKey: response.data['authenticatorSelection']?['residentKey'],
        userVerification:
            response.data['authenticatorSelection']?['userVerification'],
        authenticatorAttachment:
            response.data['authenticatorSelection']?['authenticatorAttachment'],
      ),
      pubKeyCredParams: (response.data['pubKeyCredParams'] as List)
          .map((e) => PubKeyCredParamType(type: e['type'], alg: e['alg']))
          .toList(),
      timeout: response.data['timeout'],
      attestation: response.data['attestation'],
    );
  }

  // Finish passkey registration
  Future<UserModel> passKeyRegisterFinish({
    required RegisterResponseType data,
  }) async {
    try {
      final response = await apiService.post(
        '/register/complete',
        data: {
          'id': data.id,
          'rawId': data.rawId,
          'clientDataJSON': data.clientDataJSON,
          'attestationObject': data.attestationObject,
          'transports': data.transports,
        },
        headers: {'Content-Type': 'application/json'},
      );
      if (kDebugMode) debugPrint(response.toString());

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to finish passkey registration: ${response.statusCode}',
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
    final response = await apiService.post(
      '/login/start',
      headers: {'Content-Type': 'application/json'},
    );
    if (kDebugMode) debugPrint(response.toString());
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load credential login options ${response.statusCode}',
      );
    }

    return AuthenticateRequestType(
      challenge: response.data['challenge'],
      allowCredentials: (response.data['allowCredentials'] ?? [])
          .map(
            (e) => CredentialType(
              id: e['id'],
              type: e['type'],
              transports: e['transports'] != null
                  ? List<String>.from(e['transports'])
                  : <String>[],
            ),
          )
          .toList()
          .cast<CredentialType>(),
      timeout: response.data['timeout'],
      relyingPartyId: response.data['rpId'],
      userVerification: response.data['userVerification'],
      preferImmediatelyAvailableCredentials: response.data['preferImmediatelyAvailableCredentials'] ?? false,
      mediation: MediationType.Silent,
    );
  }

  // Finish passkey login
  Future<UserModel> passKeyLoginFinish({
    required AuthenticateResponseType data,
  }) async {
    if (kDebugMode) debugPrint(data.toJson().toString());
    final response = await apiService.post(
      '/login/complete',
      data: data,
      headers: {'Content-Type': 'application/json'},
    );
    if (kDebugMode) debugPrint(response.toString());

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to finish passkey login: ${response.statusCode}',
      );
    }

    return UserModel.fromJson(response.data);
  }

  // Get user details
  Future<UserModel> getUser() async {
    final response = await apiService.get(
      '/session',
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to get current user: ${response.statusCode}');
    }
    return UserModel.fromJson(response.data);
  }
}
