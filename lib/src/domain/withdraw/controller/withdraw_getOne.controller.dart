

import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';

import '../../../config/repository/account.repository.dart';
import '../../../config/repository/withdraw.repository.dart';
import '../../../config/repository/withdraw_getOne.repository.dart';
import '../../account/model/account.model.dart';
import '../model/withdraw.model.dart';

enum PageState{loading,err,empty,list}
class WithdrawGetOneController extends GetxController{

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
    super.onInit();
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
      state.value=PageState.loading;
      var fetchedWithdrawList=await withdrawRepository.getWithdrawList();
      withdrawList.assignAll(fetchedWithdrawList);
      state.value=PageState.list;
      /*if(withdrawList.isEmpty){
        state.value=PageState.empty;
      }*/
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }

}