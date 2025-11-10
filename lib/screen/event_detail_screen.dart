import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gia_pha_mobile/model/event_model.dart';
import 'package:gia_pha_mobile/utils/EAColors.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:url_launcher/url_launcher.dart';

// replaced google_maps_flutter with flutter_map + latlong2 (OpenStreetMap)
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;

class EAEventDetailScreen extends StatefulWidget {
  final EventModel event;

  const EAEventDetailScreen({super.key, required this.event});

  @override
  _EAEventDetailScreenState createState() => _EAEventDetailScreenState();
}

class _EAEventDetailScreenState extends State<EAEventDetailScreen> {
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

  void _openFullScreenGallery([int initialPage = 0]) {
    if (widget.event.images.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullScreenGallery(images: widget.event.images, initialPage: initialPage),
        fullscreenDialog: true,
      ),
    );
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
    final images = widget.event.images;
    final hasCoords = widget.event.latitude != null && widget.event.longitude != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor1,
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
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor1),
                    onPressed: _openExternalMaps,
                    icon: const Icon(Icons.map, size: 16),
                    label: const Text('Open in maps'),
                  ),
                  8.width,
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor1),
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
                height: 90,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  separatorBuilder: (_, __) => 8.width,
                  itemBuilder: (context, i) {
                    final img = images[i];
                    return GestureDetector(
                      onTap: () => _openFullScreenGallery(i),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 120,
                          height: 90,
                          child: CachedNetworkImage(
                            imageUrl: img.url.toString(),
                            fit: BoxFit.cover,
                            placeholder: (c, u) =>
                                ColoredBox(color: Colors.black12, child: const Center(child: CircularProgressIndicator())),
                            errorWidget: (c, u, e) =>
                                const ColoredBox(color: Colors.black12, child: Center(child: Icon(Icons.error))),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            24.height,
          ],
        ),
      ),
    );
  }
}

// FullScreenGallery (unchanged)
class FullScreenGallery extends StatefulWidget {
  final List<NetworkImage> images;
  final int initialPage;

  const FullScreenGallery({super.key, required this.images, this.initialPage = 0});

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late final PageController _controller;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialPage.clamp(0, widget.images.length - 1);
    _controller = PageController(initialPage: _current);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.images.length,
              onPageChanged: (p) => setState(() => _current = p),
              itemBuilder: (context, index) {
                final item = widget.images[index];
                return Center(
                  child: CachedNetworkImage(
                    imageUrl: item.url.toString(),
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (_, __, ___) => const Center(child: Icon(Icons.error, color: Colors.red)),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: SafeArea(
              child: ClipOval(
                child: Material(
                  color: Colors.black45,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const SizedBox(width: 44, height: 44, child: Icon(Icons.close, color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (i) {
                final active = i == _current;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 10 : 6,
                  height: active ? 10 : 6,
                  decoration: BoxDecoration(color: active ? Colors.white : Colors.white54, shape: BoxShape.circle),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
