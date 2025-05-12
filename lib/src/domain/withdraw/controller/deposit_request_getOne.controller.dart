

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/deposit_request_getOne.repository.dart';
import 'package:hanigold_admin/src/domain/deposit/controller/deposit.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/deposit_request.model.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/deposit.repository.dart';

enum PageState{loading,err,empty,list}
class DepositRequestGetOneController extends GetxController{

  final DepositController depositController=Get.find<DepositController>();

  final DepositRequestGetOneRepository depositRequestGetOneRepository=DepositRequestGetOneRepository();
  final DepositRepository depositRepository=DepositRepository();

  var id=0.obs;
  final Rxn<DepositRequestModel> getOneDepositRequest = Rxn<DepositRequestModel>();
  Rx<PageState> state=Rx<PageState>(PageState.list);
  var isLoading=true.obs;
  var errorMessage=''.obs;

  @override
  void onInit() {
    id.value=(int.parse(Get.parameters["id"]!));
    print("depositIdddd:${id.value}");
    fetchGetOneDepositRequest(id.value);
    super.onInit();
  }
  Future<void> fetchGetOneDepositRequest(int id)async{
    try {
      state.value=PageState.loading;
      var fetchedGetOneDepositRequest = await depositRequestGetOneRepository.getOneDepositRequest(id);
      if(fetchedGetOneDepositRequest!=null){
        getOneDepositRequest.value = fetchedGetOneDepositRequest;
        state.value=PageState.list;
        print('deposits:  ${getOneDepositRequest.value?.deposits?.length}');
      }else{
        state.value=PageState.empty;
      }

    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی به وجود آمده است ${e.toString()}";
    }
  }

  Future<List<dynamic>?> deleteDeposit(int depositId,bool isDeleted)async{
    try{
      isLoading.value = true;
      var response=await depositRepository.deleteDeposit(isDeleted: isDeleted, depositId: depositId);
      if(response!= null){
        Get.snackbar("موفقیت آمیز","حذف واریزی با موفقیت انجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('حذف واریزی با موفقیت انجام شد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        depositController.fetchDepositList();
        fetchGetOneDepositRequest(id.value);
      }
    }catch(e){
      throw ErrorException('خطا در حذف واریزی: $e');
    }finally {
      isLoading.value = false;
    }
    return null;
  }
}