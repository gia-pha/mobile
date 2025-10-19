import 'package:pact_dart/pact_dart.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Get family members', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'genogram');

    // Create a new interaction
    pact
        .newInteraction(description: 'a request to get family members')
        // Set up the provider state
        .given('family members exist in the system')
        // Configure the request
        .withRequest(
          'GET',
          '/api/members',
        )
        // Configure the response
        .willRespondWith(
          200,
          headers: {'Content-Type': 'application/json'},
          body: {
            'results': PactMatchers.EachLike(
              {
                'id': PactMatchers.SomethingLike('gf1'),
                'name': PactMatchers.SomethingLike('Robert Smith'),
                'fatherId': PactMatchers.SomethingLike('gf2'),
                'motherId': PactMatchers.SomethingLike('gm2'),
                'dateOfBirth': PactMatchers.SomethingLike('1980-01-01'),
                'dateOfDeath': PactMatchers.SomethingLike('2020-01-01'),
                'gender': PactMatchers.IntegerLike(1),
                'spouses': PactMatchers.EachLike('gf2'),
                'avatarUrl': PactMatchers.SomethingLike('https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_5.png'),
                'isDeceased': PactMatchers.SomethingLike(true),
                'kinship': PactMatchers.SomethingLike('Father'),
              },
              min: 1,
            ),
          },
        );

    try {
      // Start the mock server
      pact.run();

      // Here you would write the code to make the HTTP request
      // to the mock server and validate the response
      print('Mock server running at ${pact.addr}');


      var url = Uri.http(pact.addr, '/api/members');
      var response = await http.get(url);
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
