import 'package:pact_dart/pact_dart.dart';
import 'package:test/test.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  test('Begin Registration', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'authn');

    // Create a new interaction
    pact
        .newInteraction(description: 'a request to create registration options')
        // Configure the request
        .withRequest(
          'POST',
          '/webauthn/registration/options',
          headers: {'Content-Type': 'application/json'},
        )
        // Configure the response
        .willRespondWith(
          200,
          headers: {'Content-Type': 'application/json'},
          body: {
            "challenge": "3vTO0kB4v2T6xMEsIgO7Bg", // base64url
            "rp": {"id": "example.com", "name": "My App"},
            "user": {
              "id": "QWJjMTIzNDU2", // base64url random ID
              "name": "user@example.com", // placeholder
              "displayName": "Passkey User",
            },
            "pubKeyCredParams": [
              {"type": "public-key", "alg": -7},
              {"type": "public-key", "alg": -257},
            ],
            "authenticatorSelection": {
              "residentKey": "required",
              "userVerification": "required",
            },
            "attestation": "none",
            "timeout": 60000,
          },
        );

    try {
      // Start the mock server
      pact.run();

      // Here you would write the code to make the HTTP request
      // to the mock server and validate the response
      print('Mock server running at ${pact.addr}');

      var url = Uri.http(pact.addr, '/webauthn/registration/options');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Write the pact file if all tests pass
      pact.writePactFile(directory: 'test/outputs/contracts');
    } finally {
      // Clean up the mock server
      pact.reset();
    }
  });

  test('Finish Registration', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'authn');

    // Create a new interaction
    pact
        .newInteraction(description: 'a request to finish registration')
        // Configure the request
        .withRequest(
          'POST',
          '/webauthn/registration/verify',
          headers: {'Content-Type': 'application/json'},
          body: {
            "id": "ZGV2aWNlY3JlZGlk",
            "rawId": "ZGV2aWNlY3JlZGlk",
            "type": "public-key",
            "response": {
              "clientDataJSON": "eyJjaGFsbGVuZ2UiOiAiLi4uIn0",
              "attestationObject": "o2NmbXR...",
            },
          },
        )
        // Configure the response
        .willRespondWith(
          200,
          headers: {'Content-Type': 'application/json'},
          body: {"status": "ok", "userId": "QWJjMTIzNDU2"},
        );

    try {
      // Start the mock server
      pact.run();

      // Here you would write the code to make the HTTP request
      // to the mock server and validate the response
      print('Mock server running at ${pact.addr}');

      var url = Uri.http(pact.addr, '/webauthn/registration/verify');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": "ZGV2aWNlY3JlZGlk",
          "rawId": "ZGV2aWNlY3JlZGlk",
          "type": "public-key",
          "response": {
            "clientDataJSON": "eyJjaGFsbGVuZ2UiOiAiLi4uIn0",
            "attestationObject": "o2NmbXR...",
          },
        }),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Write the pact file if all tests pass
      pact.writePactFile(directory: 'test/outputs/contracts');
    } finally {
      // Clean up the mock server
      pact.reset();
    }
  });
}
