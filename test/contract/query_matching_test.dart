import 'package:pact_dart/pact_dart.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Counter value should be incremented', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'member');

    // Create a new interaction
    pact
        .newInteraction(description: 'a request to search with query matchers')
        // Set up the provider state
        .given('search service is running')
        // Configure the request
        .withRequest(
          'GET',
          '/api/members',
          query: {
            'status': PactMatchers.QueryRegex('divorced', 'divorced|separated|engaged'),
            'adoptionStatus': PactMatchers.QueryRegex('adopted', 'adopted|foster'),
          },
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
                'dateOfBirth': PactMatchers.SomethingLike('1980-01-01T00:00:00Z'),
                'dateOfDeath': PactMatchers.SomethingLike('2020-01-01T00:00:00Z'),
                'gender': PactMatchers.IntegerLike(1),
                'spouses': PactMatchers.EachLike('gf2'),
                'extraData': {
                  'medicalInfo': PactMatchers.SomethingLike('No allergies'),
                  'hobbies': PactMatchers.EachLike('reading'),
                },
                'color': PactMatchers.IntegerLike(4289374895), // Example ARGB color
                'isDeceased': PactMatchers.SomethingLike(true),
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


      var url = Uri.http(pact.addr, '/api/members', {
        'status': 'divorced',
        'adoptionStatus': 'adopted',
      });
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Write the pact file if all tests pass
      pact.writePactFile(directory: 'test/contract/contracts');
    } finally {
      // Clean up the mock server
      pact.reset();
    }
  });
}
