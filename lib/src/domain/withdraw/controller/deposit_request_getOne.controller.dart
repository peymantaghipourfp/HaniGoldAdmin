

import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/deposit_request_getOne.repository.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/deposit_request.model.dart';

enum PageState{loading,err,empty,list}
class DepositRequestGetOneController extends GetxController{

  final DepositRequestGetOneRepository depositRequestGetOneRepository=DepositRequestGetOneRepository();

  var id=0.obs;
  final Rxn<DepositRequestModel> getOneDepositRequest = Rxn<DepositRequestModel>();
  Rx<PageState> state=Rx<PageState>(PageState.list);
  var isLoading=true.obs;
  var errorMessage=''.obs;

  @override
  void onInit() {
    id.value=(Get.arguments ?? 0) as int;
    print(id.value);
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
      /*if(getOneWithdraw.value==null){
        state.value=PageState.empty;
      }*/
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی به وجود آمده است ${e.toString()}";
    }
  }
}