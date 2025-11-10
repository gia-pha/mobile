import 'package:gia_pha_mobile/model/event_model.dart';
import 'package:gia_pha_mobile/utils/EAColors.dart';
import 'package:gia_pha_mobile/utils/events_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';

import 'event_detail_screen.dart';

class EAForYouTabScreen extends StatefulWidget {
  const EAForYouTabScreen({super.key});

  @override
  EAForYouTabScreenState createState() => EAForYouTabScreenState();
}

class EAForYouTabScreenState extends State<EAForYouTabScreen> {
  List<EventModel> eventsFiltered = [];
  String searchQuery = '';
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: searchQuery);
    init();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> init() async {
    // initialize filtered list with all events
    eventsFiltered = List.from(events);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _onSearchChanged(String value) {
    final q = value.trim().toLowerCase();
    setState(() {
      searchQuery = value;
      if (q.isEmpty) {
        eventsFiltered = List.from(events);
      } else {
        eventsFiltered = events.where((e) {
          final name = (e.name ?? '').toString().toLowerCase();
          final address = (e.address ?? '').toString().toLowerCase();
          return name.contains(q) || address.contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search box replacing the static text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.all(16),
              decoration: boxDecorationRoundedWithShadow(8),
              child: Row(
                children: [
                  Icon(Icons.search, color: primaryColor1),
                  8.width,
                  Expanded(
                    child: TextField(
                      onChanged: _onSearchChanged,
                      controller: _searchController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Search events by name or address',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        // reduce space reserved for the suffix icon
                        suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                // remove IconButton's internal padding and tighten constraints
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              )
                            : null,
                      ),
                      style: primaryTextStyle(color: primaryColor1, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 40),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: eventsFiltered.length,
              itemBuilder: (context, i) {
                final event = eventsFiltered[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                    onTap: () {
                      EAEventDetailScreen(event: event).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // thumbnail (use EventModel.images instead of non-existent imageUrl)
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                              image: event.images.isNotEmpty
                                  ? DecorationImage(image: event.images.first, fit: BoxFit.cover)
                                  : null,
                            ),
                            child: event.images.isEmpty
                                ? const Icon(Icons.event, color: Colors.grey)
                                : null,
                          ),
                          12.width,
                          // main text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.name ?? '',
                                  style: boldTextStyle(size: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                4.height,
                                Row(
                                  children: [
                                    const Icon(Entypo.location, size: 14, color: Colors.grey),
                                    6.width,
                                    Expanded(
                                      child: Text(
                                        event.address ?? '',
                                        style: secondaryTextStyle(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          8.width,
                          // metadata / time
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                event.time ?? '',
                                style: secondaryTextStyle(color: primaryColor1),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              6.height,
                              // small badge (distance or type)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: primaryColor1.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '10 km', // placeholder since EventModel has no distance field
                                  style: primaryTextStyle(size: 12, color: primaryColor1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
