import 'dart:convert';

import 'package:pact_dart/pact_dart.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Get events', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'event');

    // Create a new interaction
    pact
        .newInteraction(description: 'a request to get events')
        // Set up the provider state
        .given('events exist in the system')
        // Configure the request
        .withRequest(
          'GET',
          '/api/events',
        )
        // Configure the response
        .willRespondWith(
          200,
          headers: {'Content-Type': 'application/json'},
          body: PactMatchers.EachLike(
            {
              'name': PactMatchers.SomethingLike('Anniversary'),
              'address': PactMatchers.SomethingLike('123 Main St, City, Country'),
              'time': PactMatchers.SomethingLike('2023-10-10 10:00:00'),
              'images': PactMatchers.EachLike('https://picsum.photos/125/125'),
              'latitude': PactMatchers.SomethingLike(12.244052),
              'longitude': PactMatchers.SomethingLike(106.623743),
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


      var url = Uri.http(pact.addr, '/api/events');
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

  test('Get event', () async {
    // Create a Pact between the consumer and provider
    final pact = PactMockService('mobile', 'event');

    var path = PactMatchers.Term(r'/api/events/\d+', '/api/events/5');
    path['pact:generator:type'] = 'ProviderState';
    path['expression'] = '/api/events/\${id}';

    // Create a new interaction
    pact
        .newInteraction(description: 'a request to get event')
        // Set up the provider state
        .given('event exist in the system')
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
              'name': PactMatchers.SomethingLike('Anniversary'),
              'address': PactMatchers.SomethingLike('123 Main St, City, Country'),
              'time': PactMatchers.SomethingLike('2023-10-10 10:00:00'),
              'images': PactMatchers.EachLike('https://picsum.photos/125/125'),
              'latitude': PactMatchers.SomethingLike(12.244052),
              'longitude': PactMatchers.SomethingLike(106.623743),
            },
          ),
        );

    try {
      // Start the mock server
      pact.run();

      // Here you would write the code to make the HTTP request
      // to the mock server and validate the response
      print('Mock server running at ${pact.addr}');


      var url = Uri.http(pact.addr, '/api/events/5');
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
