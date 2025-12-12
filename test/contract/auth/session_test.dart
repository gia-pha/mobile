import 'package:gia_pha_mobile/services/api_service.dart';
import 'package:pact_dart/pact_dart.dart';
import 'package:test/test.dart';

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
            "name": PactMatchers.SomethingLike('0123456789'),
            'displayName': PactMatchers.SomethingLike('John Doe'),
            'families': PactMatchers.EachLike(['family1']),
            'currentFamilyId': PactMatchers.SomethingLike('family1'),
          },
        );

    try {
      // Start the mock server
      pact.run();

      // Here you would write the code to make the HTTP request
      // to the mock server and validate the response
      print('Mock server running at ${pact.addr}');

      final apiService = ApiService(baseUrl: 'http://${pact.addr}');
      var response = await apiService.get(
        '/session',
        headers: {'Cookie': 'session=a1B2c3D4e5F6g7H8i9J0K'},
      );
      assert(response.statusCode == 200);
      expect(response.data, isA<Map>());
      expect(response.data, containsPair('id', '123'));
      expect(response.data, containsPair('name', '0123456789'));
      expect(response.data, containsPair('displayName', 'John Doe'));

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
          headers: {'Cookie': PactMatchers.Null()},
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

      final apiService = ApiService(baseUrl: 'http://${pact.addr}');
      var response = await apiService.get(
        '/session',
        headers: {},
      );
      //assert(response.statusCode == 401);
      expect(response.data, isEmpty);

      // Write the pact file if all tests pass
      pact.writePactFile(directory: 'test/outputs/contracts');
    } finally {
      // Clean up the mock server
      pact.reset();
    }
  });
}
