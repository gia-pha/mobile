part of 'NBDottedBorder.dart';

typedef PathBuilder = Path Function(Size);

class _DashPainter extends CustomPainter {
  final double strokeWidth;
  final List<double> dashPattern;
  final Color color;
  final BorderType borderType;
  final Radius radius;
  final PathBuilder? customPath;
  final StrokeCap strokeCap;

  _DashPainter({
    this.strokeWidth = 2,
    this.dashPattern = const <double>[3, 1],
    this.color = Colors.black,
    this.borderType = BorderType.Rect,
    this.radius = const Radius.circular(0),
    this.customPath,
    this.strokeCap = StrokeCap.butt,
  }) {
    assert(dashPattern.isNotEmpty, 'Dash Pattern cannot be empty');
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..color = color
      ..strokeCap = strokeCap
      ..style = PaintingStyle.stroke;

    Path path;
    if (customPath != null) {
      // _path = dashPath(
      //   customPath!(size),
      //   dashArray: CircularIntervalList(dashPattern),
      // );
    } else {
      // _path = _getPath(size);
    }

    // canvas.drawPath(_path, paint);
  }

  /// Returns a [Path] based on the the [borderType] parameter
  // Path _getPath(Size size) {
  //   late Path path;
  //   switch (borderType) {
  //     case BorderType.Circle:
  //       path = _getCirclePath(size);
  //       break;
  //     case BorderType.RRect:
  //       path = _getRRectPath(size, radius);
  //       break;
  //     case BorderType.Rect:
  //       path = _getRectPath(size);
  //       break;
  //     case BorderType.Oval:
  //       path = _getOvalPath(size);
  //       break;
  //   }
  //
  //   // return dashPath(path, dashArray: CircularIntervalList(dashPattern));
  // }

  /// Returns a circular path of [size]
  Path _getCirclePath(Size size) {
    double w = size.width;
    double h = size.height;
    double s = size.shortestSide;

    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            w > s ? (w - s) / 2 : 0,
            h > s ? (h - s / 2) : 0,
            s,
            s,
          ),
          Radius.circular(s / 2),
        ),
      );
  }

  /// Returns a Rounded Rectangular Path with [radius] of [size]
  Path _getRRectPath(Size size, Radius radius) {
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            0,
            0,
            size.width,
            size.height,
          ),
          radius,
        ),
      );
  }

  /// Returns a path of [size]
  Path _getRectPath(Size size) {
    return Path()
      ..addRect(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
      );
  }

  /// Return an oval path of [size]
  Path _getOvalPath(Size size) {
    return Path()
      ..addOval(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
      );
  }

  @override
  bool shouldRepaint(_DashPainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth || oldDelegate.color != color || oldDelegate.dashPattern != dashPattern || oldDelegate.borderType != borderType;
  }
}
