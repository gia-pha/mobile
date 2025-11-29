import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';

class HtmlPageViewer extends StatelessWidget {
  final String htmlContent;
  final String baseUrl;

  const HtmlPageViewer({
    Key? key,
    required this.htmlContent,
    this.baseUrl = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlContent,
      style: {
        "body": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.symmetric(horizontal: 16, vertical: 12),
        ),
        "h1": Style(fontSize: FontSize(24)),
        "h2": Style(fontSize: FontSize(20)),
        "h3": Style(fontSize: FontSize(18)),
        "p": Style(lineHeight: LineHeight(1.6)),
        "ul": Style(margin: Margins.symmetric(vertical: 8)),
        "li": Style(lineHeight: LineHeight(1.5)),
        "iframe": Style(direction: TextDirection.ltr),
      },
      extensions: [
        IframeHtmlExtension()
      ],
    );
  }
}