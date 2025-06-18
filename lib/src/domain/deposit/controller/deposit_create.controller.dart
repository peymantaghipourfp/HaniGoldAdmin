
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/deposit.repository.dart';
import 'package:hanigold_admin/src/config/repository/wallet.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/deposit_request.model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:uuid/uuid.dart';

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/bank.repository.dart';
import '../../../config/repository/bank_account.repository.dart';
import '../../../config/repository/upload.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../users/model/balance_item.model.dart';
import '../../wallet/model/wallet.model.dart';
import '../../withdraw/controller/withdraw.controller.dart';
import '../../withdraw/model/bank.model.dart';
import '../../withdraw/model/bank_account.model.dart';
import '../../withdraw/model/options.model.dart';
import '../../withdraw/model/bank_account_req.model.dart';
import '../../withdraw/model/filter.model.dart';
import '../../withdraw/model/predicate.model.dart';

enum PageState{loading,err,empty,list}

class DepositCreateController extends GetxController{

  final WithdrawController withdrawController=Get.find<WithdrawController>();

  final TextEditingController ownerNameController=TextEditingController();
  final TextEditingController accountController=TextEditingController();
  final TextEditingController amountController=TextEditingController();
  final TextEditingController numberController=TextEditingController();
  final TextEditingController cardNumberController=TextEditingController();
  final TextEditingController shebaController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  final TextEditingController trackingNumberController=TextEditingController();

  final DepositRepository depositRepository=DepositRepository();
  final BankRepository bankRepository=BankRepository();
  final BankAccountRepository bankAccountRepository=BankAccountRepository();
  final WalletRepository walletRepository=WalletRepository();
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  final UploadRepositoryDesktop uploadRepositoryDesktop=UploadRepositoryDesktop();

  final List<BankModel> bankList=<BankModel>[].obs;
  final List<BankAccountModel> bankAccountList=<BankAccountModel>[].obs;
  WalletModel? walletList;
  final List<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;

  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;
  var isLoadingBalance=true.obs;

  //late DepositRequestModel depositRequest;
  final Rxn<BankAccountModel> selectedBankAccount = Rxn<BankAccountModel>();
  final Rxn<BankModel> selectedBank = Rxn<BankModel>();
  Rx<int> selectedWalletId = Rx<int>(0);
  String? selectedIndex ;
  Rx<int> selectedBankId = Rx<int>(0);
  Rx<String> selectedBankName = Rx<String>("");
  final ImagePicker _picker = ImagePicker();
  RxList<XFile?> selectedImagesDesktop = RxList<XFile?>();
  var recordId="".obs;
  var uuid = Uuid();
  RxList<bool> uploadStatusesDesktop = RxList<bool>();
  RxBool isUploadingDesktop = false.obs;
  var depositRequestId=0.obs;



  changeSelectedBank(String newValue){
    selectedIndex=newValue;
    selectedBankId.value=int.parse(newValue);
    for(int i=0 ;i<bankList.length;i++){
      if(selectedBankId.value==bankList[i].id){
        selectedBankName.value=bankList[i].name ?? "";
      }
    }
    update();
    print(selectedBankName.value);
    print( selectedBankId.value);
  }

  void changeSelectedBankAccount(BankAccountModel? newValue) {
    selectedBankAccount.value = newValue;
    selectedIndex=selectedBankAccount.value?.bank?.id.toString();
    numberController.text=selectedBankAccount.value!.number.toString();
    cardNumberController.text=selectedBankAccount.value!.cardNumber.toString();
    shebaController.text=selectedBankAccount.value!.sheba.toString();
    ownerNameController.text=selectedBankAccount.value!.ownerName.toString();

    print(selectedBankAccount.value?.bank?.name);
    print(selectedBankAccount.value?.bank?.id);
    print(selectedIndex);
  }
  @override
  void onInit() {
    DepositRequestModel depositRequest=Get.arguments;
    accountController.text=depositRequest.account?.name ?? "";
    if(depositRequest.account?.id!=null){
      getBankAccount(depositRequest.account?.id ?? 0);
      fetchWallet(depositRequest.account?.id ?? 0);
      getBalanceList(depositRequest.account?.id ?? 0);
    }
    print('accountIddddd: ${depositRequest.account?.id}');
    fetchBankList();

    var now = Jalali.now();
    DateTime date=DateTime.now();
    dateController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    super.onInit();
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
        bankAccount: OptionsModel(
            orderBy: "BankAccount.Id",
            orderByType: "desc",
            startIndex: 1,
            toIndex: 1000,
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

  Future<void> fetchWallet(int id)async{
    try{
      isLoading.value=true;
      var fetchedWalletList=await walletRepository.getWalletCurrency(id);
      walletList=fetchedWalletList as WalletModel?;
      if (walletList!=null) {
        selectedWalletId.value = walletList?.id ?? 0;
      }
    }catch(e){
      throw ErrorException('خطا:$e');
    }finally{
      isLoading.value=false;
    }
  }

  Future<void> pickImageDesktop( ) async {
    try{
      final List<XFile?> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        selectedImagesDesktop.addAll(images);
      }
    }catch(e){
      throw Exception('خطا در انتخاب فایل‌ها');
    }
  }

  Future<void> uploadImagesDesktop( String type, String entityType,) async {

    recordId.value=uuid.v4();
    if (selectedImagesDesktop.isEmpty) {
      insertDeposit(recordId.value);

    } else{
      isUploadingDesktop.value = true;
      uploadStatusesDesktop.assignAll(List.filled(selectedImagesDesktop.length, false));

      try {
        for (int i = 0; i < selectedImagesDesktop.length; i++) {
          final file = selectedImagesDesktop[i];
          if(file!=null) {
            try{
              final bytes = await file.readAsBytes();
              String success = await uploadRepositoryDesktop.uploadImageDesktop(
                imageBytes: bytes,
                fileName: file.name,
                recordId: recordId.value,
                type: type,
                entityType: entityType,
              );

              uploadStatusesDesktop[i] = success.isNotEmpty;
            }catch(e){
              Get.snackbar("خطا", "خطا در آپلود تصویر ${i + 1}");
            }
          }
        }
        if (uploadStatusesDesktop.every((status) => status)) {
          Get.snackbar("موفقیت", "همه تصاویر با موفقیت آپلود شدند");
          insertDeposit(recordId.value);
          Get.back();
        }
      } finally {
        isUploadingDesktop.value = false;
        selectedImagesDesktop.clear();
        uploadStatusesDesktop.clear();
      }
    }

  }

  Future<DepositModel?> insertDeposit(String recId)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value=true;
      String gregorianDate = convertJalaliToGregorian(dateController.text);
      DepositRequestModel depositRequest=Get.arguments;
      DepositModel response=await  depositRepository.insertDeposit(
        walletWithdrawId: depositRequest.withdrawRequest?.wallet?.id ?? 0 ,
        walletId: selectedWalletId.value,
        depositRequestId:depositRequest.id,
        //bankAccountId: selectedBankAccount.value?.id ?? 0,
        amount: double.parse(amountController.text.replaceAll(',', '').toEnglishDigit()),
        accountId:depositRequest.account?.id ?? 0,
        //accountName: depositRequest.account?.name ?? "",
        // bankId: selectedBankId.value,
        // bankName: selectedBankName.value,
        // ownerName: ownerNameController.text,
        // number: numberController.text,
        // cardNumber: cardNumberController.text,
        // sheba: shebaController.text,
        date: gregorianDate,
        trackingNumber: trackingNumberController.text,
        status: 1,
        recId:recId,
      );
      if(response.id!=null) {
        Get.back();
        Get.snackbar(response.infos?.first.title ?? "", response.infos?.first.description ?? "",
            titleText: Text(response.infos?.first.title ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(
                response.infos?.first.description ?? "", textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor)));
      }
      withdrawController.getWithdrawListPager();
      withdrawController.withdrawList.refresh();
      withdrawController.fetchDepositRequestList(depositRequest.withdrawRequest?.id ?? 0);
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا:$e');
    }finally{
      EasyLoading.dismiss();
      isLoading.value=false;
    }
    return null;
  }

  // لیست بالانس
  Future<void> getBalanceList(int id) async{
    print("getBalanceList : $id");
    balanceList.clear();
    try{
      state.value=PageState.loading;
      var response=await userInfoTransactionRepository.getBalanceList(id);
      balanceList.addAll(response);
      balanceList.removeWhere((r)=>r.balance==0);
      isLoadingBalance.value=true;
      state.value=PageState.list;
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

  void clearList(){
    accountController.clear();
    ownerNameController.clear();
    amountController.clear();
    numberController.clear();
    cardNumberController.clear();
    shebaController.clear();
    bankAccountList.clear();
    bankList.clear();
    dateController.clear();
    selectedBankAccount.value=null;

  }

}