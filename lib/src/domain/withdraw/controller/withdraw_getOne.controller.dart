

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/repository/account.repository.dart';
import '../../../config/repository/url/base_url.dart';
import '../../../config/repository/withdraw.repository.dart';
import '../../../config/repository/withdraw_getOne.repository.dart';
import '../../account/model/account.model.dart';
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

 var id=0.obs;
  final Rxn<WithdrawModel> getOneWithdraw = Rxn<WithdrawModel>();
  Rx<PageState> state=Rx<PageState>(PageState.list);
  var isLoading=true.obs;
  var errorMessage=''.obs;

  final List<AccountModel> filterAccountList=<AccountModel>[].obs;
  var withdrawList=<WithdrawModel>[].obs;

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
      var fetchedGetOne = await withdrawGetOneRepository.getOneWithdraw(id);
      if(fetchedGetOne!=null){
        getOneWithdraw.value = fetchedGetOne;
        state.value=PageState.list;
        print('deposits:  ${getOneWithdraw.value?.deposits?.length}');
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
          toIndex: toIndex
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

}