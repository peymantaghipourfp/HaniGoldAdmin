import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/chat/controller/chat.controller.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat_history.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../utils/chat_history_viewer.dart';

Future<void> showChatHistoryInfoDialog(
  BuildContext context, {
  required String chatId,
  required ChatController chatController,
  String? title,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: _ChatHistoryInfoDialogBody(
          chatId: chatId,
          chatController: chatController,
          title: title,
        ),
      );
    },
  );
}

class ChatHistoryInfoButton extends StatelessWidget {
  final String? chatId;
  final ChatController chatController;
  final String? title;

  const ChatHistoryInfoButton({
    super.key,
    required this.chatId,
    required this.chatController,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = chatId != null;
    return IconButton(
      tooltip: enabled ? 'اطلاعات گفتگو' : 'شناسه گفتگو نامعتبر است',
      onPressed: enabled
          ? () => showChatHistoryInfoDialog(
                context,
                chatId: chatId!,
                chatController: chatController,
                title: title,
              )
          : null,
      icon: Icon(
        Icons.info_outline,
        size: 18,
        color: enabled
            ? AppColor.buttonColor.withAlpha(220)
            : AppColor.textColor.withAlpha(110),
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
      style: IconButton.styleFrom(
        backgroundColor: AppColor.buttonColor.withAlpha(14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: AppColor.buttonColor.withAlpha(35)),
      ),
    );
  }
}

class _ChatHistoryInfoDialogBody extends StatefulWidget {
  final String chatId;
  final ChatController chatController;
  final String? title;

  const _ChatHistoryInfoDialogBody({
    required this.chatId,
    required this.chatController,
    required this.title,
  });

  @override
  State<_ChatHistoryInfoDialogBody> createState() =>
      _ChatHistoryInfoDialogBodyState();
}

class _ChatHistoryInfoDialogBodyState
    extends State<_ChatHistoryInfoDialogBody> {
  late Future<ChatHistoryModel?> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = widget.chatController.getChatHistoryInfo(widget.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 560),
      decoration: BoxDecoration(
        color: AppColor.secondary100Color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.textColor.withAlpha(35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColor.secondary50Color,
              border: Border(
                bottom: BorderSide(color: AppColor.textColor.withAlpha(35)),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    size: 18, color: AppColor.buttonColor.withAlpha(220)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title ?? 'اطلاعات گفتگو',
                    style: AppTextStyle.bodyText.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColor.textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close,
                      size: 20, color: AppColor.textColor.withAlpha(200)),
                  tooltip: 'بستن',
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: FutureBuilder<ChatHistoryModel?>(
                key: ValueKey<String>(widget.chatId),
                future: _historyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoading();
                  }
                  if (snapshot.hasError) {
                    return _buildMessage('خطا در بارگذاری اطلاعات گفتگو');
                  }
                  final data = snapshot.data;
                  if (data == null) {
                    return _buildMessage('اطلاعاتی برای نمایش وجود ندارد');
                  }
                  return ChatHistoryInfoCard(
                    history: data,
                    chatController: widget.chatController,
                    chatId: widget.chatId,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor.buttonColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'در حال بارگذاری...',
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 12,
                color: AppColor.textColor.withAlpha(190),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.secondary50Color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.textColor.withAlpha(30)),
      ),
      child: Text(
        message,
        style: AppTextStyle.bodyText.copyWith(
          fontSize: 12,
          color: AppColor.textColor.withAlpha(200),
        ),
      ),
    );
  }
}


class ChatHistoryInfoCard extends StatefulWidget {
  final ChatHistoryModel history;
  final ChatController chatController;
  final String chatId;

  const ChatHistoryInfoCard({
    super.key,
    required this.history,
    required this.chatController,
    required this.chatId,
  });

  @override
  State<ChatHistoryInfoCard> createState() => _ChatHistoryInfoCardState();
}

class _ChatHistoryInfoCardState extends State<ChatHistoryInfoCard> {
  late ChatHistoryModel _history;
  final Set<int> _revokingAccountIds = {};

  @override
  void initState() {
    super.initState();
    _history = widget.history;
  }


  @override
  Widget build(BuildContext context) {
    final forwards = _sortForwards(_history.forwards);
    final viewers = _history.viewers ?? const <Viewer>[];

    return Container(
      constraints: const BoxConstraints(maxWidth: 460),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.secondary100Color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.textColor.withAlpha(35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: AppTextStyle.bodyText.copyWith(
          fontSize: 12,
          color: AppColor.textColor.withAlpha(220),
          height: 1.4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*Row(
              children: [
                Expanded(
                  child: Text(
                    history.topicTitle ?? 'اطلاعات گفتگو',
                    style: AppTextStyle.bodyText.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),*/
            const SizedBox(height: 10),
            _kvRow(
              icon: Icons.person_outline,
              label: 'مشتری',
              value: _history.customerAccountName,
            ),
            _kvRow(
              icon: Icons.access_time,
              label: 'آخرین فعالیت',
              value: _fmtDate(_history.lastActivity),
            ),
            if (_history.firstPicker?.adminName != null)
              _kvRow(
                icon: Icons.how_to_reg_outlined,
                label: 'اولین پذیرنده',
                value: _history.firstPicker?.adminName,
              ),
            if (_history.closedBy?.adminName != null)
              _kvRow(
                icon: Icons.lock_outline,
                label: 'بسته‌شده توسط',
                value: _history.closedBy?.adminName,
              ),
            if (forwards.isNotEmpty) ...[
              const SizedBox(height: 6),
              _sectionChip(
                forwards.length > 1 ? 'ارجاع (${forwards.length})' : 'ارجاع',
              ),
              const SizedBox(height: 6),
              if (forwards.length == 1) ...[
                _kvRow(
                  icon: Icons.forward_to_inbox_outlined,
                  label: 'از',
                  value: forwards.first.fromAdminName,
                ),
                _kvRow(
                  icon: Icons.forward_to_inbox_outlined,
                  label: 'به',
                  value: forwards.first.toAdminName,
                ),
                _kvRow(
                  icon: Icons.event_outlined,
                  label: 'زمان',
                  value: _fmtDate(forwards.first.on),
                ),
              ] else ...[
                ...forwards.asMap().entries.expand((entry) {
                  final index = entry.key + 1;
                  final f = entry.value;
                  return [
                    _kvRow(
                      icon: Icons.forward_to_inbox_outlined,
                      label: 'ارجاع #$index',
                      value: _fmtForwardSummary(f),
                    ),
                  ];
                }),
              ],
            ],
            if (viewers.isNotEmpty) ...[
              const SizedBox(height: 6),
              _sectionChip(
                viewers.length > 1
                    ? 'دسترسی مشاهده (${viewers.length})'
                    : 'دسترسی مشاهده',
              ),
              const SizedBox(height: 6),
              if (viewers.length == 1) ...[
                _viewerAccessRow(
                  context: context,
                  icon: Icons.remove_red_eye_outlined,
                  label: 'ویو شده توسط',
                  value: viewers.first.grantedByAdminName,
                  viewer: viewers.first,
                ),
              ] else ...[
                ...viewers.asMap().entries.expand((entry) {
                  final index = entry.key + 1;
                  final v = entry.value;
                  return [
                    _viewerAccessRow(
                      context: context,
                      icon: Icons.remove_red_eye_outlined,
                      label: 'بیننده #$index',
                      value: _fmtViewerSummary(v),
                      viewer: v,
                    ),
                  ];
                }),
              ],
            ],
          ],
        ),
      ),
    );
  }

  bool _canRevokeViewer(Viewer v) {
    return canRevokeChatHistoryViewer(
      myAdminAccountId: int.tryParse(widget.chatController.currentUserId),
      history: _history,
      viewer: v,
    );
  }

  Future<void> _revokeViewerAccess(Viewer viewer) async {
    final targetId = viewer.adminAccountId;
    if (targetId == null || _revokingAccountIds.contains(targetId)) return;

    setState(() => _revokingAccountIds.add(targetId));
    final ok = await widget.chatController.revokeChatViewFromAdmin(
      widget.chatId,
      targetId,
    );
    if (!mounted) return;

    setState(() {
      _revokingAccountIds.remove(targetId);
      if (ok) {
        _history = chatHistoryRemovingViewer(_history, targetId);
      }
    });
  }

  Widget _viewerAccessRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String? value,
    required Viewer viewer,
  }) {
    final display =
        (value == null || value.trim().isEmpty) ? '—' : value.trim();
    final targetId = viewer.adminAccountId;
    final canRevoke = _canRevokeViewer(viewer);
    final isRevoking =
        targetId != null && _revokingAccountIds.contains(targetId);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AppColor.textColor.withAlpha(160)),
          const SizedBox(width: 6),
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 11,
                color: AppColor.textColor.withAlpha(170),
              ),
            ),
          ),
          Expanded(
            child: Text(
              display,
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 12,
                color: AppColor.textColor.withAlpha(230),
              ),
            ),
          ),
          if (canRevoke)
            IconButton(
              tooltip: 'لغو دسترسی مشاهده',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              visualDensity: VisualDensity.compact,
              onPressed: isRevoking ? null : () => _revokeViewerAccess(viewer),
              icon: isRevoking
                  ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColor.errorColor.withAlpha(200),
                ),
              )
                  : SvgPicture.asset(
                'assets/svg/revoke-chat.svg',
                width: 26,
                colorFilter: ColorFilter.mode(
                  AppColor.errorColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sectionChip(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.buttonColor.withAlpha(18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.buttonColor.withAlpha(40)),
      ),
      child: Text(
        title,
        style: AppTextStyle.bodyText.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColor.buttonColor,
        ),
      ),
    );
  }

  Widget _kvRow({
    required IconData icon,
    required String label,
    required String? value,
  }) {
    final display =
        (value == null || value.trim().isEmpty) ? '—' : value.trim();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AppColor.textColor.withAlpha(160)),
          const SizedBox(width: 6),
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 11,
                color: AppColor.textColor.withAlpha(170),
              ),
            ),
          ),
          Expanded(
            child: Text(
              display,
              style: AppTextStyle.bodyText.copyWith(
                fontSize: 12,
                color: AppColor.textColor.withAlpha(230),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmtDate(DateTime? dt) {
    return dt?.toPersianDate(
            twoDigits: true, showTime: true, timeSeprator: '-') ??
        '—';
  }

  List<Forward> _sortForwards(List<Forward>? forwards) {
    if (forwards == null || forwards.isEmpty) return const <Forward>[];
    final sorted = forwards.toList()
      ..sort((a, b) {
        final ao = a.on;
        final bo = b.on;
        if (ao == null && bo == null) return 0;
        if (ao == null) return -1;
        if (bo == null) return 1;
        return ao.compareTo(bo);
      });
    return sorted;
  }

  String _fmtForwardSummary(Forward f) {
    final from = (f.fromAdminName == null || f.fromAdminName!.trim().isEmpty)
        ? '—'
        : f.fromAdminName!.trim();
    final to = (f.toAdminName == null || f.toAdminName!.trim().isEmpty)
        ? '—'
        : f.toAdminName!.trim();
    final on = _fmtDate(f.on);
    return ' از $from به $to  |  $on';
  }

  String _fmtViewerSummary(Viewer v) {
    final viewerName = (v.adminName == null || v.adminName!.trim().isEmpty)
        ? '—'
        : v.adminName!.trim();
    final grantedBy =
        (v.grantedByAdminName == null || v.grantedByAdminName!.trim().isEmpty)
            ? '—'
            : v.grantedByAdminName!.trim();
    return '$viewerName  |  ویو توسط: $grantedBy';
  }
}
