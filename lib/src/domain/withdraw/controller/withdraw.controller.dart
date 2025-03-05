

import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/deposit_request.repository.dart';
import 'package:hanigold_admin/src/config/repository/withdraw.repository.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit_request.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';


enum PageState{loading,err,empty,list}
class WithdrawController extends GetxController{

  final WithdrawRepository withdrawRepository=WithdrawRepository();
  final DepositRequestRepository depositRequestRepository=DepositRequestRepository();

  var withdrawList=<WithdrawModel>[].obs;
  var depositRequestList=<DepositRequestModel>[].obs;

  var errorMessage=''.obs;
  var isLoading=true.obs;
  RxBool isLoadingDepositRequestList=RxBool(true);
  Rx<PageState> state=Rx<PageState>(PageState.list);
  Rx<PageState> stateDR=Rx<PageState>(PageState.list);
  RxnInt expandedIndex = RxnInt();


  void setError(String message){
    state.value=PageState.err;
    errorMessage.value=message;
  }

  @override
  void onInit() {
    fetchWithdrawList();
    super.onInit();
  }

  void toggleItemExpansion(int index) {
    if (expandedIndex.value==index) {
      expandedIndex.value=null;
    } else {
      expandedIndex.value=index;
    }
  }

  bool isItemExpanded(int index) {
    return expandedIndex.value==index;
  }

  var row=1.obs;
  void rowCount(){
    if (row.value <= depositRequestList.length) {
      row.value++;
    }
  }

  //لیست درخواست های برداشت(withdrawRequest)
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

  // لیست درخواست های واریز(depositRequest)
  Future<void> fetchDepositRequestList(int id)async{
    try{
      isLoadingDepositRequestList.value = true;
      depositRequestList.clear();
      var fetchedDepositRequestList=await depositRequestRepository.getDepositRequest(id);
      depositRequestList.assignAll(fetchedDepositRequestList);
      stateDR.value=PageState.list;
      if(depositRequestList.isEmpty){
        stateDR.value=PageState.empty;
      }
    }
    catch(e){
      stateDR.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoadingDepositRequestList.value=false;
    }
  }

}