import 'package:flutter/material.dart';

class EventModel {
  String name;
  String address;
  String time;
  List<NetworkImage> images;
  double? latitude;
  double? longitude;

  EventModel({
    required this.name,
    required this.address,
    required this.time,
    this.images = const [],
    this.latitude,
    this.longitude,
  });
}
