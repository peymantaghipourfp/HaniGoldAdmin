
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/bank.repository.dart';
import 'package:hanigold_admin/src/config/repository/bank_account.repository.dart';
import 'package:hanigold_admin/src/config/repository/withdraw.repository.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank_account_options.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank_account_req.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/filter.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/predicate.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';
import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../account/model/account.model.dart';
import '../model/bank_account.model.dart';

enum PageState{loading,err,empty,list}

class WithdrawCreateController extends GetxController{
  //final formKey = GlobalKey<FormState>();

  final WithdrawController withdrawController=WithdrawController();

  final TextEditingController bankNameController=TextEditingController();
  final TextEditingController ownerNameController=TextEditingController();
  final TextEditingController amountController=TextEditingController();
  final TextEditingController numberController=TextEditingController();
  final TextEditingController cardNumberController=TextEditingController();
  final TextEditingController shebaController=TextEditingController();
  final TextEditingController descriptionController=TextEditingController();

  final AccountRepository accountRepository=AccountRepository();
  final BankRepository bankRepository=BankRepository();
  final BankAccountRepository bankAccountRepository=BankAccountRepository();
  final WithdrawRepository withdrawRepository=WithdrawRepository();

  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<BankModel> bankList=<BankModel>[].obs;
  final List<BankAccountModel> bankAccountList=<BankAccountModel>[].obs;

  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;

  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  final Rxn<BankAccountModel> selectedBankAccount = Rxn<BankAccountModel>();


  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;
    getBankAccount(selectedAccount.value!.id ?? 0);
  }
  void changeSelectedBank(BankAccountModel? newValue) {
    selectedBankAccount.value = newValue;
    bankNameController.text=selectedBankAccount.value!.bank!.name.toString();
    ownerNameController.text=selectedBankAccount.value!.ownerName.toString();
    numberController.text=selectedBankAccount.value!.number.toString();
    cardNumberController.text=selectedBankAccount.value!.cardNumber.toString();
    shebaController.text=selectedBankAccount.value!.sheba.toString();
  }


  @override
  void onInit() {
    fetchAccountList();
    fetchBankList();
    super.onInit();
  }

  // لیست کاربران
  Future<void> fetchAccountList() async{
    try{
      state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.getAccountList();
      accountList.assignAll(fetchedAccountList);
      state.value=PageState.list;
      if(accountList.isEmpty){
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
  //لیست بانک ها
  Future<void> fetchBankList() async{
    try{
      state.value=PageState.loading;
      var fetchedBankList=await bankRepository.getBankList();
      bankList.assignAll(fetchedBankList);
      state.value=PageState.list;
      if(bankList.isEmpty){
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

  // مدل آپشن بانک اکانت
  BankAccountReqModel? bankAccountReqModel;
  getBankAccount(int id){
    bankAccountReqModel=BankAccountReqModel(
        bankAccount: BankAccountOptionsModel(
            orderBy: "BankAccount.Id",
            orderByType: "asc",
            startIndex: 1,
            toIndex: 10,
          predicate: [PredicateModel(
              innerCondition: 0,
              outerCondition: 0,
              filters: [FilterModel(
                  fieldName: "AccountId",
                  filterValue: id.toString(),
                  filterType: 4,
                  refTable: "BankAccount"
              )
              ]
          )
          ]
        )
    );
    fetchBankAccountList();
  }

  // لیست بانک اکانت
  Future<void> fetchBankAccountList()async{
    try{
      state.value=PageState.loading;
      var fetchedBankAccountList=await bankAccountRepository.getBankAccountList(bankAccountReqModel!);
      bankAccountList.assignAll(fetchedBankAccountList);
      state.value=PageState.list;
      if(bankAccountList.isEmpty){
        state.value=PageState.empty;
      }
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=e.toString();
    }
  }

  // درج درخواست
Future<WithdrawModel?> insertWithdraw()async{
    try {
      isLoading.value = true;
      var response = await withdrawRepository.insertWithdraw(
          accountId: selectedAccount.value?.id ?? 0,
          accountName: selectedAccount.value?.name ?? "",
          bankAccountId: selectedBankAccount.value?.id ?? 0,
          bankId: selectedBankAccount.value?.bank?.id ?? 0,
          bankName: bankNameController.text,
          ownerName: ownerNameController.text,
          amount: double.tryParse(amountController.text) ?? 0.0,
          number: numberController.text,
          cardNumber: cardNumberController.text,
          sheba: shebaController.text,
          description: descriptionController.text
      );
      print(response);
      if (response != null) {
        Get.toNamed('/withdrawsList');
        Get.snackbar("موفقیت آمیز", "درج با موفقیت آنجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(
                'درج با موفقیت آنجام شد', textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor)));
        clearList();
        withdrawController.fetchWithdrawList();
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }finally{
      isLoading.value=false;
    }
    return null;
  }

  void clearList(){
    bankNameController.clear();
    ownerNameController.clear();
    amountController.clear();
    numberController.clear();
    cardNumberController.clear();
    shebaController.clear();
    selectedAccount.value=null;
    selectedBankAccount.value=null;
  }

}