import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../controller/chat.controller.dart';
import '../utils/chat_attachment_utils.dart';

class ChatImageThumbnail extends StatefulWidget {
  const ChatImageThumbnail({
    super.key,
    required this.controller,
    required this.recordId,
    this.fileName,
    this.pixelSize,
  });

  final ChatController controller;
  final String recordId;
  final String? fileName;
  final ChatImagePixelSize? pixelSize;

  @override
  State<ChatImageThumbnail> createState() => _ChatImageThumbnailState();
}

class _ChatImageThumbnailState extends State<ChatImageThumbnail> {
  Uint8List? _bytes;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cached = widget.controller.getCachedAttachment(widget.recordId);
    if (cached?.bytes != null) {
      if (!mounted) return;
      setState(() {
        _bytes = cached!.bytes;
        _loading = false;
        _failed = false;
      });
      return;
    }
    final data =
        await widget.controller.fetchChatAttachmentBytes(widget.recordId);
    if (!mounted) return;
    if (data == null) {
      setState(() {
        _loading = false;
        _failed = true;
      });
      return;
    }
    setState(() {
      _bytes = data;
      _loading = false;
      _failed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = chatImageThumbnailBoxSize(pixelSize: widget.pixelSize);
    if (_loading) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: box.width,
            height: box.height,
            color: Colors.white.withAlpha(12),
            alignment: Alignment.center,
            child: const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white54,
              ),
            ),
          ),
        ),
      );
    }
    if (_failed || _bytes == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _load,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: box.width,
                height: box.height,
                color: Colors.white.withAlpha(12),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white54,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return chatImageAttachmentThumbnail(
      context: context,
      bytes: _bytes!,
      saveFileName: widget.fileName ??
          (widget.recordId.length >= 8
              ? 'chat_${widget.recordId.substring(0, 8)}'
              : 'chat_${widget.recordId}'),
      pixelSize: widget.pixelSize,
    );
  }
}
