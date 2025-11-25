import 'dart:convert';

import 'package:pact_dart/pact_dart.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Get funds', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'fund');

    // Create a new interaction
    pact
        .newInteraction(description: 'a request to get funds')
        // Set up the provider state
        .given('funds exist in the system')
        // Configure the request
        .withRequest(
          'GET',
          '/api/funds',
        )
        // Configure the response
        .willRespondWith(
          200,
          headers: {'Content-Type': 'application/json'},
          body: PactMatchers.EachLike(
            {
              'name': PactMatchers.SomethingLike('Family Trip 2026'),
              'transactions': PactMatchers.EachLike({
                'type': PactMatchers.Term(r'income|outcome', 'income'),
                'whoOrReason': PactMatchers.SomethingLike('Alice'),
                'amount': PactMatchers.SomethingLike(500),
                'date': PactMatchers.SomethingLike('2023-01-01T00:00:00Z'),
              }),
            },
            min: 1,
          ),
        );

    try {
      // Start the mock server
      pact.run();

      // Here you would write the code to make the HTTP request
      // to the mock server and validate the response
      print('Mock server running at ${pact.addr}');


      var url = Uri.http(pact.addr, '/api/funds');
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

  test('Get fund', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'fund');

    var path = PactMatchers.Term(r'/api/funds/\d+', '/api/funds/5');
    path['pact:generator:type'] = 'ProviderState';
    path['expression'] = '/api/funds/\${id}';

    // Create a new interaction
    pact
        .newInteraction(description: 'a request to get fund')
        // Set up the provider state
        .given('fund exist in the system')
        // Configure the request
        .withRequest(
          'GET',
          jsonEncode(path),
        )
        // Configure the response
        .willRespondWith(
          200,
          headers: {'Content-Type': 'application/json'},
          body: PactMatchers.SomethingLike(
            {
              'name': PactMatchers.SomethingLike('Family Trip 2026'),
              'transactions': PactMatchers.EachLike({
                'type': PactMatchers.Term(r'income|outcome', 'income'),
                'whoOrReason': PactMatchers.SomethingLike('Alice'),
                'amount': PactMatchers.SomethingLike(500),
                'date': PactMatchers.SomethingLike('2023-01-01T00:00:00Z'),
              }),
            },
          ),
        );

    try {
      // Start the mock server
      pact.run();

      // Here you would write the code to make the HTTP request
      // to the mock server and validate the response
      print('Mock server running at ${pact.addr}');


      var url = Uri.http(pact.addr, '/api/funds/5');
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
