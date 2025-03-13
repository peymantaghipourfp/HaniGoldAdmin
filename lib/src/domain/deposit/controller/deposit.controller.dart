

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/deposit.repository.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit.model.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';

enum PageState{loading,err,empty,list}
class DepositController extends GetxController{
  final DepositRepository depositRepository=DepositRepository();
  var depositList=<DepositModel>[].obs;
  var errorMessage=''.obs;
  var isLoading=true.obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);


  @override
  void onInit() {
    fetchDepositList();
    super.onInit();
  }

  Future<void> fetchDepositList() async{
    try{
      state.value=PageState.loading;
      var fetchedDepositList=await depositRepository.getDepositList();
      depositList.assignAll(fetchedDepositList);
      state.value=PageState.list;

      if(depositList.isEmpty){
        state.value=PageState.empty;
      }
    }catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }

  Future<DepositModel?> updateStatusDeposit(int depositId,int status) async {

    try {
      isLoading.value = true;
      var response = await depositRepository.updateStatusDeposit(
        status: status,
        depositId: depositId,
      );
      if(response!= null){
        Get.snackbar("موفقیت آمیز","وضعیت واریزی با موفقیت تغییر کرد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('وضعیت واریزی با موفقیت تغییر کرد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        fetchDepositList();
      }

    } catch (e) {
      throw ErrorException('خطا در تغییر وضعیت: $e');
    } finally {
      isLoading.value = false;
    }
    return null;
  }
}