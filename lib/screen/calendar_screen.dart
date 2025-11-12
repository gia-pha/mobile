import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:gia_pha_mobile/model/event_model.dart';
import 'package:gia_pha_mobile/screen/future_event_detail_screen.dart';
import 'package:gia_pha_mobile/utils/events_data_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController<EventModel>()..addAll(_events),
      child: MaterialApp(
        title: 'Flutter Calendar Page Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        scrollBehavior: ScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.trackpad,
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          },
        ),
        home: Scaffold(
          body: MonthView(
            //key: state,
            //width: width,
            showWeekends: true,
            startDay: WeekDays.monday,
            useAvailableVerticalSpace: true,
            onEventTap: (CalendarEventData<EventModel> event, date) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FutureEventDetailScreen(
                    event: event.event!,
                    //date: date,
                  ),
                ),
              );
            },
            onEventLongTap: (event, date) {
              SnackBar snackBar = SnackBar(content: Text("on LongTap"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ),
      ),
    );
  }
}

DateTime get _now => DateTime.now();

List<CalendarEventData<EventModel>> _events = events.map((event) => CalendarEventData<EventModel>(
  //date: DateTime.parse(event.time),
  date: _now,
  title: event.name,
  event: event,
)).toList();
