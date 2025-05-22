import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

const EASender_id = 1;
const EAReceiver_id = 2;

const EAFashionstitle =
    'Fashions Fitness AW18 \nDuring New York Fashion \nWeek';
const EAFashionsSubtitle =
    'Fashion can also simply mean our lifestyle: the clothing and accessories that we wear and the cosmetics that we apply.Besides clothing, ornaments, accessories, and make up, it also includes our mannerism and behavior.';
const EAFashionsSubtitle1 =
    'Fashion is a form of self-expression and autonomy at a particular period and place and in a specific context, of clothing, footwear, lifestyle, accessories, makeup, hairstyle, and body posture. In its everyday use, the term implies a look defined by the fashion industry as that which is trending.';

const purchaseURL =
    'https://codecanyon.net/item/prokit-flutter-app-ui-design-templete-kit/25787190';

Future<void> launchUrl(String url, {bool forceWebView = false}) async {
  await launch(url,
          forceWebView: forceWebView,
          enableJavaScript: true,
          statusBarBrightness: Brightness.light)
      .catchError((e) {
    toast('Invalid URL: $url');
  });
}
