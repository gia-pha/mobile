import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../utils/calendar_extension.dart';

class DetailsPage extends StatelessWidget {
  final CalendarEventData event;
  final DateTime date;

  const DetailsPage({
    required this.event,
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: event.color,
        elevation: 0,
        centerTitle: false,
        title: Text(
          event.title,
          style: TextStyle(
            color: event.color.accentColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: context.pop,
          icon: Icon(
            Icons.arrow_back,
            color: event.color.accentColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(
            "Date: ${event.date.dateToStringWithFormat(format: "dd/MM/yyyy")}",
          ),
          SizedBox(
            height: 15.0,
          ),
          if (event.startTime != null && event.endTime != null) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("From"),
                      Text(
                        event.startTime
                                ?.getTimeInFormat(TimeStampFormat.parse_12) ??
                            "",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("To"),
                      Text(
                        event.endTime
                                ?.getTimeInFormat(TimeStampFormat.parse_12) ??
                            "",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
          ],
          if (event.description?.isNotEmpty ?? false) ...[
            Divider(),
            Text("Description"),
            SizedBox(
              height: 10.0,
            ),
            Text(event.description!)
          ],
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
