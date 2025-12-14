import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/services/api_service.dart';
import 'package:gia_pha_mobile/widgets/html_page_viewer.dart';
import 'package:nb_utils/nb_utils.dart';

class FamilyIntroScreen extends StatefulWidget {
  const FamilyIntroScreen({super.key});

  @override
  FamilyIntroScreenState createState() => FamilyIntroScreenState();
}

class FamilyIntroScreenState extends State<FamilyIntroScreen> {
  late Future<String> _futureHtmlContent;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _futureHtmlContent = _fetchFamilyAndExtractIntro();
  }

  Future<String> _fetchFamilyAndExtractIntro() async {
    final introDataResponse = await _apiService.get('/api/families/1');
    if (introDataResponse.statusCode != 200) {
      throw Exception('Failed to load family intro data');
    }

    final family = introDataResponse.data;
    String htmlTemplate = family['introduction'];

    return htmlTemplate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: _futureHtmlContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No content available.'));
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HtmlPageViewer(htmlContent: snapshot.data!),
                  24.height,
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
