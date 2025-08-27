import 'dart:io';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hanigold_admin/src/domain/users/model/item_user.model.dart';
import 'package:hanigold_admin/src/domain/users/model/list_user.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:async';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../config/const/app_color.dart';
import '../../../config/repository/user.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../account/model/account.model.dart';
import '../../auth/model/user_login.model.dart';
import '../model/balance_item.model.dart';
import '../model/header_info_user_transaction.model.dart';
import '../model/list_transaction_info_item.model.dart';
import '../model/paginated.model.dart';
import '../model/transaction_info_item.model.dart';

enum PageStateUser { loading, err, empty, list }

class PersonListController extends GetxController {
  Rx<PageStateUser> state = Rx<PageStateUser>(PageStateUser.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  DataPagerController dataPagerController = DataPagerController();
  UserInfoTransactionRepository userInfoTransactionRepository =
      UserInfoTransactionRepository();
  UserRepository userRepository = UserRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameFilterController = TextEditingController();
  final TextEditingController nameAccController = TextEditingController();
  final TextEditingController nameUserController = TextEditingController();
  final TextEditingController mobileFilterController = TextEditingController();
  final TextEditingController dateStartController = TextEditingController();
  final TextEditingController dateEndController = TextEditingController();
  final TextEditingController emailUpdateEndController = TextEditingController();
  final TextEditingController userNameUpdateEndController = TextEditingController();
  final TextEditingController mobileUpdateEndController = TextEditingController();
  HeaderInfoUserTransactionModel? headerInfoUserTransactionModel;
  RxList<BalanceItemModel> balanceList = <BalanceItemModel>[].obs;
  RxList<ItemUserModel> userList = <ItemUserModel>[].obs;
  PaginatedModel? paginated;
  BalanceModel? balanceModel;

  String? indexAccountPayerGet;
  var isLoading = false.obs;
  var namePayer = "".obs;
  var mobilePayer = "".obs;
  var sort = true.obs; // or `false`...
  var sortIndex = 0.obs; // or `false`...
  var id = 0.obs; // or `false`...
  var status = 0.obs; // or `false`...
  var startDateFilter = ''.obs;
  var endDateFilter = ''.obs;

  setSort(int index, bool val) {
    sort.value = val;
    sortIndex.value = index;
    update();
  }

  checkStatus(int index) {
    status.value = index;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getUserAccountList();
  }

  void isChangePage(int index) {
    currentPage.value=(index*10-10)+1;
    itemsPerPage.value = index * 10;
    getUserAccountList();
  }

  // لیست کاربران
  Future<void> getUserAccountList() async {
    print("getUserAccountList : 1");
    isOpenMore.value = false;
    userList.clear();
    try {
      state.value = PageStateUser.loading;
      var response = await userRepository.getUserAccountListPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
        nameAccount:nameFilterController.text,
        nameContact: nameAccController.text,
        mobile: mobileFilterController.text,
        username: nameUserController.text,
        status: status.value,
      );
      userList.addAll(response.users ?? []);
      paginated = response.paginated;
      // nameFilterController.text="";
      // mobileFilterController.text="";
      //  print(paginated?.totalCount??0);
      state.value = PageStateUser.list;
      isOpenMore.value = true;

      update();
    } catch (e) {
      state.value = PageStateUser.err;
    } finally {}
  }// لیست کاربران
  Future<void> updateUserAccount(int id) async {
    EasyLoading.show(
      status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    print("updateUserAccount : 1");
    try {
      var response = await userRepository.updateUserAccount(
        mobile: mobileUpdateEndController.text, userName: userNameUpdateEndController.text, id: id, email: emailUpdateEndController.text,
      );
      Get.back();
      getUserAccountList();
      Get.snackbar(response.infos?.first["title"],response.infos?.first["description"],
          titleText: Text(response.infos?.first["title"],
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(response.infos?.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));

      update();
    } catch (e) {
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> updateUserStatusAccount(int id,int status) async {
    EasyLoading.show(
      status: 'لطفا صبر کنید',
      dismissOnTap: false,
    );
    print("updateUserStatusAccount : 1");
    try {
      var response = await userRepository.updateStatusUserAccount(
        id: id, status: '$status',
      );
      getUserAccountList();
      Get.snackbar(response.infos?.first["title"],response.infos?.first["description"],
          titleText: Text(response.infos?.first["title"],
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(response.infos?.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));

      update();
    } catch (e) {
    } finally {
      EasyLoading.dismiss();
    }
  }

  void clearFilter() {
    nameFilterController.clear();
    mobileFilterController.clear();
  }
}
