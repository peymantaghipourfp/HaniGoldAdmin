

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';

import '../../../config/repository/account.repository.dart';
import '../../../config/repository/withdraw.repository.dart';
import '../../../config/repository/withdraw_getOne.repository.dart';
import '../../account/model/account.model.dart';
import '../model/withdraw.model.dart';

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
    id.value=(Get.arguments ?? 0) as int;
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

}