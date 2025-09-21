import 'package:pact_dart/pact_dart.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Digital Asset Links', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'authn');

    // Create a new interaction
    pact
        .newInteraction(
          description: 'a request to get digital asset links',
        )
        // Configure the request
        .withRequest(
          'GET',
          '/assetlinks.json',
          headers: {'Content-Type': 'application/json'},
        )
        // Configure the response
        .willRespondWith(
          200,
          headers: {'Content-Type': 'application/json'},
          body: PactMatchers.EachLike(
            {
              "relation": [
                "delegate_permission/common.handle_all_urls",
                "delegate_permission/common.get_login_creds"
              ],
              "target": {
                "namespace": "android_app",
                "package_name": "com.example.android",
                "sha256_cert_fingerprints": PactMatchers.QueryMultiRegex(
                  ["c4bbcb1fbec99d65bf59d85c8cb62ee2db963f0fe106f483d9afa73bd4e39a8a"],
                  r'[A-Fa-f0-9]{64}',
                )
              }
            }
          ),
        );

    try {
      // Start the mock server
      pact.run();

      // Here you would write the code to make the HTTP request
      // to the mock server and validate the response
      print('Mock server running at ${pact.addr}');

      var url = Uri.http(pact.addr, '/assetlinks.json');
      var response = await http.get(
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

  test('Robots', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'authn');

    // Create a new interaction
    pact
        .newInteraction(description: 'a request to get robots')
        // Configure the request
        .withRequest(
          'GET',
          '/robots.txt',
        )
        // Configure the response
        .willRespondWith(
          200,
          body: '''
User-agent: *
Allow: /.well-known/
''',
        );

    try {
      // Start the mock server
      pact.run();

      // Here you would write the code to make the HTTP request
      // to the mock server and validate the response
      print('Mock server running at ${pact.addr}');

      var url = Uri.http(pact.addr, '/robots.txt');
      var response = await http.get(
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
}
