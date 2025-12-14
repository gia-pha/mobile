import 'dart:convert';
import 'package:pact_dart/pact_dart.dart';
import 'package:test/test.dart';
import 'package:gia_pha_mobile/services/api_service.dart';
import 'package:dio/dio.dart'; // Import Dio for ResponseType

void main() {
  test('Get an image', () async {
    final pact = PactMockService('mobile', 'image');

    var path = PactMatchers.Term(r'/api/images/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', '/api/images/796468e4-4fcd-414a-b39d-589c42c24eaa');
    path['pact:generator:type'] = 'ProviderState';
    path['expression'] = '/api/images/\${uuid}';

    // A user solid icon from Font Awesome in PNG format
    final pngData = base64Decode(
      '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'
    );

    pact
        .newInteraction(
          description: 'a request to get an image',
        )
        .given('image exist in the system')
        .withRequest(
          'GET',
          jsonEncode(path),
        )
        .willRespondWith(
          200,
          headers: {'Content-Type': PactMatchers.SomethingLike('image/png')},
          body: pngData,
          contentType: 'image/png',
        );

    try {
      pact.run();
      
      final apiService = ApiService(baseUrl: 'http://${pact.addr}');
      final response = await apiService.get(
        '/api/images/cd86ad42-0018-4a56-ad80-10aef6031827',
        responseType: ResponseType.bytes,
      );

      expect(response.statusCode, 200);
      expect(response.data, equals(pngData)); // response.data will be Uint8List

      pact.writePactFile(directory: 'test/outputs/contracts');
    } finally {
      pact.reset();
    }
  });
}
