
import 'dart:async';
import 'dart:ui' as ui;

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/bank.repository.dart';
import 'package:hanigold_admin/src/config/repository/bank_account.repository.dart';
import 'package:hanigold_admin/src/config/repository/wallet.repository.dart';
import 'package:hanigold_admin/src/config/repository/withdraw.repository.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw_pending.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/options.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/bank_account_req.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/filter.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/predicate.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:uuid/uuid.dart';
import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/upload.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../account/model/account.model.dart';
import '../../order/model/tooltip_total_balance.model.dart';
import '../../users/model/balance_item.model.dart';
import '../model/bank_account.model.dart';
import 'package:universal_html/html.dart' as html;

enum PageState{loading,err,empty,list}

class WithdrawCreateController extends GetxController{
  //final formKey = GlobalKey<FormState>();

  final WithdrawController withdrawController=Get.find<WithdrawController>();
  final WithdrawPendingController withdrawPendingController=Get.find<WithdrawPendingController>();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchBankController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final FocusNode searchFocusNodeBank = FocusNode();
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
  final WalletRepository walletRepository=WalletRepository();
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  final UploadRepositoryDesktop uploadRepositoryDesktop=UploadRepositoryDesktop();

  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<BankModel> bankList=<BankModel>[].obs;
  final List<BankAccountModel> bankAccountList=<BankAccountModel>[].obs;
  final List<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;
  WalletModel? walletList;
  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;
  //var isLoadingBalance=true.obs;

  // TooltipTotalBalanceModel state variables
  final Rxn<TooltipTotalBalanceModel> tooltipTotalBalanceModel = Rxn<TooltipTotalBalanceModel>();
  var isLoadingTooltipBalance = true.obs;

  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  final Rxn<BankAccountModel> selectedBankAccount = Rxn<BankAccountModel>();
  final Rxn<BankModel> selectedBank = Rxn<BankModel>();
  Rx<int> selectedWalletId = Rx<int>(0);
  String? selectedIndex ;
  /*Rx<int> selectedBankId = Rx<int>(0);
  Rx<String> selectedBankName = Rx<String>("");*/
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;
  RxList<BankModel> searchedBanks = <BankModel>[].obs;
  Timer? debounce;
  final ImagePicker _picker = ImagePicker();
  RxList<XFile?> selectedImagesDesktop = RxList<XFile?>();
  var recordId="".obs;
  var uuid = Uuid();
  RxList<bool> uploadStatusesDesktop = RxList<bool>();
  RxBool isUploadingDesktop = false.obs;
  var dropdownError="".obs;



  void changeSelectedAccount(AccountModel? newValue) {
    //selectedBankAccount.value = null;
    selectedAccount.value = newValue;
    fetchWallet(newValue?.id ?? 0);
    /*if (newValue != null) {
      getBankAccount(newValue.id ?? 0);
      fetchWallet(newValue.id ?? 0);
    } else {
      bankAccountList.clear();
    }*/
    //getBalanceList(newValue?.id ?? 0);
    //isLoadingBalance.value=false;
    getTooltipTotalBalance(newValue?.id ?? 0);
    bankList.clear();
    fetchBankList();
    update();
  }

   changeSelectedBank(BankModel? newValue){
    selectedBank.value=newValue;

    update();
  }

  /*void changeSelectedBankAccount(BankAccountModel? newValue) {
    selectedBankAccount.value = newValue;
    selectedIndex=selectedBankAccount.value?.bank?.id.toString();
    ownerNameController.text=selectedBankAccount.value!.ownerName.toString();

    selectedBankAccount.value!.number==null ? "" :
    numberController.text=selectedBankAccount.value!.number.toString();

    selectedBankAccount.value!.cardNumber==null ? "" :
    cardNumberController.text=selectedBankAccount.value!.cardNumber.toString();

    selectedBankAccount.value!.sheba==null ? "" :
    shebaController.text=selectedBankAccount.value!.sheba.toString();

    print(selectedBankAccount.value?.bank?.name);
    print(selectedBankAccount.value?.bank?.id);
    print(selectedIndex);
  }*/

  @override
  void onInit() {
    fetchAccountList();
    fetchBankList();
    searchController.addListener(onSearchChanged);
    searchBankController.addListener(onSearchChangedBank);
    super.onInit();
  }
  void onDropdownMenuStateChange(bool isOpen) {
    if (isOpen) {
      // Add a small delay to ensure the dropdown is fully opened
      Future.delayed(const Duration(milliseconds: 100), () {
        searchFocusNode.requestFocus();
      });
    } else {
      resetAccountSearch();
    }
  }
  void onDropdownMenuStateChangeBank(bool isOpen) {
    if (isOpen) {
      // Add a small delay to ensure the dropdown is fully opened
      Future.delayed(const Duration(milliseconds: 100), () {
        searchFocusNodeBank.requestFocus();
      });
    } else {
      resetBankSearch();
    }
  }

  @override
  void onClose() {
    debounce?.cancel();
    searchController.dispose();
    searchFocusNode.dispose();
    searchFocusNodeBank.dispose();
    super.onClose();
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

  Future<void> handleDroppedFiles(List<XFile> files) async {
    try {
      // Filter only image files
      final imageFiles = files.where((file) {
        // Use file.name instead of file.path for dropped files
        final fileName = file.name.toLowerCase();
        final extension = fileName.contains('.') ? fileName.split('.').last : '';

        // Also check MIME type as a fallback
        final mimeType = file.mimeType?.toLowerCase() ?? '';
        final isImageByExtension = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
        final isImageByMimeType = mimeType.startsWith('image/');

        return isImageByExtension || isImageByMimeType;
      }).toList();

      if (imageFiles.isNotEmpty) {
        selectedImagesDesktop.addAll(imageFiles);
        Get.snackbar("موفقیت", "${imageFiles.length} تصویر اضافه شد");
      } else {
        Get.snackbar("خطا", "فقط فایل‌های تصویری قابل قبول هستند");
      }
    } catch (e) {
      Get.snackbar("خطا", "خطا در پردازش فایل‌های رها شده");
    }
  }

  Future<void> uploadImagesDesktop( String type, String entityType,) async {

    recordId.value=uuid.v4();
    if (selectedImagesDesktop.isEmpty) {
      insertWithdraw(recordId.value);
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
          insertWithdraw(recordId.value);
          Get.back();
        }
      } finally {
        isUploadingDesktop.value = false;
        selectedImagesDesktop.clear();
        uploadStatusesDesktop.clear();
      }
    }

  }

  // لیست کاربران
  Future<void> fetchAccountList() async{
    try{
      state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.getAccountList("");
      accountList.assignAll(fetchedAccountList);
      searchedAccounts.assignAll(fetchedAccountList);
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

  void onSearchChanged(){
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce=Timer(const Duration(seconds: 4), () async {
      await searchAccountList(searchController.text.trim());

    });
  }

  Future<void> searchAccountList(String name) async {
    try {
      isLoading.value = true;
      if (name.length>2) {
        searchedAccounts.assignAll(accountList);
      } else {
        final results = await accountRepository.searchAccountList(name,"");
        searchedAccounts.assignAll(results);
        state.value=PageState.list;
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در جستجوی کاربران');
    } finally {
      isLoading.value = false;
    }
  }


  //لیست بانک ها
  Future<void> fetchBankList() async{
    try{
      bankList.clear();
      state.value=PageState.loading;
      var fetchedBankList=await bankRepository.getBankList();
      bankList.assignAll(fetchedBankList);
      searchedBanks.assignAll(fetchedBankList);
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

  void onSearchChangedBank(){
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce=Timer(const Duration(seconds: 4), () async {
      await searchBankList(searchBankController.text.trim());

    });
  }

  Future<void> searchBankList(String name) async {
    try {
      isLoading.value = true;
      if (name.length>2) {
        searchedBanks.assignAll(bankList);
      } else {
        final results = await bankRepository.searchBankList(name);
        searchedBanks.assignAll(results);
        state.value=PageState.list;
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در جستجوی بانک ها');
    } finally {
      isLoading.value = false;
    }
  }

  // مدل آپشن بانک اکانت
  /*BankAccountReqModel? bankAccountReqModel;
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
  }*/

  // لیست بانک اکانت
  /*Future<void> fetchBankAccountList()async{
    try{
      state.value=PageState.loading;
      bankAccountList.clear();
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
  }*/

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

  // درج درخواست
Future<WithdrawModel?> insertWithdraw(String recId)async{
  EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoading.value = true;
      var response = await withdrawRepository.insertWithdraw(
        walletId: selectedWalletId.value,
          itemId: walletList?.item?.id ?? 0,
          itemName: walletList?.item?.name ?? "",
          accountId: selectedAccount.value?.id ?? 0,
          accountName: selectedAccount.value?.name ?? "",
          //bankAccountId: selectedBankAccount.value?.id ?? 0,
          bankId: selectedBank.value?.id ?? 0,
          bankName: selectedBank.value?.name ?? "",
          ownerName: ownerNameController.text,
          amount: double.parse(amountController.text.replaceAll(',', '').toEnglishDigit()),
          number: numberController.text,
          cardNumber: cardNumberController.text,
          sheba: shebaController.text,
          description: descriptionController.text,
        date: DateTime.now().toIso8601String(),
        status: 1,
        recId:recId,
      );
      //print(response);
      if (response != null) {
        //Get.toNamed('/withdrawsList');
        Get.snackbar("موفقیت آمیز", "درج با موفقیت آنجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(
                'درج با موفقیت آنجام شد', textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.textColor)));
        withdrawController.getWithdrawListPager();
        withdrawPendingController.getWithdrawListStatusPager();
        balanceList.clear();
        clearList();
      }
    }
    catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا:$e');
    }finally{
      EasyLoading.dismiss();
      isLoading.value=false;
    }
    return null;
  }

  // لیست بالانس
  /*Future<void> getBalanceList(int id) async{
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
  }*/

  // دریافت تراز کامل کاربر
  Future<void> getTooltipTotalBalance(int accountId) async {
    print("getTooltipTotalBalance : $accountId");
    if (accountId == 0) {
      tooltipTotalBalanceModel.value = null;
      isLoadingTooltipBalance.value = false;
      return;
    }
    try {
      isLoadingTooltipBalance.value = true;
      final result = await withdrawController.getTooltipTotalBalance(accountId);
      tooltipTotalBalanceModel.value = result;
      print("TooltipTotalBalance fetched successfully");
    } catch (e) {
      print('Error fetching tooltip balance: $e');
      tooltipTotalBalanceModel.value = null;
    } finally {
      isLoadingTooltipBalance.value = false;
    }
  }

  void clearList(){

    ownerNameController.clear();
    amountController.clear();
    numberController.clear();
    cardNumberController.clear();
    shebaController.clear();
    selectedAccount.value=null;
    selectedBank.value=null;
    descriptionController.clear();
    // Clear tooltip balance data
    tooltipTotalBalanceModel.value = null;
    isLoadingTooltipBalance.value = true;
  }
  void resetAccountSearch() {
    searchController.clear();
    searchedAccounts.assignAll(accountList);
  }
  void resetBankSearch() {
    searchBankController.clear();
    searchedBanks.assignAll(bankList);
  }

  Future<void> captureBalanceScreenshot(BuildContext context, GlobalKey balanceKey) async {
    try {
      RenderRepaintBoundary boundary = balanceKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        if (kIsWeb) {
          final blob = html.Blob([pngBytes], 'image/png');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', 'user_balance_screenshot_${selectedAccount.value?.name}.png')
            ..click();
          html.Url.revokeObjectUrl(url);
          Get.snackbar('موفق', 'اسکرین شات با موفقیت ذخیره شد.');
        } else {
          await FileSaver.instance.saveFile(
            name: "user_balance_screenshot_${selectedAccount.value?.name}",
            bytes: pngBytes,
            fileExtension: 'png',
            mimeType: MimeType.png,
          );
          Get.snackbar('موفق', 'اسکرین شات با موفقیت ذخیره شد.');
        }
      }
    } catch (e) {
      Get.snackbar('خطا', 'ثبت اسکرین شات ناموفق بود: $e');
    }
  }

}