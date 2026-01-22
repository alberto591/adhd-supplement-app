import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildError(context);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit, // Use the passed fit or default
        fadeInDuration: const Duration(milliseconds: 300),
        placeholder: (context, url) =>
            placeholder ?? _buildPlaceholder(context),
        errorWidget: (context, url, error) =>
            errorWidget ?? _buildError(context),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    // Simple colored box with shimmer-like feel (or just grey for now until Skeleton is ready)
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.red[50],
      child: Icon(
        Icons.broken_image_rounded,
        color: Colors.red[200],
        size: 24,
      ),
    );
  }
}
