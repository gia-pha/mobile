import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Widget buildDivider({bool isFull = false}) {
  return Divider(color: Colors.grey).paddingLeft(isFull ? 0 : 16);
}
