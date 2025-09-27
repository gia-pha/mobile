import 'package:pact_dart/pact_dart.dart';
import 'package:test/test.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  test('Begin Login', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'authn');

    // Create a new interaction
    pact
        .newInteraction(
          description: 'a request to create login options',
        )
        // Configure the request
        .withRequest(
          'POST',
          '/login/start',
          headers: {'Content-Type': 'application/json'},
        )
        // Configure the response
        .willRespondWith(
          200,
          headers: {'Content-Type': 'application/json'},
          body: {
            "challenge": "T1xCsnxM2DNL2KdK5CLa6fMhD7OBqho6syzInk_n-Uo", // base64url
            "rpId": "example.com",
            "timeout": 60000,
            "userVerification": "required",
            // note: NO allowCredentials -> usernameless (discoverable)
          },
        );

    try {
      // Start the mock server
      pact.run();

      // Here you would write the code to make the HTTP request
      // to the mock server and validate the response
      print('Mock server running at ${pact.addr}');

      var url = Uri.http(pact.addr, '/login/start');
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

  test('Finish Login', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'authn');

    // Create a new interaction
    pact
        .newInteraction(description: 'a request to finish login')
        // Configure the request
        .withRequest(
          'POST',
          '/login/complete',
          headers: {'Content-Type': 'application/json'},
          body: {
            "id": "ZGV2aWNlY3JlZGlk",
            "rawId": "ZGV2aWNlY3JlZGlk",
            "type": "public-key",
            "response": {
              "clientDataJSON": "eyJjaGFsbGVuZ2UiOiAiLi4uIn0",
              "authenticatorData": "YXV0aGRhdGE",
              "signature": "c2lnbmF0dXJl",
              "userHandle": "QWJjMTIzNDU2", // maps back to user
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

      var url = Uri.http(pact.addr, '/login/complete');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": "ZGV2aWNlY3JlZGlk",
          "rawId": "ZGV2aWNlY3JlZGlk",
          "type": "public-key",
          "response": {
            "clientDataJSON": "eyJjaGFsbGVuZ2UiOiAiLi4uIn0",
            "authenticatorData": "YXV0aGRhdGE",
            "signature": "c2lnbmF0dXJl",
            "userHandle": "QWJjMTIzNDU2", // maps back to user
          },
        },
      ));
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
