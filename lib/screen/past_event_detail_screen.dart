import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gia_pha_mobile/model/event_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:simple_gallery/simple_gallery.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

// replaced google_maps_flutter with flutter_map + latlong2 (OpenStreetMap)
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;

class PastEventDetailScreen extends StatefulWidget {
  final EventModel event;

  const PastEventDetailScreen({super.key, required this.event});

  @override
  _PastEventDetailScreenState createState() => _PastEventDetailScreenState();
}

class _PastEventDetailScreenState extends State<PastEventDetailScreen> {
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
    final images = widget.event.images;
    final hasCoords = widget.event.latitude != null && widget.event.longitude != null;

    // responsive gallery height: 16:9 based on width, min 180, max 60% of screen height
    final mq = MediaQuery.of(context);
    final galleryHeight = math.min(math.max(mq.size.width * 9 / 16, 180.0), mq.size.height * 0.6);

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
                    label: const Text('Open in maps', style: TextStyle(color: Colors.white)),
                  ),
                  8.width,
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.event.address));
                      toast('Address copied');
                    },
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copy address', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            16.height,
            // Photos preview strip (bottom). tap a thumbnail to open full-screen gallery
            if (images.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Photos'.toUpperCase(), style: boldTextStyle(color: Colors.grey)),
              ),
            if (images.isNotEmpty) 8.height,
            if (images.isNotEmpty)
              SizedBox(
                height: galleryHeight,
                child: SimpleGallery<NetworkImage>(
                  items: images,
                  itemSize: (item) async => Size(1, 1),
                  itemBuilder: (context, item, itemSize, viewSize) {
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: item.url.toString(),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: ColoredBox(
                                color: Colors.black38,
                                child: Center(child: CircularProgressIndicator()),
                              ),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  placeholderBuilder: (context, item) {
                    return ColoredBox(
                      color: Colors.black38,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  detailDecoration: DetailDecoration(
                    detailBuilder: (context, item, itemSize, viewSize) {
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: CachedNetworkImage(
                              imageUrl: item.url.toString(),
                              fit: BoxFit.contain,
                              placeholder: (context, url) => Center(
                                child: ColoredBox(
                                  color: Colors.black38,
                                  child: Center(child: CircularProgressIndicator()),
                                ),
                              ),
                              errorWidget: (context, url, error) => Center(
                                child: Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    placeholderBuilder: (context, item) {
                      return ColoredBox(
                        color: Colors.black38,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    pageGap: 16,
                  ),
                ),
              ),
            24.height,
          ],
        ),
      ),
    );
  }
}
