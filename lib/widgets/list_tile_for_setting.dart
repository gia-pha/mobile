import 'package:flutter/material.dart';

Widget buildListTileForSetting({required String title, String subTitle = "", Widget? trailing, Widget? leading, Color? color, Function? onTap, bool isEnable = true}) {
  return ListTile(
    enabled: isEnable,
    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
    title: Text(title, style: TextStyle(color: color.toString().isEmpty ? Colors.black : color)),
    subtitle: subTitle.isEmpty ? null : Text(subTitle),
    trailing: trailing,
    leading: leading,
    onTap: onTap as void Function()?,
  );
}
