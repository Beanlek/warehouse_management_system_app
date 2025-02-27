import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:warehouse/form_page/widget/camera_config.dart';

class ImagesPreview extends HookWidget {
  final List<XFile> files;
  final Function(int index)? onDelete;
  final double previewHeight;
  final double previewWidth;
  final Color iconColor;
  final Color borderColor;

  const ImagesPreview({
    super.key,
    this.previewHeight = 700, // Set a larger preview height
    this.previewWidth = 400, // Set a larger preview width
    this.iconColor = Colors.white,
    this.borderColor = Colors.white,
    this.onDelete,
    required this.files,
  });

  @override
  Widget build(BuildContext context) {
    final ioFiles = useMemoized(
      () => files.map((e) => File(e.path)).toList(),
      [files, files.length],
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < ioFiles.length; i++)
            ImagePreview(
              file: ioFiles[i],
              previewHeight: previewHeight,
              previewWidth: previewWidth,
              borderColor: borderColor,
              iconColor: iconColor,
              onDelete: onDelete == null
                  ? null
                  : () {
                      onDelete?.call(i);
                    },
            ),
        ],
      ),
    );
  }
}

class ImagePreview extends StatelessWidget {
  final File file;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback? onDelete;
  final double previewHeight;
  final double previewWidth;

  const ImagePreview({
    super.key,
    this.previewHeight = 500,
    this.previewWidth = 300,
    this.onDelete,
    required this.file,
    this.iconColor = Colors.white,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            children: [
              Image.file(
                file,
                height: previewHeight,
                width: previewWidth,
                fit: BoxFit.cover,
              ),
              if (onDelete != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
