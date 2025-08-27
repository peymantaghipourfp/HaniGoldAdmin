
import 'package:get/get.dart';

import '../../../config/repository/user_info_transaction.repository.dart';
import '../../users/model/balance_item.model.dart';

enum PageState{loading,err,empty,list}

class InventoryCreateLayoutController extends GetxController{

  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  final List<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;
  var isLoadingBalance=true.obs;

  Rx<PageState> state=Rx<PageState>(PageState.list);


  // لیست بالانس
  Future<void> getBalanceList(int id) async{
    print("getBalanceList : $id");
    isLoadingBalance.value=false;
    balanceList.clear();
    try{
      state.value=PageState.loading;
      var response=await userInfoTransactionRepository.getBalanceList(id);
      balanceList.addAll(response);
      balanceList.removeWhere((r)=>r.balance==0);
      state.value=PageState.list;
      isLoadingBalance.value=true;
      if(balanceList.isEmpty){
        state.value=PageState.empty;
      }
      update();
    }
    catch(e){
      state.value=PageState.err;
    }finally{
    }
  }

}