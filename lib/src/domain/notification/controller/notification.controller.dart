import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/notification.repository.dart';
import 'package:hanigold_admin/src/domain/notification/model/notification.model.dart';
import 'package:hanigold_admin/src/domain/notification/model/list_notification.model.dart';
import 'package:hanigold_admin/src/domain/users/model/paginated.model.dart';
import 'package:hanigold_admin/src/config/const/socket.service.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';

import '../../../config/const/app_color.dart';
import '../../../config/repository/account.repository.dart';
import '../../account/model/account.model.dart';
import '../../account/model/account_search_req.model.dart';
import '../../withdraw/model/filter.model.dart';
import '../../withdraw/model/options.model.dart';
import '../../withdraw/model/predicate.model.dart';

enum PageState { loading, err, empty, list }

class NotificationController extends GetxController {
  // Repository
  final NotificationRepository notificationRepository = NotificationRepository();
  final AccountRepository accountRepository = AccountRepository();

  // Socket service
  /*SocketService socketService = Get.find<SocketService>();
  StreamSubscription? socketSubscription;*/

  // Sorting
  RxnInt sortColumnIndex = RxnInt();
  RxBool sortAscending = true.obs;
  // Tab management
  RxInt selectedTabIndex = 0.obs; // 0 for notifications, 1 for announcements

  // Pagination
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollController = ScrollController();

  // State management
  Rx<PageState> state = Rx<PageState>(PageState.loading);
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  // Data lists
  var notificationList = <NotificationModel>[].obs; // type = 0
  var announcementList = <NotificationModel>[].obs; // type = 1
  var headerList = <NotificationModel>[].obs; // type = 2

  // Pagination data
  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();

  // Filter controllers
  final TextEditingController dateStartController = TextEditingController();
  final TextEditingController dateEndController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController titleFilterController = TextEditingController();
  final TextEditingController contentFilterController = TextEditingController();
  var startDateFilter = ''.obs;
  var endDateFilter = ''.obs;

  RxInt selectedAccountId = 0.obs;
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;
  AccountSearchReqModel? accountSearchReqModel;

  @override
  void onInit() {
    super.onInit();
    //socketSubscription?.cancel();
    //_listenToSocket();
    getNotificationListPager();
    setupScrollListener();
  }

  @override
  void onClose() {
    //socketSubscription?.cancel();
    scrollController.dispose();
    super.onClose();
  }

  /*void _listenToSocket() {
    socketSubscription?.cancel();
    socketSubscription = socketService.messageStream.listen((message) {
      if (message is String) {
        try {
          final data = json.decode(message);
          if (data['channel'] == 'notification') {
            getNotificationListPager();
          }
        } catch (e) {
          Get.log('Error processing socket message in NotificationController: $e');
        }
      }
    }, onError: (error) {
      Get.log('Socket stream error in NotificationController: $error');
    });
  }*/

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200 &&
          hasMore.value &&
          !isLoading.value) {
        loadMore();
      }
    });
  }

  Future<void> loadMore() async {
    if (!scrollController.hasClients || hasMore.value && !isLoading.value) {
      isLoading.value = true;
      final nextPage = currentPage.value + 1;
      try {
        final startIndex = (nextPage - 1) * itemsPerPage.value + 1;
        final toIndex = nextPage * itemsPerPage.value;

        var fetchedNotificationList = await notificationRepository.getNotificationListPager(
          startIndex: startIndex,
          toIndex: toIndex,
          type: selectedTabIndex.value,
          accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
          startDate: startDateFilter.value,
          endDate: endDateFilter.value,
          title: titleFilterController.text,
          content: contentFilterController.text,
        );

        if (fetchedNotificationList.notifications != null && fetchedNotificationList.notifications!.isNotEmpty) {
          // Since we're filtering by type at API level, add directly to current list
          if (selectedTabIndex.value == 0) {
            notificationList.assignAll(fetchedNotificationList.notifications!);
          } else if(selectedTabIndex.value == 1) {
            announcementList.assignAll(fetchedNotificationList.notifications!);
          }else{
            headerList.assignAll(fetchedNotificationList.notifications!);
          }

          currentPage.value = nextPage;
          hasMore.value = fetchedNotificationList.notifications!.length == itemsPerPage.value;
        } else {
          hasMore.value = false;
        }
      } catch (e) {
        hasMore.value = false;
        errorMessage.value = "خطا در دریافت اطلاعات بیشتر: ${e.toString()}";
      } finally {
        isLoading.value = false;
      }
    }
  }

  void setError(String message) {
    state.value = PageState.err;
    errorMessage.value = message;
  }

  // Get current list based on selected tab
  RxList<NotificationModel> get currentList {
    return selectedTabIndex.value == 0 ? notificationList : selectedTabIndex.value == 1 ? announcementList : headerList ;
  }

  // Switch between tabs
  void switchTab(int index) {
    selectedTabIndex.value = index;
    currentPage.value = 1;
    hasMore.value = true;
    // Clear the current list before loading new data
    if (index == 0) {
      notificationList.clear();
    } else if(index == 1) {
      announcementList.clear();
    }else{
      headerList.clear();
    }
    getNotificationListPager();
  }

  void isChangePage(int index){
    currentPage.value=(index*10-10)+1;
    itemsPerPage.value=index*10;
    getNotificationListPager();
    update();
  }

  // Get notification list with pagination
  Future<void> getNotificationListPager() async {
    print("### getNotificationListPager ###");
    isLoading.value = true;
    try {
      state.value = PageState.loading;

      var response = await notificationRepository.getNotificationListPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        type: selectedTabIndex.value,
        accountId: selectedAccountId.value == 0 ? null : selectedAccountId.value,
        startDate: startDateFilter.value,
        endDate: endDateFilter.value,
        title: titleFilterController.text,
        content: contentFilterController.text,
      );

      isLoading.value = false;

      if (response.notifications != null) {
        if (selectedTabIndex.value == 0) {
          notificationList.assignAll(response.notifications!);
        } else if(selectedTabIndex.value == 1) {
          announcementList.assignAll(response.notifications!);
        }else{
          headerList.assignAll(response.notifications!);
        }

        paginated.value = response.paginated;
        state.value = PageState.list;
      } else {
        state.value = PageState.empty;
      }

      update();
    } catch (e) {
      state.value = PageState.err;
      errorMessage.value = "خطا در دریافت اطلاعات: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  // Account search methods
  searchAccountName(String name) {
    accountSearchReqModel = AccountSearchReqModel(
        account: OptionsModel(
            predicate: [PredicateModel(
                innerCondition: 0,
                outerCondition: 0,
                filters: [FilterModel(
                    fieldName: 'Name',
                    filterValue: name,
                    filterType: 0,
                    refTable: "Account"
                )]
            )],
            orderBy: "Account.Name",
            orderByType: "asc",
            startIndex: 1,
            toIndex: 1000
        )
    );
  }

  Future<void> searchAccounts(String name) async {
    try {
      if (name.isEmpty) {
        searchedAccounts.clear();
        return;
      }

      final accounts = await accountRepository.searchAccountList(name, "");
      searchedAccounts.assignAll(accounts);
    } catch (e) {
      setError("خطا در جستجوی کاربران: ${e.toString()}");
    }
  }

  void selectAccount(AccountModel account) {
    currentPage.value = 1;
    selectedAccountId.value = account.id!;
    searchController.text = account.name!;
    Get.back(); // Close search dialog
    getNotificationListPager();
  }

  void clearSearch() {
    paginated.value=null;
    currentPage.value = 1;
    itemsPerPage.value=10;
    selectedAccountId.value = 0;
    searchController.clear();
    searchedAccounts.clear();
    getNotificationListPager();
  }

  // Clear filters
  void clearFilter() {
    dateStartController.clear();
    dateEndController.clear();
    searchController.clear();
    titleFilterController.clear();
    contentFilterController.clear();
    startDateFilter.value = "";
    endDateFilter.value = "";
    selectedAccountId.value = 0;
    searchedAccounts.clear();
    paginated.value=null;
    currentPage.value = 1;
    itemsPerPage.value=10;
    // Clear both lists to ensure clean state
    notificationList.clear();
    announcementList.clear();
    headerList.clear();
    getNotificationListPager();
  }

  // Get notification type text
  String getNotificationTypeText(int? type) {
    switch (type) {
      case 0:
        return 'اعلان';
      case 1:
        return 'اطلاعیه';
      case 2:
        return 'هدر';
      default:
        return 'نامشخص';
    }
  }

  // Get status text
  String getStatusText(int? status) {
    switch (status) {
      case 0:
        return 'فعال';
      case 1:
        return 'غیرفعال';
      default:
        return 'نامشخص';
    }
  }

  // Delete notification
  Future<void> deleteNotification(int notificationId) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await notificationRepository.deleteNotification(notificationId: notificationId);
      if(response.isNotEmpty){
        final info = response.first;
        Get.snackbar(info['title'],info['description'],
            titleText: Text(info['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(info['description'],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        getNotificationListPager();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا در حذف : $e');
    }finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
    return null;
  }

  Future<void> updateStatusNotification(int status,int id) async {
    EasyLoading.show(status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try {
      var response = await notificationRepository.updateStatusNotification(
        status: status,
        id: id,
      );
      Get.snackbar(response.infos?.first["title"],response.infos?.first["description"],
          titleText: Text(response.infos?.first["title"],
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(response.infos?.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));

      getNotificationListPager();
    } catch (e) {
      EasyLoading.dismiss();
      setError("خطا در بروزرسانی وضعیت: ${e.toString()}");
    }finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> updateNotification({
    required String date,
    required String topic,
    required String title,
    required String notifContent,
    required int status,
    required int type,
    required int id,
  }) async {
    EasyLoading.show(status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try {
      var response = await notificationRepository.updateNotification(
        date:date,
        topic: topic,
        title: title,
        notifContent: notifContent,
        status: status,
        type: type,
        id: id,
      );
      Get.snackbar(response.infos?.first["title"], response.infos?.first["description"],
          titleText: Text(response.infos?.first["title"],
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(response.infos?.first["description"], textAlign: TextAlign.center, style: TextStyle(color: AppColor.textColor)));

      getNotificationListPager();
    } catch (e) {
      EasyLoading.dismiss();
      setError("خطا در بروزرسانی: ${e.toString()}");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> insertNotification({
    required String date,
    required String topic,
    required String title,
    required String notifContent,
    required int status,
    required int type,
  }) async {
    EasyLoading.show(status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    try {
      var response = await notificationRepository.insertNotification(
        date: date,
        topic: topic,
        title: title,
        notifContent: notifContent,
        status: status,
        type: type,
      );

      if (response['infos'] != null && response['infos'].isNotEmpty) {
        final info = response['infos'].first;
        Get.toNamed('/notificationList');
        Get.snackbar(
            info['title'],
            info['description'],
            titleText: Text(
              info['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),
            ),
            messageText: Text(
                info['description'],
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor)
            )
        );
        Get.back();
        getNotificationListPager();
      }
    } catch (e) {
      EasyLoading.dismiss();
      setError("خطا در درج : ${e.toString()}");
    } finally {
      EasyLoading.dismiss();
    }
  }
}
