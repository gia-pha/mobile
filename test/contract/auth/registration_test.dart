import 'package:gia_pha_mobile/services/api_service.dart';
import 'package:pact_dart/pact_dart.dart';
import 'package:test/test.dart';

void main() {
  test('Begin Register', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'authn');

    // Create a new interaction
    pact
        .newInteraction(description: 'a request to create register options')
        // Configure the request
        .withRequest(
          'POST',
          '/register/start',
          headers: {'Content-Type': 'application/json'},
        )
        // Configure the response
        .willRespondWith(
          200,
          headers: {'Content-Type': 'application/json'},
          body: {
            "challenge": "3vTO0kB4v2T6xMEsIgO7Bg", // base64url
            "rp": {"id": PactMatchers.SomethingLike("localhost"), "name": "My App"},
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

      final apiService = ApiService(baseUrl: 'http://${pact.addr}');
      var response = await apiService.post(
        '/register/start',
        headers: {'Content-Type': 'application/json'},
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');

      // Write the pact file if all tests pass
      pact.writePactFile(directory: 'test/outputs/contracts');
    } finally {
      // Clean up the mock server
      pact.reset();
    }
  });

  test('Finish Register', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'authn');

    // Create a new interaction
    pact
        .newInteraction(description: 'a request to finish register')
        // Configure the request
        .withRequest(
          'POST',
          '/register/complete',
          headers: {'Content-Type': 'application/json'},
          body: {
            "id": PactMatchers.SomethingLike("q5SEdsLcjKybsi8PCoNdHg"),
            "rawId": PactMatchers.SomethingLike("q5SEdsLcjKybsi8PCoNdHg"),
            "attestationObject": PactMatchers.SomethingLike("eyJ0eXBlIjoid2ViYXV0aG4uY3JlYXRlIiwiY2hhbGxlbmdlIjoiM3ZUTzBrQjR2MlQ2eE1Fc0lnTzdCZyIsIm9yaWdpbiI6ImFuZHJvaWQ6YXBrLWtleS1oYXNoOnE4NnRuejJTM3VvaW5ycVpLYVRhMXp3ZXQ2Z3Vsd0lXQ3Y3a0dmUFJRbU0iLCJjcm9zc09yaWdpbiI6ZmFsc2V9"),
            "clientDataJSON": PactMatchers.SomethingLike("o2NmbXRkbm9uZWdhdHRTdG10oGhhdXRoRGF0YViUo3mm9u6vuaVeN4wRgDTidR5oL6ufLTCrE9ISVYbOGUdNAAAAAOrs3vIcMVY0hjnxy9nACggAEKuUhHbC3Iysm7IvDwqDXR6lAQIDJiABIVggmMR59_yMHPhTGqY1JYC-nSPjj0w2zjEfEnar9cIM4QwiWCBCj_IwW_uYnuJ6FfnWkWlIh8KcEV__eq4BYjcg9LejVA"),
            "transports": [
              "internal",
              "hybrid"
            ]
          },
        )
        // Configure the response
        .willRespondWith(
          200,
          headers: {
            'Content-Type': 'application/json',
            'Set-Cookie': 'session=abcdef12345; Path=/; HttpOnly; Secure; SameSite=Strict'
          },
          body: {
            "id": "QWJjMTIzNDU2", // base64url random ID
            "name": "user@example.com", // placeholder
            "displayName": "Passkey User",
          },
        );

    try {
      // Start the mock server
      pact.run();

      // Here you would write the code to make the HTTP request
      // to the mock server and validate the response
      print('Mock server running at ${pact.addr}');

      final apiService = ApiService(baseUrl: 'http://${pact.addr}');
      var response = await apiService.post(
        '/register/complete',
        headers: {'Content-Type': 'application/json'},
        data: {
          "id": "q5SEdsLcjKybsi8PCoNdHg",
          "rawId": "q5SEdsLcjKybsi8PCoNdHg",
          "attestationObject": "eyJ0eXBlIjoid2ViYXV0aG4uY3JlYXRlIiwiY2hhbGxlbmdlIjoiM3ZUTzBrQjR2MlQ2eE1Fc0lnTzdCZyIsIm9yaWdpbiI6ImFuZHJvaWQ6YXBrLWtleS1oYXNoOnE4NnRuejJTM3VvaW5ycVpLYVRhMXp3ZXQ2Z3Vsd0lXQ3Y3a0dmUFJRbU0iLCJjcm9zc09yaWdpbiI6ZmFsc2V9",
          "clientDataJSON": "o2NmbXRkbm9uZWdhdHRTdG10oGhhdXRoRGF0YViUo3mm9u6vuaVeN4wRgDTidR5oL6ufLTCrE9ISVYbOGUdNAAAAAOrs3vIcMVY0hjnxy9nACggAEKuUhHbC3Iysm7IvDwqDXR6lAQIDJiABIVggmMR59_yMHPhTGqY1JYC-nSPjj0w2zjEfEnar9cIM4QwiWCBCj_IwW_uYnuJ6FfnWkWlIh8KcEV__eq4BYjcg9LejVA",
          "transports": [
            "internal",
            "hybrid"
          ]
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');

      // Write the pact file if all tests pass
      pact.writePactFile(directory: 'test/outputs/contracts');
    } finally {
      // Clean up the mock server
      pact.reset();
    }
  });
}
