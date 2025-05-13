import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile/utils/colors.dart';

Future buildCommonDialog(BuildContext context, {String? title, String? content, String posBtn = "OK", String negBtn = "Cancel"}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        buttonPadding: EdgeInsets.all(8),
        contentPadding: EdgeInsets.fromLTRB(25, 16, 32, 8),
        insetPadding: EdgeInsets.all(16),
        title: title.isEmptyOrNull ? null : Text(title!, style: boldTextStyle(size: 24)),
        content: Text(content!),
        actions: [
          TextButton(
            child: Text(negBtn, style: boldTextStyle(size: 16, color: Colors.grey)),
            onPressed: () {
              finish(context, false);
            },
          ),
          TextButton(
            child: Text(posBtn, style: boldTextStyle(size: 16, color: darkBlueColor)),
            onPressed: () {
              finish(context, true);
            },
          ),
        ],
      );
    },
  );
}
