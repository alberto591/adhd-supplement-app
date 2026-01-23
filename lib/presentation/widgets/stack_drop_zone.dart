import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'stack_item_card.dart';

// Definition of a draggable item data
class LibraryItemData {
  final String id;
  final String name;
  final String dosage;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  LibraryItemData({
    required this.id,
    required this.name,
    required this.dosage,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

class StackDropZone extends StatefulWidget {
  final List<LibraryItemData> currentItems;
  final void Function(String) onItemDropped;
  final void Function(int) onItemRemoved;
  final void Function(int, int)? onReorder;

  const StackDropZone({
    super.key,
    required this.currentItems,
    required this.onItemDropped,
    required this.onItemRemoved,
    this.onReorder,
  });

  @override
  State<StackDropZone> createState() => _StackDropZoneState();
}

class _StackDropZoneState extends State<StackDropZone> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) {
        setState(() => _isHovering = true);
        return true;
      },
      onLeave: (data) {
        setState(() => _isHovering = false);
      },
      onAcceptWithDetails: (details) {
        setState(() => _isHovering = false);
        widget.onItemDropped(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        // unused isDark variable removed

        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 300),
          decoration: BoxDecoration(
            color: _isHovering
                ? AppColors.cardDark.withValues(alpha: 0.5)
                : AppColors.cardDark.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovering
                  ? AppColors.primary
                  : AppColors.secondary.withValues(alpha: 0.2),
              width: 2,
              style: BorderStyle.none,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _DashedBorderPainter(
                    color: _isHovering
                        ? AppColors.primary
                        : AppColors.secondary.withValues(alpha: 0.2),
                    strokeWidth: 2,
                    gap: 5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (widget.currentItems.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.drag_indicator,
                              size: 48,
                              color: AppColors.textSecondaryDark
                                  .withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Drag supplements here to build your morning routine.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondaryDark
                                    .withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.currentItems.length,
                        onReorder: widget.onReorder ?? (oldIndex, newIndex) {},
                        itemBuilder: (context, index) {
                          final item = widget.currentItems[index];
                          return StackItemCard(
                            key: ValueKey(item.id),
                            name: item.name,
                            dosage: item.dosage,
                            icon: item.icon,
                            iconColor: item.iconColor,
                            iconBgColor: item.iconBgColor,
                            onRemove: () => widget.onItemRemoved(index),
                          );
                        },
                      ),
                    ],

                    // Drop Target Indicator at bottom
                    if (widget.currentItems.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 48,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Drop here',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  _DashedBorderPainter(
      {required this.color, required this.strokeWidth, required this.gap});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16),
      ));

    final Path dashedPath = _dashPath(path, width: 10, space: gap);
    canvas.drawPath(dashedPath, paint);
  }

  Path _dashPath(Path source, {required double width, required double space}) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        dest.addPath(
          metric.extractPath(distance, distance + width),
          Offset.zero,
        );
        distance += width + space;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
