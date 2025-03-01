

import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/withdraw.repository.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';


enum PageState{loading,err,empty,list}
class WithdrawController extends GetxController{

  final WithdrawRepository withdrawRepository=WithdrawRepository();
  var withdrawList=<WithdrawModel>[].obs;
  var errorMessage=''.obs;
  var isLoading=true.obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);

  void setError(String message){
    state.value=PageState.err;
    errorMessage.value=message;
  }

  @override
  void onInit() {
    fetchWithdrawList();
    super.onInit();
  }

  Future<void> fetchWithdrawList()async{
    try{
      state.value=PageState.loading;
      var fetchedWithdrawList=await withdrawRepository.getWithdrawList();
      withdrawList.assignAll(fetchedWithdrawList);
      state.value=PageState.list;

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