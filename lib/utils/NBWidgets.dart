import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:gia_pha_mobile/utils/NBColors.dart';
import 'package:url_launcher/url_launcher.dart';

Widget nbAppButtonWidget(BuildContext context, String text, Function onTap) {
  return AppButton(
    text: text,
    textStyle: boldTextStyle(color: white),
    color: NBPrimaryColor,
    onTap: onTap,
    width: context.width(),
  ).cornerRadiusWithClipRRect(20);
}

AppBar nbAppBarWidget(BuildContext context, {String? title}) {
  return AppBar(
    leading: IconButton(
        icon: Icon(Icons.arrow_back,color: black),
        onPressed: () {
          finish(context);
        }),
    title: Text('$title', style: boldTextStyle(color: black, size: 20)),
    backgroundColor: white,
    centerTitle: true,
  );
}

Future<void> launchURL(String url, {bool forceWebView = false}) async {
  await launch(url, enableJavaScript: true, forceWebView: forceWebView).catchError((e) {
    throw '$url is not valid';
  });
}
