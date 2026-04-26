import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/domain/users/controller/insert_user.controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';

class ImageDropZoneBusinessLicenseInsert extends StatefulWidget {
  final InsertUserController controller;
  final bool isDesktop;

  const ImageDropZoneBusinessLicenseInsert({
    super.key,
    required this.controller,
    required this.isDesktop,
  });

  @override
  State<ImageDropZoneBusinessLicenseInsert> createState() => _ImageDropZoneBusinessLicenseInsertState();
}

class _ImageDropZoneBusinessLicenseInsertState extends State<ImageDropZoneBusinessLicenseInsert> {
  bool _isDragOver = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _setupWebDragAndDrop();
    }
  }

  void _setupWebDragAndDrop() {
    html.document.addEventListener('dragover', _handleDragOver);
    html.document.addEventListener('drop', _handleDrop);
    html.document.addEventListener('dragenter', _handleDragEnter);
    html.document.addEventListener('dragleave', _handleDragLeave);
  }

  void _handleDragOver(html.Event event) {
    event.preventDefault();
    event.stopPropagation();
  }

  void _handleDragEnter(html.Event event) {
    event.preventDefault();
    event.stopPropagation();
    if (_isOverDropZone(event)) {
      _setDragOver(true);
    }
  }

  void _handleDragLeave(html.Event event) {
    event.preventDefault();
    event.stopPropagation();
    if (_isOverDropZone(event)) {
      _setDragOver(false);
    }
  }

  void _handleDrop(html.Event event) {
    event.preventDefault();
    event.stopPropagation();
    if (_isOverDropZone(event)) {
      _handleFileDrop(event);
    }
    _setDragOver(false);
  }

  bool _isOverDropZone(html.Event event) {
    try {
      final mouseEvent = event as html.MouseEvent;
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) return false;

      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      return mouseEvent.client.x >= position.dx &&
          mouseEvent.client.x <= position.dx + size.width &&
          mouseEvent.client.y >= position.dy &&
          mouseEvent.client.y <= position.dy + size.height;
    } catch (e) {
      return false;
    }
  }

  void _handleFileDrop(html.Event event) async {
    try {
      if (mounted) {
        setState(() {
          _isDragOver = false;
        });
      }

      final dynamic dragEvent = event;
      final files = dragEvent.dataTransfer?.files;

      if (files != null && files.length > 0) {
        final List<XFile> xFiles = [];

        for (int i = 0; i < files.length; i++) {
          try {
            final file = files[i];

            final fileName = file.name.toLowerCase();
            final extension = fileName.contains('.') ? fileName.split('.').last : '';
            final mimeType = file.type?.toLowerCase() ?? '';
            final isImageByExtension = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
            final isImageByMimeType = mimeType.startsWith('image/');

            if (!isImageByExtension && !isImageByMimeType) {
              continue;
            }

            final bytes = await _readFileAsBytes(file);
            final xFile = XFile.fromData(
              bytes,
              name: file.name,
              mimeType: file.type,
            );
            xFiles.add(xFile);
          } catch (e) {
            print('Error processing file ${files[i].name}: $e');
          }
        }

        if (xFiles.isNotEmpty) {
          widget.controller.handleDroppedFilesBusinessLicense(xFiles);
        } else {
          Get.snackbar("خطا", "هیچ فایل تصویری معتبری یافت نشد");
        }
      }
    } catch (e) {
      print('Error in _handleFileDrop: $e');
      Get.snackbar("خطا", "خطا در پردازش فایل‌های رها شده");
    }
  }

  Future<Uint8List> _readFileAsBytes(dynamic file) async {
    final completer = Completer<Uint8List>();
    final reader = html.FileReader();

    try {
      reader.onLoad.listen((event) {
        try {
          final result = reader.result;
          if (result is List<int>) {
            completer.complete(Uint8List.fromList(result));
          } else if (result is html.Blob) {
            completer.completeError('Unexpected blob result');
          } else {
            completer.completeError('Unexpected result type: ${result.runtimeType}');
          }
        } catch (e) {
          completer.completeError('Error processing file data: $e');
        }
      });

      reader.onError.listen((event) {
        completer.completeError('Failed to read file: ${reader.error}');
      });

      reader.readAsArrayBuffer(file);
    } catch (e) {
      completer.completeError('Error setting up file reader: $e');
    }

    return completer.future;
  }

  @override
  void dispose() {
    if (kIsWeb) {
      html.document.removeEventListener('dragover', _handleDragOver);
      html.document.removeEventListener('drop', _handleDrop);
      html.document.removeEventListener('dragenter', _handleDragEnter);
      html.document.removeEventListener('dragleave', _handleDragLeave);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: _isDragOver
            ? AppColor.primaryColor.withOpacity(0.1)
            : AppColor.textFieldColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isDragOver
              ? AppColor.primaryColor
              : AppColor.textColor.withOpacity(0.3),
          width: _isDragOver ? 2 : 1,
          style: BorderStyle.solid,
        ),
      ),
      child: kIsWeb ? _buildWebDropZone() : _buildMobileDropZone(),
    );
  }

  Widget _buildWebDropZone() {
    return Stack(alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: MouseRegion(
            onEnter: (_) => _setDragOver(true),
            onExit: (_) => _setDragOver(false),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isDragOver ? Icons.cloud_upload : Icons.cloud_upload_outlined,
              size: 25,
              color: _isDragOver
                  ? AppColor.primaryColor
                  : AppColor.textColor.withOpacity(0.6),
            ),
            const SizedBox(height: 2),
            Text(
              _isDragOver
                  ? 'فایل‌ها را اینجا رها کنید'
                  : 'تصاویر را بکشید یا کلیک کنید',
              style: AppTextStyle.labelText.copyWith(
                color: _isDragOver
                    ? AppColor.primaryColor
                    : AppColor.textColor.withOpacity(0.7),
                fontSize: widget.isDesktop ? 12 : 10,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'JPG, PNG, GIF, BMP, WebP',
              style: AppTextStyle.labelText.copyWith(
                color: AppColor.textColor.withOpacity(0.5),
                fontSize: widget.isDesktop ? 10 : 8,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileDropZone() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _isDragOver ? Icons.cloud_upload : Icons.cloud_upload_outlined,
          size: 25,
          color: _isDragOver
              ? AppColor.primaryColor
              : AppColor.textColor.withOpacity(0.6),
        ),
        const SizedBox(height: 2),
        Text(
          'کلیک کنید',
          style: AppTextStyle.labelText.copyWith(
            color: AppColor.textColor.withOpacity(0.7),
            fontSize: widget.isDesktop ? 12 : 10,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'JPG, PNG, GIF, BMP, WebP',
          style: AppTextStyle.labelText.copyWith(
            color: AppColor.textColor.withOpacity(0.5),
            fontSize: widget.isDesktop ? 10 : 8,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _setDragOver(bool value) {
    if (mounted) {
      setState(() {
        _isDragOver = value;
      });
    }
  }
}
