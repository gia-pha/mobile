import 'package:flutter/material.dart';
import 'package:gia_pha_mobile/model/FamilyMember.dart';
import 'package:org_chart/org_chart.dart';

class GenogramNode extends StatelessWidget {
  const GenogramNode({
    super.key,
    required this.details,
    required this.onToggleNodes,
  });

  final NodeBuilderDetails<FamilyMember> details;
  final Function(bool? hide) onToggleNodes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final member = details.item;

    return Container(
      decoration: BoxDecoration(
        boxShadow: details.isBeingDragged
            ? [BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 1)]
            : null,
      ),
      child: CustomPaint(
        painter: GenogramShapePainter(
          gender: member.gender,
          isDeceased: member.isDeceased,
          isSelected: details.isBeingDragged || details.isOverlapped,
          color: _getNodeColor(theme, member),
          borderColor: _getBorderColor(theme, details.isOverlapped),
        ),
        child: SizedBox(
          //width: 150,
          //height: 250,
          //child: Padding(
            //padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                // Avatar row
                Center(
                  child: ClipOval(
                    child: Container(
                      width: 48,
                      height: 48,
                      color: Colors.grey.shade700,
                      child: member.avatarUrl != null
                          ? ColorFiltered(
                              // tint the image to a single grey color when deceased,
                              // otherwise show the normal image
                              colorFilter: member.isDeceased
                                  ? ColorFilter.mode(Colors.grey.shade700, BlendMode.color)
                                  : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                              child: member.avatarUrl!.startsWith('http')
                                  ? Image.network(
                                      member.avatarUrl!,
                                      fit: BoxFit.cover,
                                      width: 48,
                                      height: 48,
                                    )
                                  : Image.asset(
                                      member.avatarUrl!,
                                      fit: BoxFit.cover,
                                      width: 48,
                                      height: 48,
                                    ),
                            )
                          : Icon(
                              member.gender == 1 ? Icons.person_outline : Icons.person,
                              size: 28,
                              color: Colors.grey.shade900,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: member.isDeceased ? Colors.grey.shade100 : _getTextColor(member.gender),
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                if (member.dateOfBirth != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cake,
                          size: 14,
                          color: member.isDeceased ? Colors.grey.shade100 : _getTextColor(member.gender)
                              .withValues(alpha: 0.7)),
                      //const SizedBox(width: 4),
                      Text(
                        _formatDate(member.dateOfBirth!),
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
                if (member.isDeceased && member.dateOfDeath != null)
                  Text(
                    _formatDate(member.dateOfDeath!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (!member.isDeceased && member.dateOfBirth != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _calculateAge(member.dateOfBirth!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  member.kinship,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: member.isDeceased ? Colors.grey.shade100 : Colors.grey.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      //),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}';
  }

  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return '$age years';
  }

  Color _getNodeColor(ThemeData theme, FamilyMember member) {
    final isDark = theme.brightness == Brightness.dark;

    switch (member.gender) {
      case 0: // Male
        return isDark ? Colors.blue.shade900 : Colors.blue.shade50;
      case 1: // Female
        return isDark ? Colors.pink.shade900 : Colors.pink.shade50;
      default: // Other
        return isDark ? Colors.purple.shade900 : Colors.purple.shade50;
    }
  }

  Color _getBorderColor(ThemeData theme, bool isOverlapped) {
    if (isOverlapped) {
      return theme.colorScheme.primary;
    }
    return Colors.grey.shade500;
  }

  Color _getTextColor(int gender) {
    // Get current brightness mode
    final BuildContext? context =
        WidgetsBinding.instance.focusManager.primaryFocus?.context;
    final bool isDark =
        context != null && Theme.of(context).brightness == Brightness.dark;

    // Use light colors for dark theme and vice versa
    if (isDark) {
      switch (gender) {
        case 0:
          return Colors.blue.shade100;
        case 1:
          return Colors.pink.shade100;
        default:
          return Colors.purple.shade100;
      }
    } else {
      switch (gender) {
        case 0:
          return Colors.blue.shade900;
        case 1:
          return Colors.pink.shade900;
        default:
          return Colors.purple.shade900;
      }
    }
  }
}

/// Custom painter for genogram node shapes based on gender
class GenogramShapePainter extends CustomPainter {
  final int gender;
  final bool isDeceased;
  final bool isSelected;
  final Color color;
  final Color borderColor;

  GenogramShapePainter({
    required this.gender,
    required this.isDeceased,
    required this.isSelected,
    required this.color,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDeceased ? Colors.grey : color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 3.0 : 1.5;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw shape based on gender
    switch (gender) {
      case 0:
        // Male: Square
        final square = Rect.fromCenter(
          center: center,
          width: size.width * 0.8,
          height: size.height * 1.2,
        );
        canvas.drawRect(square, paint);
        canvas.drawRect(square, borderPaint);
        break;

      case 1:
        // Female: Circle
        // canvas.drawCircle(
        //   center,
        //   size.width * 0.4,
        //   paint,
        // );
        // canvas.drawCircle(
        //   center,
        //   size.width * 0.4,
        //   borderPaint,
        // );
        final square = Rect.fromCenter(
          center: center,
          width: size.width * 0.8,
          height: size.height * 1.2,
        );
        canvas.drawOval(
          square,
          paint,
        );
        canvas.drawOval(
          square,
          borderPaint,
        );
        break;

      default:
        // Unknown or Other: Diamond
        final path = Path();
        path.moveTo(center.dx, center.dy - size.height * 0.4); // Top
        path.lineTo(center.dx + size.width * 0.4, center.dy); // Right
        path.lineTo(center.dx, center.dy + size.height * 0.4); // Bottom
        path.lineTo(center.dx - size.width * 0.4, center.dy); // Left
        path.close();

        canvas.drawPath(path, paint);
        canvas.drawPath(path, borderPaint);
        break;
    }

    // Draw deceased indicator (diagonal line through shape)
    /*if (isDeceased) {
      final deceasedPaint = Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      // Diagonal line from top-left to bottom-right
      canvas.drawLine(
        Offset(center.dx - size.width * 0.4, center.dy - size.height * 0.4),
        Offset(center.dx + size.width * 0.4, center.dy + size.height * 0.4),
        deceasedPaint,
      );
    }*/
  }

  @override
  bool shouldRepaint(covariant GenogramShapePainter oldDelegate) {
    return oldDelegate.gender != gender ||
        oldDelegate.isDeceased != isDeceased ||
        oldDelegate.isSelected != isSelected ||
        oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor;
  }
}
