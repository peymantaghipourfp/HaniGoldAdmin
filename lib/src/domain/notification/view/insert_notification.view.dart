import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/background_image.widget.dart';
import '../../home/widget/chat_dialog.widget.dart';
import '../controller/notification.controller.dart';

class InsertNotificationView extends StatefulWidget {
  final int notificationType;

  const InsertNotificationView({
    super.key,
    required this.notificationType,
  });
  // Factory constructor to handle route parameters
  factory InsertNotificationView.fromRoute() {
    final notificationType = int.tryParse(Get.parameters['notificationType'] ?? '1') ?? 1;
    return InsertNotificationView(notificationType: notificationType);
  }

  @override
  State<InsertNotificationView> createState() => _InsertNotificationViewState();
}

class _InsertNotificationViewState extends State<InsertNotificationView> {
  final NotificationController controller = Get.find<NotificationController>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  int _selectedStatus = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    var now = Jalali.now();
    DateTime date=DateTime.now();
    _dateController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    // Validate notification type
    if (widget.notificationType != 1 && widget.notificationType != 2) {
      // If invalid notification type, redirect back
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.back();
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _topicController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String gregorianDate = convertJalaliToGregorian(_dateController.text);
      controller.insertNotification(
        date: gregorianDate,
        topic: _topicController.text,
        title: _titleController.text,
        notifContent: _contentController.text,
        status: _selectedStatus,
        type: _safeNotificationType,
      );
    }
  }
  int get _safeNotificationType {
    return widget.notificationType == 1 || widget.notificationType == 2
        ? widget.notificationType
        : 1;
  }

  String _getPageTitle() {
    return _safeNotificationType == 1 ? 'افزودن اطلاعیه' : 'افزودن هدر';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      appBar:CustomAppbar1(
          title: widget.notificationType == 1 ? 'افزودن اطلاعیه' : 'افزودن هدر', onBackTap: () {
        Get.back();
         }),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          BackgroundImage(),
          Center(
            child: Container(
              width: Get.width*0.7,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Card
                      /*Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColor.secondaryColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.dividerColor.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _safeNotificationType == 1
                                  ? Icons.announcement
                                  : Icons.view_headline,
                              size: 48,
                              color: AppColor.primaryColor,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _getPageTitle(),
                              style: AppTextStyle.largeTitleText,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _safeNotificationType == 1
                                  ? 'اطلاعیه جدید را وارد کنید'
                                  : 'هدر جدید را وارد کنید',
                              style: AppTextStyle.bodyText,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),*/

                      //const SizedBox(height: 24),

                      // Date Field
                      _buildFormField(
                        controller: _dateController,
                        label: 'تاریخ',
                        hint: 'تاریخ را انتخاب کنید',
                        icon: Icons.calendar_today,
                        readOnly: true,
                        onTap: () async {
                          Jalali? pickedDate = await showPersianDatePicker(
                            context: Get.context!,
                            initialDate: Jalali
                                .now(),
                            firstDate: Jalali(
                                1400, 1, 1),
                            lastDate: Jalali(
                                1450, 12, 29),
                            initialEntryMode: PersianDatePickerEntryMode
                                .calendar,
                            initialDatePickerMode: PersianDatePickerMode
                                .day,
                            locale: Locale(
                                "fa", "IR"),
                          );
                          DateTime date = DateTime
                              .now();

                          if (pickedDate !=
                              null) {
                            _dateController
                                .text =
                            "${pickedDate
                                .year}/${pickedDate
                                .month.toString()
                                .padLeft(2,
                                '0')}/${pickedDate
                                .day.toString()
                                .padLeft(
                                2, '0')} ${date
                                .hour.toString()
                                .padLeft(
                                2, '0')}:${date
                                .minute.toString()
                                .padLeft(
                                2, '0')}:${date
                                .second.toString()
                                .padLeft(
                                2, '0')}";
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا تاریخ را انتخاب کنید';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Topic Field
                      _buildFormField(
                        controller: _topicController,
                        label: 'موضوع',
                        hint: 'موضوع را وارد کنید',
                        icon: Icons.subject,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا موضوع را وارد کنید';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Title Field
                      _buildFormField(
                        controller: _titleController,
                        label: 'عنوان',
                        hint: 'عنوان را وارد کنید',
                        icon: Icons.title,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا عنوان را وارد کنید';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Content Field
                      _buildFormField(
                        controller: _contentController,
                        label: 'محتوای ${_safeNotificationType == 1 ? 'اطلاعیه' : 'هدر'}',
                        hint: 'محتوای ${_safeNotificationType == 1 ? 'اطلاعیه' : 'هدر'} را وارد کنید',
                        icon: Icons.description,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا محتوا را وارد کنید';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Status Selection
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColor.secondaryColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.dividerColor.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.toggle_on,
                                  color: AppColor.primaryColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'وضعیت',
                                  style: AppTextStyle.mediumTitleText,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatusOption(
                                    value: 1,
                                    title: 'فعال',
                                    icon: Icons.check_circle,
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatusOption(
                                    value: 2,
                                    title: 'غیرفعال',
                                    icon: Icons.cancel,
                                    color: AppColor.accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Submit Button
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          foregroundColor: AppColor.textColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.save, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'ذخیره ${_safeNotificationType == 1 ? 'اطلاعیه' : 'هدر'}',
                              style: AppTextStyle.mediumBodyTextBold,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Cancel Button
                      OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColor.textColor,
                          side: const BorderSide(color: AppColor.dividerColor),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cancel, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'انصراف',
                              style: AppTextStyle.madiumbodyText,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(const ChatDialog());
        },
        backgroundColor: AppColor.primaryColor,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.dividerColor.withOpacity(0.3)),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        style: AppTextStyle.madiumbodyText,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColor.primaryColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          labelStyle: AppTextStyle.bodyText.copyWith(
            color: AppColor.textColor.withOpacity(0.7),
          ),
          hintStyle: AppTextStyle.bodyText.copyWith(
            color: AppColor.textColor.withOpacity(0.5),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildStatusOption({
    required int value,
    required String title,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedStatus == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : AppColor.dividerColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColor.iconViewColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyle.bodyText.copyWith(
                color: isSelected ? color : AppColor.textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
