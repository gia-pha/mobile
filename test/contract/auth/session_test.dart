import 'package:pact_dart/pact_dart.dart';
import 'package:test/test.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  test('Has Session', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'authn');

    // Create a new interaction
    pact
        .newInteraction(
          description: 'a request to check authentication status',
        )
        // Configure the request
        .withRequest(
          'GET',
          '/session',
          headers: {'Cookie': PactMatchers.Term(r'session=[a-zA-Z0-9\-_.]+', 'session=abc12345')},
        )
        // Configure the response
        .willRespondWith(
          200,
          headers: {'Content-Type': 'application/json'},
          body: {
            "id": PactMatchers.SomethingLike('123'),
            "name": PactMatchers.SomethingLike('John Doe'),
            'createdAt': PactMatchers.SomethingLike('2023-10-01T12:34:56Z'),
            'updatedAt': PactMatchers.SomethingLike('2023-10-01T12:34:56Z'),
          },
        );

    try {
      // Start the mock server
      pact.run();

      // Here you would write the code to make the HTTP request
      // to the mock server and validate the response
      print('Mock server running at ${pact.addr}');

      var url = Uri.http(pact.addr, '/session');
      var response = await http.get(
        url,
        headers: {'Cookie': 'session=a1B2c3D4e5F6g7H8i9J0K'},
      );
      assert(response.statusCode == 200);
      final parsed = jsonDecode(response.body);
      expect(parsed, isA<Map>());
      expect(parsed, containsPair('id', '123'));
      expect(parsed, containsPair('name', 'John Doe'));
      expect(parsed, contains('createdAt'));
      expect(parsed, contains('updatedAt'));

      // Write the pact file if all tests pass
      pact.writePactFile(directory: 'test/outputs/contracts');
    } finally {
      // Clean up the mock server
      pact.reset();
    }
  });

  test('No Session', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'authn');

    // Create a new interaction
    pact
        .newInteraction(description: 'a request to check authentication status with no session')
        // Configure the request
        .withRequest(
          'GET',
          '/session',
        )
        // Configure the response
        .willRespondWith(
          401,
        );

    try {
      // Start the mock server
      pact.run();

      // Here you would write the code to make the HTTP request
      // to the mock server and validate the response
      print('Mock server running at ${pact.addr}');

      var url = Uri.http(pact.addr, '/session');
      var response = await http.get(
        url,
      );
      assert(response.statusCode == 401);

      // Write the pact file if all tests pass
      pact.writePactFile(directory: 'test/outputs/contracts');
    } finally {
      // Clean up the mock server
      pact.reset();
    }
  });
}
