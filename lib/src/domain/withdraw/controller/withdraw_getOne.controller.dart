

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/deposit.repository.dart';
import '../../../config/repository/deposit_request.repository.dart';
import '../../../config/repository/remittance.repository.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../config/repository/withdraw.repository.dart';
import '../../../config/repository/withdraw_getOne.repository.dart';
import '../../account/model/account.model.dart';
import '../../deposit/model/deposit.model.dart';
import '../model/withdraw.model.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path/path.dart' as path;

enum PageState{loading,err,empty,list}
class WithdrawGetOneController extends GetxController{

  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollController = ScrollController();

  final WithdrawController withdrawController=Get.find<WithdrawController>();

  final WithdrawRepository withdrawRepository=WithdrawRepository();
  final AccountRepository accountRepository=AccountRepository();
  final WithdrawGetOneRepository withdrawGetOneRepository=WithdrawGetOneRepository();
  final RemittanceRepository remittanceRepository=RemittanceRepository();
  final DepositRequestRepository depositRequestRepository=DepositRequestRepository();
  final DepositRepository depositRepository=DepositRepository();

 var id=0.obs;
  final Rxn<WithdrawModel> getOneWithdraw = Rxn<WithdrawModel>();
  Rx<PageState> state=Rx<PageState>(PageState.list);
  var isLoading=true.obs;
  var isLoadingRegister=true.obs;
  var isLoadingExtraAmount=true.obs;
  var isLoadingSendTelegram=true.obs;
  var errorMessage=''.obs;
  RxList<String> imageList = <String>[].obs;
  final PageController pageController = PageController();
  RxInt currentImagePage = 0.obs;

  final List<AccountModel> filterAccountList=<AccountModel>[].obs;
  var withdrawList=<WithdrawModel>[].obs;

  // Add TabController to maintain tab state
  late TabController tabController;
  RxInt currentTabIndex = 0.obs;
  // Filter variables for deposits
  final TextEditingController amountFilterController = TextEditingController();
  final TextEditingController userNameFilterController = TextEditingController();
  final TextEditingController trackingNumberFilterController = TextEditingController();

  var amountFilter = ''.obs;
  var userNameFilter = ''.obs;
  var trackingNumberFilter = ''.obs;

  // Filtered deposits list
  RxList<DepositModel> filteredDeposits = <DepositModel>[].obs;

  @override
  void onInit() {
    id.value=(int.parse(Get.parameters["id"]!));
    print(id.value);
    fetchGetOneWithdraw(id.value);
    fetchWithdrawList();
    setupScrollListener();
    super.onInit();
  }
  @override void onClose() {
    scrollController.dispose();
    super.onClose();
  }
  // Method to set TabController from the view
  void setTabController(TabController controller) {
    tabController = controller;
  }

  // Method to change tab programmatically
  void changeTab(int index) {
    currentTabIndex.value = index;
    if (tabController.length > index) {
      tabController.animateTo(index);
    }
  }
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
    if (hasMore.value && !isLoading.value) {
      currentPage++;
      await fetchWithdrawList();
    }
  }

  Future<void> fetchGetOneWithdraw(int id)async{
    try {
      state.value=PageState.loading;
      //EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
      var fetchedGetOne = await withdrawGetOneRepository.getOneWithdraw(id);
      if(fetchedGetOne!=null){
        getOneWithdraw.value = fetchedGetOne;
        state.value=PageState.list;
        //EasyLoading.dismiss();
        print('deposits:  ${getOneWithdraw.value?.deposits?.length}');
        // Apply filters when data is loaded
        applyDepositFilters();
      }else{
        state.value=PageState.empty;
      }
      /*if(getOneWithdraw.value==null){
        state.value=PageState.empty;
      }*/
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی به وجود آمده است ${e.toString()}";
    }
  }


  void filterAccountListFunc(int id){
    withdrawController.filterAccountList.assignAll(withdrawController.accountList.where((account) {
      return id!=account.id;
    },).toList());
  }

  //لیست درخواست های برداشت(withdrawRequest)
  Future<void> fetchWithdrawList()async{

    try{

      isLoading.value = true;
      state.value=PageState.loading;
      final startIndex = (currentPage.value - 1) * itemsPerPage.value +1 ;
      final toIndex = currentPage.value * itemsPerPage.value;
      var fetchedWithdrawList=await withdrawRepository.getWithdrawList(
          startIndex: startIndex,
          toIndex: toIndex,
        startDate: '', endDate: '',
      );
      hasMore.value = fetchedWithdrawList.length == itemsPerPage.value;
      if (currentPage.value == 1) {
        withdrawList.assignAll(fetchedWithdrawList);
      } else {
        withdrawList.addAll(fetchedWithdrawList);
      }
      state.value = withdrawList.isEmpty ? PageState.empty : PageState.list;
      if(withdrawList.isEmpty){
        state.value=PageState.empty;
      }
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }

  Future<List<dynamic>?> updateRegistered(int depositId,bool registered) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoadingRegister.value = true;
      // Store current tab index before updating
      int currentTab = currentTabIndex.value;
      var response = await withdrawGetOneRepository.updateRegistered(
        depositId: depositId,
        registered: registered,
      );
      if(response!= null){
        //EasyLoading.dismiss();
        Get.snackbar(response.first['title'],response.first["description"],
            titleText: Text(response.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(response.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        //depositController.fetchDepositList();
        await fetchGetOneWithdraw(id.value);

        // Restore the tab index after data refresh
        Future.delayed(Duration(milliseconds: 100), () {
          changeTab(currentTab);
        });
      }

    } catch (e) {
      EasyLoading.dismiss();
      throw ErrorException('خطا در ریجیستر: $e');
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }

    return null;
  }

  Future<List<dynamic>?> insertFromDeposit(int depositId) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoadingRegister.value = true;
      // Store current tab index before updating
      int currentTab = currentTabIndex.value;
      if (Get.isDialogOpen!) Get.back();
      var response = await withdrawGetOneRepository.insertFromDeposit(
        depositId: depositId,
      );
      if(response!= null){
        EasyLoading.dismiss();
        Get.snackbar("موفقیت آمیز","برگشتی موفقیت آمیز بود",
            titleText: Text("موفقیت آمیز",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text("برگشتی موفقیت آمیز بود",textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        //depositController.fetchDepositList();
        await fetchGetOneWithdraw(id.value);
        withdrawController.getWithdrawListPager();

        // Restore the tab index after data refresh
        Future.delayed(Duration(milliseconds: 100), () {
          changeTab(currentTab);
        });
      }

    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("ناموفق","برگشتی ناموفق بود",
          titleText: Text("ناموفق",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.accentColor),),
          messageText: Text("برگشتی ناموفق بود",textAlign: TextAlign.center,style: TextStyle(color: AppColor.accentColor)));
      throw ErrorException('خطا در برگشت: $e');
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }

    return null;
  }

  Future<List<dynamic>?> changeExteraAmount(int depositId) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoadingExtraAmount.value = true;
      // Store current tab index before updating
      int currentTab = currentTabIndex.value;
      if (Get.isDialogOpen!) Get.back();
      var response = await withdrawGetOneRepository.changeExteraAmount(
        depositId: depositId,
      );
      if(response!= null){
        EasyLoading.dismiss();
        Get.snackbar("موفقیت آمیز","انتقال اضافه واریزی موفقیت آمیز بود",
            titleText: Text("موفقیت آمیز",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text("انتقال اضافه واریزی موفقیت آمیز بود",textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        //depositController.fetchDepositList();
        await fetchGetOneWithdraw(id.value);
        withdrawController.getWithdrawListPager();

        // Restore the tab index after data refresh
        Future.delayed(Duration(milliseconds: 100), () {
          changeTab(currentTab);
        });
      }

    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("ناموفق","انتقال اضافه واریزی ناموفق بود",
          titleText: Text("ناموفق",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.accentColor),),
          messageText: Text("انتقال اضافه واریزی ناموفق بود",textAlign: TextAlign.center,style: TextStyle(color: AppColor.accentColor)));
      throw ErrorException('خطا در برگشت: $e');
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }

    return null;
  }

  Future<List<dynamic>?> sendTelegramDepositRequest(int depositRequestId) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoadingSendTelegram.value = true;
      int currentTab = currentTabIndex.value;
      if (Get.isDialogOpen!) Get.back();
      var response = await depositRequestRepository.sendTelegramDepositRequest(
        depositRequestId: depositRequestId,
      );
      if(response!= null){
        EasyLoading.dismiss();
        Get.snackbar(response.first["title"],response.first["description"],
            titleText: Text(response.first["title"],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(response.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        await fetchGetOneWithdraw(id.value);
        withdrawController.getWithdrawListPager();

        Future.delayed(Duration(milliseconds: 100), () {
          changeTab(currentTab);
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("ناموفق","ارسال به تلگرام ناموفق بود",
          titleText: Text("ناموفق",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.accentColor),),
          messageText: Text("ارسال به تلگرام ناموفق بود",textAlign: TextAlign.center,style: TextStyle(color: AppColor.accentColor)));
      throw ErrorException('خطا در ارسال: $e');
    } finally {
      EasyLoading.dismiss();
      isLoadingSendTelegram.value = false;
    }
    return null;
  }

  Future<List<dynamic>?> sendTelegramDeposit(int depositId) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoadingSendTelegram.value = true;
      int currentTab = currentTabIndex.value;
      if (Get.isDialogOpen!) Get.back();
      var response = await depositRepository.sendTelegramDeposit(
        depositId: depositId,
      );
      if(response!= null){
        EasyLoading.dismiss();
        Get.snackbar(response.first["title"],response.first["description"],
            titleText: Text(response.first["title"],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(response.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        await fetchGetOneWithdraw(id.value);
        withdrawController.getWithdrawListPager();

        Future.delayed(Duration(milliseconds: 100), () {
          changeTab(currentTab);
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("ناموفق","ارسال به تلگرام ناموفق بود",
          titleText: Text("ناموفق",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.accentColor),),
          messageText: Text("ارسال به تلگرام ناموفق بود",textAlign: TextAlign.center,style: TextStyle(color: AppColor.accentColor)));
      throw ErrorException('خطا در ارسال: $e');
    } finally {
      EasyLoading.dismiss();
      isLoadingSendTelegram.value = false;
    }

    return null;
  }

  // لیست عکس ها
  Future<void> getImage(String fileName,String type) async{
    print('تعداد image:');
    imageList.clear();
    try{
      var fetch=await remittanceRepository.getImage(fileName: fileName, type: type);
      imageList.addAll(fetch.guidIds );
      print('تعداد image:${imageList.first}');
      imageList.refresh();
      update();
    }
    catch(e){
      //  state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
    }
  }

  void downloadImage(String guidId) async {
    if (kIsWeb){
      final url = "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$guidId";
      final anchor = html.AnchorElement(href: url)
        ..download = "image_$guidId"
        ..style.display = 'none';

      html.document.body?.children.add(anchor);
      anchor.click();
      anchor.remove();
    }else{
      try {
        final status = await Permission.storage.request();
        if (!status.isGranted) return;

        final dio = Dio();
        final url = "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$guidId";
        final downloadsDir = await getDownloadsDirectory();
        if (downloadsDir == null) {
          throw Exception('Could not access downloads directory');
        }
        String fileExtension = path.extension(guidId);
        if(fileExtension.isEmpty) fileExtension = '.png';
        final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
        final savePath = path.join(downloadsDir.path, fileName);
        /*final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/images_$guidId.png';*/
        await dio.download(url, savePath);
        print(savePath);
        Get.snackbar(
          'موفقیت',
          'تصویر با موفقیت ذخیره شد',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          'خطا',
          'خطا در دانلود تصویر: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  // Filter methods for deposits
  void applyDepositFilters() {
    final deposits = getOneWithdraw.value?.deposits ?? [];

    filteredDeposits.assignAll(deposits.where((deposit) {
      // Filter by amount
      bool amountMatch = true;
      if (amountFilter.value.isNotEmpty) {
        try {
          final filterAmount = int.parse(amountFilter.value.replaceAll(',', ''));
          if (deposit.amount != null) {
            // Convert deposit amount to string for partial matching
            final depositAmountStr = deposit.amount.toString();
            final filterAmountStr = filterAmount.toString();
            // Check if the filter amount is contained in the deposit amount
            amountMatch = depositAmountStr.contains(filterAmountStr);
          } else {
            amountMatch = false;
          }
        } catch (e) {
          amountMatch = false;
        }
      }

      // Filter by user name
      bool userNameMatch = true;
      if (userNameFilter.value.isNotEmpty) {
        final userName = deposit.wallet?.account?.name ?? '';
        userNameMatch = userName.toLowerCase().contains(userNameFilter.value.toLowerCase());
      }

      // Filter by tracking number
      bool trackingNumberMatch = true;
      if (trackingNumberFilter.value.isNotEmpty) {
        final trackingNumber = deposit.trackingNumber ?? '';
        trackingNumberMatch = trackingNumber.toLowerCase().contains(trackingNumberFilter.value.toLowerCase());
      }

      return amountMatch && userNameMatch && trackingNumberMatch;
    }).toList());
  }

  void clearDepositFilters() {
    amountFilterController.clear();
    userNameFilterController.clear();
    trackingNumberFilterController.clear();
    amountFilter.value = '';
    userNameFilter.value = '';
    trackingNumberFilter.value = '';
    applyDepositFilters();
  }

  bool hasActiveDepositFilters() {
    return amountFilter.value.isNotEmpty ||
        userNameFilter.value.isNotEmpty ||
        trackingNumberFilter.value.isNotEmpty;
  }


}