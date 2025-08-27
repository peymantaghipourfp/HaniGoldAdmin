import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/domain/notification/controller/notification.controller.dart';
import 'package:hanigold_admin/src/domain/notification/model/notification.model.dart';

import 'package:hanigold_admin/src/widget/background_image.widget.dart';
import 'package:hanigold_admin/src/widget/custom_appbar1.widget.dart';
import 'package:hanigold_admin/src/widget/custom_dropdown.widget.dart';
import 'package:hanigold_admin/src/widget/empty.dart';
import 'package:hanigold_admin/src/widget/err_page.dart';
import 'package:path/path.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../../widget/app_drawer.widget.dart';
import '../../../widget/pager_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../home/widget/chat_dialog.widget.dart';
import 'insert_notification.view.dart';

class NotificationView extends StatefulWidget {
  NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final NotificationController notificationController = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      appBar: CustomAppbar1(
        title: 'اعلان‌ها و اطلاعیه‌ها',
        onBackTap: () => Get.offNamed('/home'),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          BackgroundImage(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Filter Section
                      _buildFilterSection(context, isDesktop),

                      _buildDateFilterSection(context, isDesktop),

                      // Tab Bar
                      _buildTabBar(),

                      // Content Section
                      _buildContentSection(context, isDesktop),

                      // Pagination
                      Obx(() =>
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              notificationController.paginated.value != null ? Container(
                                  height: 70,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  color: AppColor.appBarColor.withOpacity(0.5),
                                  alignment: Alignment.bottomCenter,
                                  child: PagerWidget(
                                    countPage: notificationController.paginated.value
                                        ?.totalCount ?? 0, callBack: (int index) {
                                    notificationController.isChangePage(index);
                                  },)) : SizedBox(),
                            ],
                          ),)
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

  Widget _buildFilterSection(BuildContext context, bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (isDesktop) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: AppColor.appBarColor.withOpacity(0.5),
              alignment: Alignment.center,
              height: 70,
              child: Row(
                children: [
                  // Search field
                  Expanded(
                    child: TextFormField(
                      controller: notificationController.searchController,
                      style: AppTextStyle.labelText,
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          await notificationController.searchAccounts(value);
                          _showSearchResults(context);
                        } else {
                          notificationController.clearSearch();
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: AppColor.textFieldColor,
                        hintText: "جستجوی کاربر ... ",
                        hintStyle: AppTextStyle.labelText,
                        prefixIcon: IconButton(
                            onPressed: () async {
                              if (notificationController.searchController.text.isNotEmpty) {
                                await notificationController.searchAccounts(
                                    notificationController.searchController.text
                                );
                                _showSearchResults(context);
                              } else {
                                notificationController.clearSearch();
                              }
                            },
                            icon: Icon(
                              Icons.search,
                              color: AppColor.textColor,
                              size: 30,
                            )
                        ),
                        suffixIcon: IconButton(
                          onPressed: notificationController.clearSearch,
                          icon: Icon(
                              Icons.close,
                              color: AppColor.textColor
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Title filter
                  Expanded(
                    child: TextFormField(
                      controller: notificationController.titleFilterController,
                      style: AppTextStyle.labelText,
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) {
                        notificationController.getNotificationListPager();
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: AppColor.textFieldColor,
                        hintText: "فیلتر عنوان ... ",
                        hintStyle: AppTextStyle.labelText,
                        suffixIcon: IconButton(
                          onPressed: () {
                            notificationController.getNotificationListPager();
                          },
                          icon: Icon(
                            Icons.search,
                            color: AppColor.textColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Content filter
                  Expanded(
                    child: TextFormField(
                      controller: notificationController.contentFilterController,
                      style: AppTextStyle.labelText,
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) {
                        notificationController.getNotificationListPager();
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: AppColor.textFieldColor,
                        hintText: "فیلتر محتوا ... ",
                        hintStyle: AppTextStyle.labelText,
                        suffixIcon: IconButton(
                          onPressed: () {
                            notificationController.getNotificationListPager();
                          },
                          icon: Icon(
                            Icons.search,
                            color: AppColor.textColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      backgroundColor: WidgetStatePropertyAll(AppColor.buttonColor),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    onPressed: notificationController.clearFilter,
                    child: Text(
                      'حذف فیلتر',
                      style: AppTextStyle.labelText,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Column(
              children: [
                // Search field
                TextFormField(
                  controller: notificationController.searchController,
                  style: AppTextStyle.labelText,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      await notificationController.searchAccounts(value);
                      _showSearchResults(context);
                    } else {
                      notificationController.clearSearch();
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: AppColor.textFieldColor,
                    hintText: "جستجوی کاربر ... ",
                    hintStyle: AppTextStyle.labelText,
                    prefixIcon: IconButton(
                        onPressed: () async {
                          if (notificationController.searchController.text.isNotEmpty) {
                            await notificationController.searchAccounts(
                                notificationController.searchController.text
                            );
                            _showSearchResults(context);
                          } else {
                            notificationController.clearSearch();
                          }
                        },
                        icon: Icon(
                          Icons.search,
                          color: AppColor.textColor,
                          size: 30,
                        )
                    ),
                    suffixIcon: IconButton(
                      onPressed: notificationController.clearSearch,
                      icon: Icon(
                          Icons.close,
                          color: AppColor.textColor
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Title and Content filters in a row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: notificationController.titleFilterController,
                        style: AppTextStyle.labelText,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (value) {
                          notificationController.getNotificationListPager();
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: AppColor.textFieldColor,
                          hintText: "فیلتر عنوان ... ",
                          hintStyle: AppTextStyle.labelText,
                          suffixIcon: IconButton(
                            onPressed: () {
                              notificationController.getNotificationListPager();
                            },
                            icon: Icon(
                              Icons.search,
                              color: AppColor.textColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: notificationController.contentFilterController,
                        style: AppTextStyle.labelText,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (value) {
                          notificationController.getNotificationListPager();
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: AppColor.textFieldColor,
                          hintText: "فیلتر محتوا ... ",
                          hintStyle: AppTextStyle.labelText,
                          suffixIcon: IconButton(
                            onPressed: () {
                              notificationController.getNotificationListPager();
                            },
                            icon: Icon(
                              Icons.search,
                              color: AppColor.textColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    backgroundColor: WidgetStatePropertyAll(AppColor.buttonColor),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  onPressed: notificationController.clearFilter,
                  child: Text(
                    'حذف فیلتر',
                    style: AppTextStyle.labelText,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildDateFilterSection(BuildContext context, bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
      LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (isDesktop) {
            return
              Container(
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: AppColor.appBarColor.withOpacity(0.5),
              alignment: Alignment.center,
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: notificationController.dateStartController,
                      style: AppTextStyle.labelText,
                      readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: AppColor.textFieldColor,
                        hintText: "از تاریخ",
                        hintStyle: AppTextStyle.labelText,
                        suffixIcon: Icon(
                          Icons.calendar_month,
                          color: AppColor.textColor,
                        ),
                      ),
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: notificationController.dateEndController,
                      style: AppTextStyle.labelText,
                      readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: AppColor.textFieldColor,
                        hintText: "تا تاریخ",
                        hintStyle: AppTextStyle.labelText,
                        suffixIcon: Icon(
                          Icons.calendar_month,
                          color: AppColor.textColor,
                        ),
                      ),
                      onTap: () => _selectDate(context, false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                        style: ButtonStyle(
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          backgroundColor: WidgetStatePropertyAll(AppColor.buttonColor),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        onPressed: () {
                          notificationController.getNotificationListPager();
                        },
                        child: Text(
                          'اعمال فیلتر تاریخ',
                          style: AppTextStyle.labelText,
                        ),
                      ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: notificationController.clearFilter,
                    icon: Icon(
                        Icons.close,
                        color: AppColor.textColor
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: notificationController.dateStartController,
                        style: AppTextStyle.labelText,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: AppColor.textFieldColor,
                          hintText: "از تاریخ",
                          hintStyle: AppTextStyle.labelText,
                          suffixIcon: Icon(
                            Icons.calendar_month,
                            color: AppColor.textColor,
                          ),
                        ),
                        onTap: () => _selectDate(context, true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: notificationController.dateEndController,
                        style: AppTextStyle.labelText,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: AppColor.textFieldColor,
                          hintText: "تا تاریخ",
                          hintStyle: AppTextStyle.labelText,
                          suffixIcon: Icon(
                            Icons.calendar_month,
                            color: AppColor.textColor,
                          ),
                        ),
                        onTap: () => _selectDate(context, false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    backgroundColor: WidgetStatePropertyAll(AppColor.buttonColor),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  onPressed: () {
                    notificationController.getNotificationListPager();
                  },
                  child: Text(
                    'اعمال فیلتر تاریخ',
                    style: AppTextStyle.labelText,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          decoration: BoxDecoration(
            color: AppColor.appBarColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Obx(() => ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      notificationController.selectedTabIndex.value == 0
                          ? AppColor.buttonColor
                          : Colors.transparent,
                    ),
                    elevation: WidgetStatePropertyAll(0),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () => notificationController.switchTab(0),
                  child: Text(
                    'اعلان‌ها',
                    style: AppTextStyle.labelText.copyWith(
                      color: notificationController.selectedTabIndex.value == 0
                          ? AppColor.textColor
                          : AppColor.textColor.withOpacity(0.7),
                    ),
                  ),
                )),
              ),
              Expanded(
                child: Obx(() => ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      notificationController.selectedTabIndex.value == 1
                          ? AppColor.buttonColor
                          : Colors.transparent,
                    ),
                    elevation: WidgetStatePropertyAll(0),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () => notificationController.switchTab(1),
                  child: Text(
                    'اطلاعیه‌ها',
                    style: AppTextStyle.labelText.copyWith(
                      color: notificationController.selectedTabIndex.value == 1
                          ? AppColor.textColor
                          : AppColor.textColor.withOpacity(0.7),
                    ),
                  ),
                )),
              ),
              Expanded(
                child: Obx(() => ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      notificationController.selectedTabIndex.value == 2
                          ? AppColor.buttonColor
                          : Colors.transparent,
                    ),
                    elevation: WidgetStatePropertyAll(0),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () => notificationController.switchTab(2),
                  child: Text(
                    'هدر ها',
                    style: AppTextStyle.labelText.copyWith(
                      color: notificationController.selectedTabIndex.value == 2
                          ? AppColor.textColor
                          : AppColor.textColor.withOpacity(0.7),
                    ),
                  ),
                )),
              ),
            ],
          ),
        ),
        // Insert buttons for type 1 and 2
        Obx(() => notificationController.selectedTabIndex.value == 1 ||
            notificationController.selectedTabIndex.value == 2
            ? Container(
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed('/insertNotification', parameters: {
                    'notificationType': notificationController.selectedTabIndex.value.toString(),
                  });
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: AppColor.textColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: Text(
                  notificationController.selectedTabIndex.value == 1
                      ? 'افزودن اطلاعیه'
                      : 'افزودن هدر',
                  style: AppTextStyle.labelText,
                ),
              ),
            ],
          ),
        )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context, bool isDesktop) {
    return Obx(() {
      if (notificationController.state.value == PageState.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (notificationController.state.value == PageState.empty) {
        return EmptyPage(
          title: notificationController.selectedTabIndex.value == 0
              ? 'اعلانی وجود ندارد'
              : notificationController.selectedTabIndex.value == 1 ?
              'اطلاعیه‌ای وجود ندارد'
              : 'هدری وجود ندارد',
          callback: () {
            notificationController.getNotificationListPager();
          },
        );
      } else if (notificationController.state.value == PageState.err) {
        return ErrPage(
          callback: () {
            notificationController.clearFilter();
            notificationController.getNotificationListPager();
          },
          title: "خطا در دریافت اطلاعات",
          des: 'برای دریافت اطلاعات مجددا تلاش کنید',
        );
      } else {
        return _buildNotificationList(context, isDesktop);
      }
    });
  }

  Widget _buildNotificationList(BuildContext context, bool isDesktop) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          // DataTable
          Obx(() {
            final currentList = notificationController.selectedTabIndex.value == 0
                ? notificationController.notificationList
            :notificationController.selectedTabIndex.value == 1 ?
                 notificationController.announcementList
                : notificationController.headerList;

            if (currentList.isEmpty) {
              return EmptyPage(
                title: notificationController.selectedTabIndex.value == 0
                    ? 'اعلانی وجود ندارد'
                    :notificationController.selectedTabIndex.value == 1 ?
                'اطلاعیه‌ای وجود ندارد'
                :'هدری وجود ندارد',
                callback: () {
                  notificationController.getNotificationListPager();
                },
              );
            }

            return Container(
              decoration: BoxDecoration(
                color: AppColor.backGroundColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: Row(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          DataTable(
                            sortColumnIndex: notificationController.sortColumnIndex.value,
                            sortAscending: notificationController.sortAscending.value,
                            columns: _buildDataColumns(),
                            rows: _buildDataRows(context, currentList),
                            dataRowMaxHeight: double.infinity,
                            dividerThickness: 0.3,
                            border: TableBorder.symmetric(
                              inside: BorderSide(
                                color: AppColor.textColor,
                                width: 0.3,
                              ),
                              outside: BorderSide(
                                color: AppColor.textColor,
                                width: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            headingRowHeight: 60,
                            columnSpacing: 90,
                            horizontalMargin: 20,
                          ),
                          // Loading indicator for pagination
                          if (notificationController.hasMore.value)
                            Obx(() => notificationController.isLoading.value
                                ? const Center(child: CircularProgressIndicator())
                                : const SizedBox.shrink()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

        ],
      ),
    );
  }

  List<DataColumn> _buildDataColumns() {
    return [
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text('ردیف', style: AppTextStyle.labelText),
        ),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text('تاریخ', style: AppTextStyle.labelText),
        ),
        headingRowAlignment: MainAxisAlignment.center,
        /*onSort: (columnIndex, ascending) {
          notificationController.onSort(columnIndex, ascending);
        },*/
      ),
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text('کاربر', style: AppTextStyle.labelText),
        ),
        headingRowAlignment: MainAxisAlignment.center,

      ),
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text('عنوان', style: AppTextStyle.labelText),
        ),
        headingRowAlignment: MainAxisAlignment.center,
        /*onSort: (columnIndex, ascending) {
          notificationController.onSort(columnIndex, ascending);
        },*/
      ),
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text('موضوع', style: AppTextStyle.labelText),
        ),
        headingRowAlignment: MainAxisAlignment.center,
        /*onSort: (columnIndex, ascending) {
          notificationController.onSort(columnIndex, ascending);
        },*/
      ),
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text('محتوا', style: AppTextStyle.labelText),
        ),
        headingRowAlignment: MainAxisAlignment.center,
        /*onSort: (columnIndex, ascending) {
          notificationController.onSort(columnIndex, ascending);
        },*/
      ),
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text('مشاهده', style: AppTextStyle.labelText),
        ),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text('وضعیت', style: AppTextStyle.labelText),
        ),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
          label: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('تغییر وضعیت',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
              Text('غیر فعال / فعال',
                  style: AppTextStyle.labelText.copyWith(fontSize: 11)),
            ],
          ),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text('عملیات', style: AppTextStyle.labelText),
        ),
        headingRowAlignment: MainAxisAlignment.center,
      ),
    ];
  }

  List<DataRow> _buildDataRows(BuildContext context, List<NotificationModel> currentList) {
    return currentList.map((notification) {
      return DataRow(
        cells: [
          // ردیف
          DataCell(
            Center(
              child: Text("${notification.rowNum}",
                style:
                AppTextStyle.bodyText,
              ),
            ),
          ),
          // تاریخ
          DataCell(
            Center(
              child: Text(
                notification.date?.toPersianDate() ?? 'تاریخ نامشخص',
                style: AppTextStyle.bodyText.copyWith(fontSize: 11),
              ),
            ),
          ),
          // کاربر
          notification.type==0 ?
          DataCell(
            Center(
              child: Text(
                notification.account?.name ?? 'سیستم',
                style: AppTextStyle.bodyText.copyWith(fontSize: 11),
              ),
            ),
          ) :
              DataCell(SizedBox.shrink()),
          // عنوان
          DataCell(
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Text(
                  notification.title ?? '',
                  style: AppTextStyle.bodyText.copyWith(fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          // موضوع
          DataCell(
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Text(
                  notification.topic ?? '',
                  style: AppTextStyle.bodyText.copyWith(fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          // محتوا
          DataCell(
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(
                  notification.notifContent ?? '',
                  style: AppTextStyle.bodyText.copyWith(fontSize: 11),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          // مشاهده
          notification.type==0 ?
          DataCell(
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: notification.isViewed == true
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  notification.isViewed == true ? 'مشاهده شده' : 'مشاهده نشده',
                  style: AppTextStyle.bodyText.copyWith(
                    fontSize: 10,
                    color: notification.isViewed == true ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ),
          ) :
              DataCell(SizedBox.shrink()),
          // وضعیت
          DataCell(
            Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius
                      .circular(
                      5),
                ),
                color: notification.status == 1
                    ? AppColor.primaryColor
                    : AppColor.accentColor,
                margin: EdgeInsets
                    .symmetric(
                    vertical: 0,
                    horizontal: 5),
                child: Padding(
                  padding: const EdgeInsets
                      .all(6),
                  child: Text(
                      notification
                          .status ==
                          1
                          ? 'فعال'
                          : 'غیر فعال',
                      style: AppTextStyle
                          .labelText,
                      textAlign: TextAlign
                          .center),
                ),
              ),
            ),
          ),
          // تغییر وضعیت
          DataCell(
              Center(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: (){
                          notificationController.updateStatusNotification(2,notification.id ?? 0);
                        },
                        child: Tooltip(message: "غیر فعال",
                          child: SvgPicture.asset('assets/svg/close-circle1.svg',
                              colorFilter: ColorFilter.mode(
                                AppColor.accentColor,
                                BlendMode.srcIn,
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: (){
                          notificationController.updateStatusNotification(1,notification.id ?? 0);
                        },
                        child: Tooltip(message: "فعال",
                          child: SvgPicture.asset('assets/svg/check-mark-circle.svg',
                              colorFilter: ColorFilter.mode(
                                AppColor.primaryColor,
                                BlendMode.srcIn,
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ))
          ),
          // عملیات
          DataCell(
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Edit icon - only for type 1 and 2
                  if (notification.type == 1 || notification.type == 2)
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: AppColor.primaryColor,
                        size: 20,
                      ),
                      onPressed: () => _showEditDialog(notification),
                      tooltip: 'ویرایش',
                    ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () => _showDeleteDialog(notification),
                    tooltip: 'حذف',
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    Jalali? pickedDate = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1400, 1, 1),
      lastDate: Jalali(1450, 12, 29),
      initialEntryMode: PersianDatePickerEntryMode.calendar,
      initialDatePickerMode: PersianDatePickerMode.day,
      locale: const Locale("fa", "IR"),
    );

    if (pickedDate != null) {
      Gregorian gregorian = pickedDate.toGregorian();
      String gregorianDate = "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
      String persianDate = "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

      if (isStartDate) {
        notificationController.startDateFilter.value = gregorianDate;
        notificationController.dateStartController.text = persianDate;
      } else {
        notificationController.endDateFilter.value = gregorianDate;
        notificationController.dateEndController.text = persianDate;
      }

      //notificationController.getNotificationListPager();
    }
  }

  void _showDeleteDialog(NotificationModel notification) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColor.backGroundColor,
        title: Text(
          'حذف ${notificationController.getNotificationTypeText(notification.type)}',
          style: AppTextStyle.labelText,
          textAlign: TextAlign.center,
        ),
        content: Text(
          'آیا از حذف این ${notificationController.getNotificationTypeText(notification.type)} اطمینان دارید؟',
          style: AppTextStyle.labelText,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'انصراف',
              style: AppTextStyle.labelText.copyWith(color: AppColor.textColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              notificationController.deleteNotification(notification.id!);
            },
            child: Text(
              'حذف',
              style: AppTextStyle.labelText.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(NotificationModel notification) {
    final TextEditingController titleController = TextEditingController(text: notification.title ?? '');
    final TextEditingController contentController = TextEditingController(text: notification.notifContent ?? '');
    final TextEditingController topicController = TextEditingController(text: notification.topic ?? '');
    String initialDate = notification.date?.toPersianDate(showTime: true,digitType: NumStrLanguage.English) ?? '';
    final TextEditingController dateController = TextEditingController(text: initialDate);
    int selectedStatus = notification.status ?? 1;

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColor.backGroundColor,
        title: Text(
          'ویرایش ${notificationController.getNotificationTypeText(notification.type)}',
          style: AppTextStyle.labelText,
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: Get.width * 0.4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // تاریخ
              Container(
                //height: 50,
                padding: EdgeInsets.only(
                    bottom: 5),
                child: IntrinsicHeight(
                  child:
                  TextFormField(
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return 'لطفا تاریخ را انتخاب کنید';
                      }
                      return null;
                    },
                    controller: dateController,
                    readOnly: true,
                    style: AppTextStyle
                        .labelText,
                    decoration: InputDecoration(
                      labelText: 'تاریخ',
                      labelStyle: AppTextStyle.labelText,
                      suffixIcon: Icon(Icons
                          .calendar_month,
                          color: AppColor
                              .textColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius
                            .circular(10),
                      ),
                      filled: true,
                      fillColor: AppColor
                          .textFieldColor,
                      errorMaxLines: 1,
                    ),
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
                        dateController
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
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Title field
              TextFormField(
                controller: titleController,
                style: AppTextStyle.labelText,
                decoration: InputDecoration(
                  labelText: 'عنوان',
                  labelStyle: AppTextStyle.labelText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: AppColor.textFieldColor,
                ),
              ),
              const SizedBox(height: 16),
              // topic
              TextFormField(
                controller: topicController,
                style: AppTextStyle.labelText,
                decoration: InputDecoration(
                  labelText: 'موضوع',
                  labelStyle: AppTextStyle.labelText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: AppColor.textFieldColor,
                ),
              ),
              const SizedBox(height: 16),
              // Content field
              TextFormField(
                controller: contentController,
                style: AppTextStyle.labelText,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'محتوا',
                  labelStyle: AppTextStyle.labelText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: AppColor.textFieldColor,
                ),
              ),
              const SizedBox(height: 16),
              // Status dropdown
              Column(
                children: [
                  DropdownButtonFormField2<int>(
                    value: selectedStatus,
                    style: AppTextStyle.labelText,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'وضعیت',
                      labelStyle: AppTextStyle.labelText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: AppColor.textFieldColor,

                    ),
                    dropdownStyleData: DropdownStyleData(
                      offset: const Offset(0, 0),
                      maxHeight: 200,
                      decoration: BoxDecoration(
                        color: AppColor.backGroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    /*buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      height: 48,
                    ),*/
                    items: [
                      DropdownMenuItem(
                        value: 1,
                        child: Text('فعال', style: AppTextStyle.bodyText),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text('غیر فعال', style: AppTextStyle.bodyText),
                      ),
                    ],
                    onChanged: (value) {
                      selectedStatus = value!;
                    },
                    alignment: AlignmentDirectional.bottomStart,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'انصراف',
              style: AppTextStyle.bodyText.copyWith(color: AppColor.textColor),
            ),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty) {
                Get.snackbar(
                  'خطا',
                  'عنوان نمی‌تواند خالی باشد',
                  backgroundColor: Colors.red.withOpacity(0.1),
                  colorText: Colors.red,
                );
                return;
              }
              if (contentController.text.trim().isEmpty) {
                Get.snackbar(
                  'خطا',
                  'محتوا نمی‌تواند خالی باشد',
                  backgroundColor: Colors.red.withOpacity(0.1),
                  colorText: Colors.red,
                );
                return;
              }
              Get.back();
              String date = convertJalaliToGregorian(dateController.text);
              notificationController.updateNotification(
                date: date,
                //date: "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}",
                topic: topicController.text.trim(),
                title: titleController.text.trim(),
                notifContent: contentController.text.trim(),
                status: selectedStatus,
                type: notification.type ?? 1,
                id: notification.id!,
              );
            },
            child: Text(
              'ذخیره',
              style: AppTextStyle.bodyText.copyWith(color: AppColor.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchResults(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColor.backGroundColor,
        title: Text(
          'نتایج جستجو',
          style: AppTextStyle.labelText,
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: isDesktop ? Get.width * 0.4 : Get.width * 0.8,
          height: isDesktop ? Get.height * 0.6 : Get.height * 0.7,
          child: Obx(() {
            if (notificationController.searchedAccounts.isEmpty) {
              return Center(
                child: Text(
                  'نتیجه‌ای یافت نشد',
                  style: AppTextStyle.labelText,
                ),
              );
            }

            return ListView.builder(
              itemCount: notificationController.searchedAccounts.length,
              itemBuilder: (context, index) {
                final account = notificationController.searchedAccounts[index];
                return ListTile(
                  title: Text(
                    account.name ?? '',
                    style: AppTextStyle.labelText,
                  ),

                  onTap: () => notificationController.selectAccount(account),
                );
              },
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'انصراف',
              style: AppTextStyle.labelText.copyWith(color: AppColor.textColor),
            ),
          ),
        ],
      ),
    );
  }
}
