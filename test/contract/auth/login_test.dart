import 'package:gia_pha_mobile/services/api_service.dart';
import 'package:pact_dart/pact_dart.dart';
import 'package:test/test.dart';

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
            "rpId": PactMatchers.SomethingLike("localhost"),
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

      final apiService = ApiService(baseUrl: 'http://${pact.addr}');
      var response = await apiService.post(
        '/login/start',
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
            "id": "LuWl0E7-XeIUPAIYsREHgQ",
            "rawId": "LuWl0E7-XeIUPAIYsREHgQ",
            "clientDataJSON": "eyJ0eXBlIjoid2ViYXV0aG4uZ2V0IiwiY2hhbGxlbmdlIjoiVDF4Q3NueE0yRE5MMktkSzVDTGE2Zk1oRDdPQnFobzZzeXpJbmtfbi1VbyIsIm9yaWdpbiI6ImFuZHJvaWQ6YXBrLWtleS1oYXNoOnE4NnRuejJTM3VvaW5ycVpLYVRhMXp3ZXQ2Z3Vsd0lXQ3Y3a0dmUFJRbU0iLCJjcm9zc09yaWdpbiI6ZmFsc2V9",
            "authenticatorData": PactMatchers.SomethingLike("o3mm9u6vuaVeN4wRgDTidR5oL6ufLTCrE9ISVYbOGUcNAAAAAA"),
            "signature": PactMatchers.SomethingLike("MEQCIEaLypVlw9uHcwqISxlnfDsG11mkRvXTKHoA-EgrKir1AiB0NqkAaYnsomnltCMWlaoLFe6Rs_yElleNbCxhi6wv-Q"),
            "userHandle": "QWJjMTIzNDU2", // maps back to user
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
        '/login/complete',
        headers: {'Content-Type': 'application/json'},
        data: {
          "id": "LuWl0E7-XeIUPAIYsREHgQ",
          "rawId": "LuWl0E7-XeIUPAIYsREHgQ",
          "clientDataJSON": "eyJ0eXBlIjoid2ViYXV0aG4uZ2V0IiwiY2hhbGxlbmdlIjoiVDF4Q3NueE0yRE5MMktkSzVDTGE2Zk1oRDdPQnFobzZzeXpJbmtfbi1VbyIsIm9yaWdpbiI6ImFuZHJvaWQ6YXBrLWtleS1oYXNoOnE4NnRuejJTM3VvaW5ycVpLYVRhMXp3ZXQ2Z3Vsd0lXQ3Y3a0dmUFJRbU0iLCJjcm9zc09yaWdpbiI6ZmFsc2V9",
          "authenticatorData": "o3mm9u6vuaVeN4wRgDTidR5oL6ufLTCrE9ISVYbOGUcNAAAAAA",
          "signature": "MEQCIEaLypVlw9uHcwqISxlnfDsG11mkRvXTKHoA-EgrKir1AiB0NqkAaYnsomnltCMWlaoLFe6Rs_yElleNbCxhi6wv-Q",
          "userHandle": "QWJjMTIzNDU2", // maps back to user
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
