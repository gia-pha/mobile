import 'package:flutter/material.dart';

Widget createBasicListTile({IconData? icon, required String text, Function? onTap}) {
  return ListTile(
    contentPadding: EdgeInsets.all(0),
    visualDensity: VisualDensity(horizontal: -4, vertical: -2),
    onTap: onTap as void Function()?,
    title: Text(text, style: TextStyle(fontSize: 16)),
    leading: Icon(icon, color: Colors.black, size: 22),
  );
}
