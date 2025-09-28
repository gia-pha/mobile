import 'package:pact_dart/pact_dart.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Logout', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'authn');

    // Create a new interaction
    pact
        .newInteraction(
          description: 'a request to logout',
        )
        // Configure the request
        .withRequest(
          'POST',
          '/logout',
        )
        // Configure the response
        .willRespondWith(
          204,
          headers: {
            'Set-Cookie': 'session=; Expires=Thu, 01 Jan 1970 00:00:00 GMT; Path=/;'
          }
        );

    try {
      // Start the mock server
      pact.run();

      // Here you would write the code to make the HTTP request
      // to the mock server and validate the response
      print('Mock server running at ${pact.addr}');

      var url = Uri.http(pact.addr, '/logout');
      var response = await http.post(
        url,
      );
      assert(response.statusCode == 204);

      // Write the pact file if all tests pass
      pact.writePactFile(directory: 'test/outputs/contracts');
    } finally {
      // Clean up the mock server
      pact.reset();
    }
  });
}
