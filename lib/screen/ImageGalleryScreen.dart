import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_gallery/simple_gallery.dart';

const kGridItemPadding = 4.0;
const kCrossAxisCount = 3;

class ImageGalleryScreen extends StatefulWidget {
  const ImageGalleryScreen({super.key});

  @override
  State<ImageGalleryScreen> createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  List<NetworkImage> listNetworkImages = [
    const NetworkImage('https://picsum.photos/200/300'),
    const NetworkImage('https://picsum.photos/1140/703'),
    const NetworkImage('https://picsum.photos/1200/675'),
    const NetworkImage('https://picsum.photos/300'),
    const NetworkImage('https://picsum.photos/300/450'),
    const NetworkImage('https://picsum.photos/271/644'),
    const NetworkImage('https://picsum.photos/300/250'),
    const NetworkImage('https://picsum.photos/250'),
    const NetworkImage('https://picsum.photos/244/400'),
    const NetworkImage('https://picsum.photos/336/280'),
    const NetworkImage('https://picsum.photos/180/150'),
    const NetworkImage('https://picsum.photos/720/300'),
    const NetworkImage('https://picsum.photos/468/60'),
    const NetworkImage('https://picsum.photos/88/31'),
    const NetworkImage('https://picsum.photos/120/90'),
    const NetworkImage('https://picsum.photos/120/60'),
    const NetworkImage('https://picsum.photos/120/240'),
    const NetworkImage('https://picsum.photos/125/125'),
    const NetworkImage('https://picsum.photos/728/90'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SimpleGallery<NetworkImage>(
          items: listNetworkImages,
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
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Icon(Icons.favorite, color: Colors.pink),
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
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Icon(Icons.favorite, color: Colors.pink),
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
    );
  }
}
