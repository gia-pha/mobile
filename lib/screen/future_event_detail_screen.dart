import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gia_pha_mobile/model/event_model.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:url_launcher/url_launcher.dart';

// replaced google_maps_flutter with flutter_map + latlong2 (OpenStreetMap)
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;

class FutureEventDetailScreen extends StatefulWidget {
  final EventModel event;

  const FutureEventDetailScreen({super.key, required this.event});

  @override
  _FutureEventDetailScreenState createState() => _FutureEventDetailScreenState();
}

class _FutureEventDetailScreenState extends State<FutureEventDetailScreen> {
  late PageController pageController;
  int currentIndexPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> _openExternalMaps() async {
    final lat = widget.event.latitude;
    final lng = widget.event.longitude;
    Uri uri;
    if (lat != null && lng != null) {
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    } else {
      final q = Uri.encodeComponent(widget.event.address);
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$q');
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      toast('Could not open maps');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasCoords = widget.event.latitude != null && widget.event.longitude != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.event.name, style: boldTextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Information header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Information'.toUpperCase(), style: boldTextStyle(color: Colors.grey)),
            ),
            8.height,

            // Time
            if (widget.event.time.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.timelapse_rounded, size: 18),
                    8.width,
                    Text(widget.event.time, style: primaryTextStyle()),
                  ],
                ),
              ),
            12.height,

            // Address
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, size: 18),
                  8.width,
                  Expanded(
                    child: Text(widget.event.address, style: secondaryTextStyle()),
                  ),
                ],
              ),
            ),
            16.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
                    onPressed: () => {},
                    icon: const Icon(Icons.notifications_active, size: 16),
                    label: const Text('Notify me'),
                  ),
                  8.width,
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
                    onPressed: () => {},
                    icon: const Icon(Icons.event, size: 16),
                    label: const Text('Add to calendar'),
                  ),
                ],
              ),
            ),

            // Real map (flutter_map / OpenStreetMap) when coords available.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Map'.toUpperCase(), style: boldTextStyle(color: Colors.grey)),
            ),
            8.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: SizedBox(
                  height: 220,
                  child: hasCoords
                      ? FlutterMap(
                          options: MapOptions(
                            initialCenter: ll.LatLng(widget.event.latitude!, widget.event.longitude!),
                            initialZoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: const ['a', 'b', 'c'],
                              userAgentPackageName: 'com.example.app',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: ll.LatLng(widget.event.latitude!, widget.event.longitude!),
                                  width: 48,
                                  height: 48,
                                  child: const Icon(Icons.location_on, size: 40, color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(color: Colors.blueGrey.shade100),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.map, size: 48, color: Colors.blueGrey.shade700),
                                  8.height,
                                  Text(
                                    widget.event.address,
                                    textAlign: TextAlign.center,
                                    style: secondaryTextStyle(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            8.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
                    onPressed: _openExternalMaps,
                    icon: const Icon(Icons.map, size: 16),
                    label: const Text('Open in maps'),
                  ),
                  8.width,
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.event.address));
                      toast('Address copied');
                    },
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copy address'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
